//
//  Even_PayManager.m
//  jishijian
//
//  Created by Even on 2017/6/12.
//  Copyright © 2017年 JiShiJian. All rights reserved.
//

#import "Even_PayManager.h"
#import "Even_PayErrorUtils.h"
#import "NSString+Hash.h"

@implementation Even_PayManager

+(instancetype)sharePayManager{
    
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[Even_PayManager alloc]init];
    });
    
    return instance;
}


-(void)payWithChannel:(PayChannel)payChannel andAmount:(long)amount andPayType:(PayType)payType andPayId:(NSString*)pid andDescription:(NSString*)description andController:(UIViewController*)controller CompleteBlock:(Even_PayComplation)completeBlock{

    //拼接请求支付的参数
    NSDictionary* paramsDic = @{@"paid":[NSString stringWithFormat:@"%ld", payChannel],@"pid":pid ? : @"", @"desc" : description ? : @"" ,@"amount":[NSNumber numberWithLong:amount],@"type":[NSNumber numberWithInteger:payType]};

    //验证支付身份
    [HttpUtils postWithParams:paramsDic callback:^(NSString *result) {
        
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSString* msg = resultDic[@"msg"];
        
        if ([msg isEqualToString:@"success"]) {
            
            //支付
            [[Even_PayEngine sharedEngine] payWithCharge:result controller:controller scheme:@"Even_PaySDK" withComplation:completeBlock];
            
        } else {
        
            completeBlock(nil,[Even_PayErrorUtils create:Even_PayErrorServerVerifyError]);
        }
    }];
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
