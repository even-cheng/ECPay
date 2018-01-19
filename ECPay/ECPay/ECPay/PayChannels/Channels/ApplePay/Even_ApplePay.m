//
//  Even_ApplePay.m
//  ECPay
//
//  Created by Even on 2018/1/10.
//  Copyright © 2018年 Even-Cheng. All rights reserved.
//

#import "Even_ApplePay.h"

@interface Even_ApplePay ()

@property (nonatomic) Even_PayComplation complation;

@end

@implementation Even_ApplePay

//业务方法一：需要调用支付接口
-(void)payWithCharge:(Even_Charge*)charge controller:(UIViewController*)controller scheme:(NSString*)scheme withComplation:(Even_PayComplation)complation{
    
    _complation = complation;
    
}

#pragma mark- 协议方法
//业务方法三：需要处理支付结果回调(钱包支付没有)
- (BOOL)handleOpenURL:(NSURL *)url withComplation:(Even_PayComplation)complation{
    return [self handleOpenURL:url sourceApplication:nil withComplation:complation];
}
//支付回调
//业务方法二：需要处理支付结果回调(钱包支付没有)
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {
    
    return YES;
}

//处理支付结果回调(9.0以前)
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication withComplation:(Even_PayComplation)complation;{
    
    return  YES;
}

@end
