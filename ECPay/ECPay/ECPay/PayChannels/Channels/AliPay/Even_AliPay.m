//
//  Even_AliPay.m
//  IntegratePayProject
//
//  Created by Even on 2017/5/27.
//  Copyright © 2017年 Cube. All rights reserved.
//

#import "Even_AliPay.h"
#import "WXApi.h"
#import "ResString.h"
#import "Even_PayErrorUtils.h"
#import "Order.h"
#import "AlipayHeader.h"

@interface Even_AliPay ()<WXApiDelegate>

@property (nonatomic) Even_PayComplation complation;

@end

@implementation Even_AliPay

//业务方法一：需要调用支付接口
-(void)payWithCharge:(Even_Charge*)charge controller:(UIViewController*)controller scheme:(NSString*)scheme withComplation:(Even_PayComplation)complation{
    
    _complation = complation;
    
    [[AlipaySDK defaultService] payOrder:charge.signString fromScheme:kAppScheme callback:^(NSDictionary *resultDic) {
        
        //支付异常判断
        [self aliPayResult:resultDic];
    }];
}

//业务方法三：需要处理支付结果回调(9.0以后回调)
- (BOOL)handleOpenURL:(NSURL *)url withComplation:(Even_PayComplation)complation{
    return [self handleOpenURL:url sourceApplication:nil withComplation:complation];
}

//支付回调
//业务方法二：需要处理支付结果回调(9.0以前回调)
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication withComplation:(Even_PayComplation)complation{
    
    if (complation) {
        _complation = complation;
    }
 
    //如果极简开发包不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给开发包
    if ([url.host isEqualToString:@"safepay"]) {
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            
            [self aliPayResult:resultDic];
        }];
        
    } else  if ([url.host isEqualToString:@"platformapi"]){//支付宝钱包快登授权返回authCode
        
        [[AlipaySDK defaultService] processAuthResult:url standbyCallback:^(NSDictionary *resultDic) {
            //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            [self aliPayResult:resultDic];
        }];
    }
    
    return YES;
}



#pragma mark -- 处理 支付宝支付结果
- (void)aliPayResult:(NSDictionary*)resultDic {
    
    NSString* resultStatus = resultDic[@"resultStatus"];
    
    if ([resultStatus isEqualToString:@"9000"]) {
        
        _complation(STR_PAY_SUCCESS,nil);
        
    } else if ([resultStatus isEqualToString:@"8000"]) {
        
        _complation(STR_PAY_HOLD,nil);
        
    } else if ([resultStatus isEqualToString:@"6001"]) {
        
        _complation(resultDic[@"memo"],[Even_PayErrorUtils create:Even_PayErrorCancelled]);
        
    } else if ([resultStatus isEqualToString:@"4000"]) {
        
        _complation(resultDic[@"memo"],[Even_PayErrorUtils create:Even_PayErrorNullOrder]);
        
    } else {
        
        _complation(resultDic[@"memo"],[Even_PayErrorUtils create:Even_PayErrorUnknownError]);
    }
        
}


//如果签名放在本地则需要执行以下操作(不建议)
//    //创建订单模型
//    Order *order = [Order order];
//    order.partner = partner;
//    order.seller = seller;
//    order.productName = productName;
//    order.productDescription = productDescription;
//    order.amount = amount;
//    order.notifyURL = notifyURL;
//    order.service = service;
//    order.paymentType = paymentType;
//    order.inputCharset = inputCharset;
//    order.excessTime = excessTime;

      //这里要从服务器获取支付单号
//    order.tradeNO = orderID;
//    
//    // 将商品信息拼接成字符串
//    NSString *orderSpec = [order description];
//    
//    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
//    NSString *signedString = [self genSignedStringWithPrivateKey:kPrivateKey OrderSpec:orderSpec];
//    
//    // 调用支付接口
//    [self  aliPayWithAppScheme:kAppScheme orderSpec:orderSpec signedString:signedString callback:^(NSDictionary *resultDic) {
//        
//
//    }];


// 生成签名字符串
//- (NSString *)genSignedStringWithPrivateKey:(NSString *)privateKey OrderSpec:(NSString *)orderSpec {
//    
//    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循 RSA 签名规范, 并将签名字符串 base64 编码和 UrlEncode
//    
//    id<DataSigner> signer = CreateRSADataSigner(privateKey);
//    return [signer signString:orderSpec];
//}


// 支付(本地未安装支付宝客户端，或未成功调用支付宝客户端进行支付的情况下（走H5收银台)
//- (void)aliPayWithAppScheme:(NSString *)appScheme orderSpec:(NSString *)orderSpec signedString:(NSString *)signedString callback:(void (^)(NSDictionary *))back {
//    
//    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
//    NSString *orderString = nil;
//    if (signedString != nil) {
//        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"", orderSpec, signedString, @"RSA"];
//        
//        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            
//
//        }];
//    }
//    
//}
@end
