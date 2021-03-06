//
//  Even_WalletPay.m
//  jishijian
//
//  Created by Even on 2017/5/31.
//  Copyright © 2017年 JiShiJian. All rights reserved.
//

#import "Even_WalletPay.h"
#import "ResString.h"
#import "Even_PayErrorUtils.h"
#import "WalletPayPasswordView.h"
#import "ECPayConfig.h"

@interface Even_WalletPay ()

@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, strong) WalletPayPasswordView *payPasswordView;
@property (nonatomic) Even_PayComplation complation;

@end

@implementation Even_WalletPay

//业务方法一：需要调用支付接口
-(void)payWithCharge:(Even_Charge*)charge controller:(UIViewController*)controller scheme:(NSString*)scheme withComplation:(Even_PayComplation)complation{
    
    _complation = complation;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:charge.credential];
    
    if ([NSThread currentThread].isMainThread) {
        
        [self payWithParams:params];
        
    } else {
    
        //调用支付
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self payWithParams:params];
        });
    }
}

//唤起密码键盘
-(void)payWithParams:(NSMutableDictionary*)params{

    self.payPasswordView = [WalletPayPasswordView sharedPayPasswordView];

//        __weak typeof(self) weakSelf = self;;
    [self.payPasswordView showPasswordViewWithFee:100 andPayPwdBlock:^(NSString *pwd) {

        //进行支付操作
//            [HttpUtils postWithParams:params callback:^(NSString *result) {
//                NSDictionary* dic = [result mj_JSONObject];
//                Even_PayError* error = [self getErrorWithCode:[[dic objectForKey:@"code"] integerValue]];
//
//                if (weakSelf.complation) {
//
//                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                        [weakSelf.payPasswordView removeWalletView];
//                        weakSelf.complation([dic objectForKey:@"msg"],error);
//                    });
//                }
//            }];

    }];
}


-(Even_PayError*)getErrorWithCode:(NSInteger)code{

    switch (code) {
        
        case 1: //支付成功
            return nil;
            break;
            
        case 514: //支付密码错误
            return [Even_PayErrorUtils create:Even_PayErrorSendErrorPwd];
            break;
            
        case 510: //钱包余额不足
            return [Even_PayErrorUtils create:Even_PayErrorDidNotHaveEnoughMoney];
            break;
            
        case 515: //支付密码错误超过三次
            return [Even_PayErrorUtils create:Even_PayErrorSendErrorPwdForThreeTimes];
            break;
            
        case 501: //token
            return [Even_PayErrorUtils create:Even_PayErrorServerVerifyError];
            break;

        case 800: //重复支付
            return [Even_PayErrorUtils create:Even_PayErrorRePay];
            break;

        default:
            return [Even_PayErrorUtils create:Even_PayErrorUnknownError];;
            break;
    }
}






#pragma mark- 协议方法,钱包支付不用
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
