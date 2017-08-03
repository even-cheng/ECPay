//
//  Even_PayEngine.m
//  IntegratePayProject
//
//  Created by Even on 2017/5/27.
//  Copyright © 2017年 Cube. All rights reserved.
//

#import "Even_PayEngine.h"
#import "Even_ParsingContext.h"
#import "Even_JsonParsing.h"
#import "Even_Channel.h"
#import "Even_UnionPay.h"
#import "Even_WxPay.h"
#import "Even_AliPay.h"
#import "Even_WalletPay.h"
#import "Even_PayErrorUtils.h"
#import "AlipayHeader.h"

@interface Even_PayEngine ()

//存储支付渠道
@property (nonatomic) NSDictionary* channelDic;
@property (nonatomic) NSString* channel;

@end

@implementation Even_PayEngine

+(instancetype)sharedEngine{
    static Even_PayEngine* payEngine;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        payEngine = [[self alloc] init];
    });
    return payEngine;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self registerChannel];
    }
    return self;
}

//注册支付渠道
-(void)registerChannel{
    _channelDic = @{PAY_WALLETPAY_Key : [[Even_WalletPay alloc] init],
                    PAY_UNIONPAY_Key : [[Even_UnionPay alloc] init],
                    PAY_WXPAY_Key : [[Even_WxPay alloc] init],
                    PAY_ALIPAY_Key : [[Even_AliPay alloc] init]};
}

//处理支付
-(void)payWithCharge:(NSString*)charge controller:(UIViewController*)controller scheme:(NSString*)scheme withComplation:(Even_PayComplation)complation{
    
    //验证Controller是否为空
    if (controller == nil) {
        complation(nil,[Even_PayErrorUtils create:Even_PayErrorViewControllerIsNil]);
        return;
    }
    
    //解析
    Even_ParsingContext* context = [[Even_ParsingContext alloc] initWithParsing:[[Even_JsonParsing alloc] init]];
    Even_Charge* chargeObj = [context parsing:charge];
    _channel = chargeObj.channel;
    
    //验证付款对象(支付对象)
    if (![Even_PayErrorUtils invalidCharge:chargeObj withComplation:complation]) {
        return;
    }
    
    //唤起支付
    id<Even_IPay> pay = [_channelDic objectForKey:chargeObj.channel];
    if (pay == nil) {
        complation(nil,[Even_PayErrorUtils create:Even_PayErrorInvalidChannel]);
        return;
    }
    
    [pay payWithCharge:chargeObj controller:controller scheme:scheme withComplation:complation];
}

//处理回调
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication withComplation:(Even_PayComplation)complation{
    return [[_channelDic objectForKey:_channel] handleOpenURL:url sourceApplication:sourceApplication withComplation:complation];;
}

- (BOOL)handleOpenURL:(NSURL *)url withComplation:(Even_PayComplation)complation{
    return [[_channelDic objectForKey:_channel] handleOpenURL:url sourceApplication:nil withComplation:complation];
}


@end
