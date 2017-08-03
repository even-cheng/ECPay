//
//  Even_PayManager.h
//  jishijian
//
//  Created by Even on 2017/6/12.
//  Copyright © 2017年 JiShiJian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pay.h"

typedef enum : NSUInteger {
    PayType_Wallet_In = 0, //充值
    PayType_Wall_BuyService,   //购买服务
    PayType_Wallet_BuyHelp,//购买帮助
    PayType_Wallet_TipFee,//小费
    PayType_Wallet_PayOrder,//支付任务
    PayType_Wallet_PayForOffer,//报价单
    PayType_Wallet_PayForRedPacket,//发红包
} PayType;

typedef enum : NSUInteger {
    PayChannel_walletPay = PAY_CHANNEL_WALLETPAY,//钱包支付
    PayChannel_aliPay = PAY_CHANNEL_ALIPAY, //支付宝
    PayChannel_weixinPay = PAY_CHANNEL_WXPAY, //微信支付
    PayChannel_unionPay = PAY_CHANNEL_UNIONPAY //银联支付
} PayChannel;

@interface Even_PayManager : NSObject

+(instancetype)sharePayManager;

/**
 支付统一入口

 @param payChannel 支付方式    
 @param amount 费用(分)
 @param payType 支付方式
 @param rid 业务id或者对方的uid
 @param description 商品描述
 @param completeBlock 支付结果回调
 */
-(void)payWithChannel:(PayChannel)payChannel
            andAmount:(long)amount
           andPayType:(PayType)payType
             andPayId:(NSString*)rid
       andDescription:(NSString*)description
        andController:(UIViewController*)controller
        CompleteBlock:(Even_PayComplation)completeBlock;


@end
