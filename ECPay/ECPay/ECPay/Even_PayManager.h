//
//  Even_PayManager.h
//  jishijian
//
//  Created by Even on 2017/6/12.
//  Copyright © 2017年 JiShiJian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pay.h"

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
