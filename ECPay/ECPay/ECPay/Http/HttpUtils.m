//
//  HttpUtils.m
//  IntegratePayProject
//
//  Created by Even on 2017/5/18.
//  Copyright © 2017年 Tz. All rights reserved.
//

#import "HttpUtils.h"
#import "Even_Channel.h"
#import "NSString+Hash.h"
#import "INBRSA.h"
#import "NSData+INB.h"

#define kConfirmPayUrl @"pay/confirmPay"  //支付验证接口
#define kAppendSecret @"1234567890"       //加密字符串(相当于加盐)
#define kBaseUrlStr @"www.自己服务器地址.com/"

@implementation HttpUtils

+(void)postWithParams:(NSDictionary*)params callback:(Callback)callback{
    
    //加密需要(由前端和后台自己制定,非必须)
    NSMutableDictionary* secretParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [secretParams addEntriesFromDictionary:@{@"secret":kAppendSecret}];
   
    //排序(根据业务来订,此处用到json字符串签名,顺序和服务端验证的顺序需要一致)
    NSArray *keyArray = @[@"uid",@"amount",@"pid",@"type",@"desc",@"pwd",@"secret"];
    NSMutableArray *jsonArray = [NSMutableArray array];
    for (int i = 0; i < keyArray.count; i++) {
        
        NSString* key = keyArray[i];
        id value = [secretParams objectForKey:key];
        if (value) {
            
            NSDictionary* dic = @{key:value};
            NSString* jsonStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:nil] encoding:NSUTF8StringEncoding];
            [jsonArray addObject:[[jsonStr stringByReplacingOccurrencesOfString:@"{" withString:@""] stringByReplacingOccurrencesOfString:@"}" withString:@""]];
        }
    }
    NSString *secretStr = [[@"{" stringByAppendingString:[jsonArray componentsJoinedByString:@","]] stringByAppendingString:@"}"];
    
    
    //第一步：创建URL地址
    NSString* baseStr = [kBaseUrlStr stringByAppendingString:kConfirmPayUrl];
    NSURL* url = [[NSURL alloc] initWithString:baseStr];
    
    //第二步：创建请求
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    //第三步：设置（绑定）请求参数(AFNetwork内部实现也是这样的)
    request.HTTPMethod = @"POST";
    
    //设置请求体
    NSData* data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    request.HTTPBody = [NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])];
    
    //设置请求头
    [request setValue:[secretStr md5String] forHTTPHeaderField:@"X-PAYSECRET"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //签名
    NSData* degital = [self digitalSignatureWithString:secretStr];
    NSString* degitalStr = [degital base64EncodedStringWithOptions:0];
    [request setValue:degitalStr forHTTPHeaderField:@"X-SIGNATURE"];
    
    //第四步：创建请求回话
    NSURLSession* session = [NSURLSession sharedSession];
    
    //第五步：根据回话创建请求任务
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        //第七步：处理返回结果
        if (error != nil) {
            
            NSLog(@"请求失败...");
            callback(@"请求失败...");
            
        } else {
            NSLog(@"请求成功...");
            //回调
            NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            callback(result);
        }
    }];
    
    //第六步：执行任务
    [task resume];
}



/**
 *  数字签名
 */
+ (NSData*)digitalSignatureWithString:(NSString*)text{
   
    //test.p12是RSA的密钥,具体生成方式请参照我的博客:https://even-cheng.github.io/2016/06/18/iOS%20开发中常见的加密及应用/
    INBRSA *rsa = [INBRSA sharedINBRSA];
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"test" ofType:@"p12"];
    bool result = [rsa keysFromData:[NSData dataWithContentsOfFile:path] password:@"123456"];
    if (!result) {
        NSLog(@"获取秘钥失败");
        return nil;
    }
    
    NSData* plainData = [text dataUsingEncoding:NSUTF8StringEncoding];
    
    NSNumber *padding = @(kSecPaddingPKCS1SHA256);
    rsa.padding = padding.unsignedIntValue;
    NSLog(@"padding - %x", rsa.padding);
    NSLog(@"rsa private key - %@", rsa.privateKey);
    NSLog(@"rsa public  key - %@", rsa.publicKey);
    NSData *sigData = [rsa signDataWithPrivateKey:plainData];
    if (!sigData) {
    
        NSLog(@"签名失败");
        return nil;
    }
    BOOL success = [rsa verifyDataWithPublicKey:plainData digitalSignature:sigData];
    if (!success) {
        
        NSLog(@"验签失败");
        return nil;
    }
    
    return sigData;
}


/**
 *  RSA
 */
+ (NSString*)RSAWithStr:(NSString*)text andDegitalData:(NSData*)plainData{
    
    INBRSA *rsa = [INBRSA sharedINBRSA];
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"test" ofType:@"p12"];
    if (!path) {
        
        NSLog(@"未能找到p12文件");
        return nil;
    }
    bool success = [rsa keysFromData:[NSData dataWithContentsOfFile:path] password:@"123456"];
    if (!success) {
        
        NSLog(@"未能成功获取RSA公私钥");
        return nil;
    }
    NSLog(@"rsa private key - %@", rsa.privateKey);
    NSLog(@"rsa public  key - %@", rsa.publicKey);
    size_t privateBlockSize = SecKeyGetBlockSize(rsa.privateKey);
    size_t publicBlockSize = SecKeyGetBlockSize(rsa.publicKey);
    NSLog(@"分组大小: %zd %zd", privateBlockSize, publicBlockSize);
    NSData *cipherData = [rsa encryptDataWithPublicKey:plainData];
    NSData *plainData_ = [rsa decryptDataWithPrivateKey:cipherData];
    NSString *textDecode = [[NSString alloc] initWithData:plainData_ encoding:NSUTF8StringEncoding];
    NSLog(@"text - |%@|", text);
    if (![textDecode isEqualToString:text]) {
        
        NSLog(@"RSA: 原始数据与解密出来的数据不一致");
        return nil;
    }
    
    
    NSString* base64 = [cipherData base64EncodedStringWithOptions:0];
    
    return base64;
}

@end
