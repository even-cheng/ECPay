//
//  Pay.h
//  IntegratePayProject
//
//  Created by Even on 2017/5/31.
//  Copyright © 2017年 Cube. All rights reserved.
//

#ifndef Pay_h
#define Pay_h

#import "HttpUtils.h"
#import "Even_PayEngine.h"
#import "Even_Channel.h"
#import "Even_PayManager.h"

//支付类型(可扩展)
typedef enum : NSUInteger {
    PayType_Wallet_In = 0,     //充值
    PayType_PayFor_Goods,      //购买商品
    PayType_PayFor_Tip,        //付小费
    PayType_PayFor_RedPacket,  //发红包
} PayType;

typedef enum : NSUInteger {
    PayChannel_walletPay = PAY_CHANNEL_WALLETPAY,//本地钱包支付
    PayChannel_aliPay = PAY_CHANNEL_ALIPAY,     //支付宝
    PayChannel_weixinPay = PAY_CHANNEL_WXPAY,   //微信支付
    PayChannel_unionPay = PAY_CHANNEL_UNIONPAY, //银联支付
    PayChannel_ApplePay = PAY_CHANNEL_APPLE, //苹果支付
    PayChannel_InAppPay = PAY_CHANNEL_IAP, //苹果应用内支付(非苹果支付)
} PayChannel;

#endif /* Pay_h */

