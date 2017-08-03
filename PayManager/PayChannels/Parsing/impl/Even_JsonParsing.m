//
//  Even_JsonParsing.m
//  IntegratePayProject
//
//  Created by Even on 2017/5/27.
//  Copyright © 2017年 Cube. All rights reserved.
//

#import "Even_JsonParsing.h"

@implementation Even_JsonParsing

-(Even_Charge*)parsing:(NSString*)charge{
    
    Even_Charge* chargeObj = [[Even_Charge alloc] init];
    NSData* jsonData = [charge dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    NSInteger pay_channel = [[jsonDic objectForKey:@"paid"] integerValue];
    id callBackData = jsonDic[@"data"];
    NSDictionary* data;

    switch (pay_channel) {
            
            //钱包
        case 0:
            
            chargeObj.channel = PAY_WALLETPAY_Key;
            chargeObj.credential = jsonDic;
            break;
            
            //支付宝
        case 1:
            
            chargeObj.channel = PAY_ALIPAY_Key;
            //支付宝必须字段
            chargeObj.signString = callBackData;
            chargeObj.credential = (NSDictionary*)callBackData;

            break;
            
            //微信
        case 2:
            
            chargeObj.channel = PAY_WXPAY_Key;
            chargeObj.credential = (NSDictionary*)callBackData;

            break;
            
            //银联
        case 3:
            
            chargeObj.channel = PAY_UNIONPAY_Key;
            break;
            
        default:
            break;
    }
    
    chargeObj.orderNo = [data objectForKey:@"orderNo"];
    chargeObj.amount = [data objectForKey:@"amount"];
    chargeObj.subject = [data objectForKey:@"subject"];
    chargeObj.body = [data objectForKey:@"body"];
    chargeObj.chargeId = [data objectForKey:@"chargeId"];
    chargeObj.created = [data objectForKey:@"created"];
    chargeObj.clientIP = [data objectForKey:@"clientIP"];
    chargeObj.failCode = [data objectForKey:@"failCode"];
    chargeObj.failMsg = [data objectForKey:@"failMsg"];
    
    return chargeObj;
}

@end
