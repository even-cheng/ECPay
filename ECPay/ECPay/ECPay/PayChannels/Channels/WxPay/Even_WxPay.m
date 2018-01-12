//
//  Even_WxPay.m
//  IntegratePayProject
//
//  Created by Even on 2017/5/27.
//  Copyright © 2017年 Cube. All rights reserved.
//

#import "Even_WxPay.h"
#import "WXApi.h"
#import "ResString.h"
#import "Even_PayErrorUtils.h"

@interface Even_WxPay ()<WXApiDelegate>

@property (nonatomic) Even_PayComplation complation;

@end

@implementation Even_WxPay

- (instancetype)init{
    self = [super init];
    if (self) {
        BOOL isSuccess = [WXApi registerApp:@"wx4906d2c68dbdb658"];
        if (isSuccess) {
            NSLog(@"注册成功！");
        }
    }
    return self;
}

//业务方法一：需要调用微信支付接口(唤醒微信支付)
-(void)payWithCharge:(Even_Charge*)charge controller:(UIViewController*)controller scheme:(NSString*)scheme withComplation:(Even_PayComplation)complation{
    
    _complation = complation;
    if (![WXApi isWXAppInstalled]) {
        complation(nil,[Even_PayErrorUtils create:Even_PayErrorWxNoInstalled]);
        return;
    }
    
    NSString* timeStamp = [NSString stringWithFormat:@"%@",[charge.credential objectForKey:@"timeStamp"]];
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = [charge.credential objectForKey:@"partnerId"];
    request.prepayId= [charge.credential objectForKey:@"prepayId"];
    request.package = @"Sign=WXPay";
    request.nonceStr= [charge.credential objectForKey:@"nonceStr"];
    request.timeStamp= [timeStamp intValue];
    request.sign= [charge.credential objectForKey:@"paySign"];
    [WXApi sendReq:request];
}

//业务方法二：需要处理支付结果回调(9.0以前回调)
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication withComplation:(Even_PayComplation)complation{
    if (complation) {
        _complation = complation;
    }
    return [WXApi handleOpenURL:url delegate:self];
}

//业务方法三：需要处理支付结果回调(9.0以后回调)
- (BOOL)handleOpenURL:(NSURL *)url withComplation:(Even_PayComplation)complation{
    return [self handleOpenURL:url sourceApplication:nil withComplation:complation];
}

-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                _complation(STR_PAY_SUCCESS,nil);
                break;
            case WXErrCodeCommon:
                _complation(nil,[Even_PayErrorUtils create:Even_PayErrorUnknownError]);
                break;
            case WXErrCodeUserCancel:
                _complation(nil,[Even_PayErrorUtils create:Even_PayErrorCancelled]);
                break;
            default:
                _complation(nil,[Even_PayErrorUtils create:Even_PayErrorCancelled]);
                break;
        }
    }
}

@end
