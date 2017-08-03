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


-(void)payWithChannel:(PayChannel)payChannel andAmount:(long)amount andPayType:(PayType)payType andPayId:(NSString*)rid andDescription:(NSString*)description andController:(UIViewController*)controller CompleteBlock:(Even_PayComplation)completeBlock{

    //请求支付
    NSDictionary* paramsDic = @{@"paid":[NSNumber numberWithInteger:payChannel],@"rid":rid?rid:@"",@"tag":description?description:@"",@"cent":[NSNumber numberWithLong:amount],@"uid":[UserViewModel currenUser].uid,@"type":[NSNumber numberWithInteger:payType]};

    if (payChannel == PayChannel_walletPay) {
        
        [[Even_PayEngine sharedEngine] payWithCharge:[paramsDic mj_JSONString] controller:controller scheme:@"Even_PaySDK" withComplation:completeBlock];
        return;
    }
    
    //请求支付
    [HttpUtils postWithParams:paramsDic callback:^(NSString *result) {
        
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSString* msg = resultDic[@"msg"];
        
        if ([msg isEqualToString:@"success"]) {
            
            [[Even_PayEngine sharedEngine] payWithCharge:result controller:controller scheme:@"Even_PaySDK" withComplation:completeBlock];
        } else {
        
            completeBlock(nil,[Even_PayErrorUtils create:Even_PayErrorServerVerifyError]);
        }
    }];
}

@end
