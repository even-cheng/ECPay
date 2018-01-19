//
//  Even_PayManager.h
//  jishijian
//
//  Created by Even on 2017/6/12.
//  Copyright © 2017年 JiShiJian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pay.h"

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

@interface Even_PayManager : NSObject

+(instancetype)sharePayManager;

#warning 注意block内循环引用导致控制器无法释放问题
/**
 支付统一入口

 @param payChannel 支付方式    
 @param amount 费用(分)
 @param payType 支付方式
 @param pid 业务id或者收款方的用户id
 @param description 商品描述
 @param completeBlock 支付结果回调
 */
-(void)payWithChannel:(PayChannel)payChannel
            andAmount:(long)amount
           andPayType:(PayType)payType
             andPayId:(NSString*)pid
       andDescription:(NSString*)description
        andController:(UIViewController*)controller
        CompleteBlock:(Even_PayComplation)completeBlock;


@end
