//
//  Even_PayError.h
//  IntegratePayProject
//
//  Created by Even on 2017/5/27.
//  Copyright © 2017年 Cube. All rights reserved.
//

#import <Foundation/Foundation.h>

//错误类型
typedef NS_ENUM(NSUInteger,Even_PayErrorOption){
    //支付服务器验证错误
    Even_PayErrorInvalidChannel,
    //取消支付
    Even_PayErrorCancelled,
    //Controller不能为空
    Even_PayErrorViewControllerIsNil,
    //网络连接异常
    Even_PayErrorConnectionError,
    //请求超时
    Even_PayErrorRequestTimeOut,
    //没有安装微信APP
    Even_PayErrorWxNoInstalled,
    //调起支付失败
    Even_PayErrorActivation,
    //验证支付凭证失败
    Even_PayErrorInvalidCredential,
    //订单缺失
    Even_PayErrorNullOrder,
    //服务器身份验证失败--token缺失 code--500
    Even_PayErrorServerVerifyError,
    //未知异常
    Even_PayErrorUnknownError,
    //钱包余额不足
    Even_PayErrorDidNotHaveEnoughMoney,
    //支付密码错误
    Even_PayErrorSendErrorPwd,
    //重复支付
    Even_PayErrorRePay,
    //支付密码连续错误三次,账号锁定
    Even_PayErrorSendErrorPwdForThreeTimes
};

//异常类
@interface Even_PayError : NSObject

@property (nonatomic,assign) Even_PayErrorOption errorOption;

//异常信息
-(NSString*)getMsg;

@end
