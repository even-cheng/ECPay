//
//  Even_PayError.m
//  IntegratePayProject
//
//  Created by Even on 2017/5/27.
//  Copyright © 2017年 Cube. All rights reserved.
//

#import "Even_PayError.h"

@interface Even_PayError ()

@property (nonatomic) NSMutableDictionary* errorDic;

@end

@implementation Even_PayError

- (instancetype)init{
    self = [super init];
    if (self) {
        //初始化异常信息
        //注册异常信息(配置文件)
        _errorDic = [[NSMutableDictionary alloc] init];
        [_errorDic setValue:@"取消支付" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)Even_PayErrorCancelled]];
        [_errorDic setValue:@"没有这个支付渠道" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)Even_PayErrorInvalidChannel]];
        [_errorDic setValue:@"ViewController不能为空" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)Even_PayErrorViewControllerIsNil]];
        [_errorDic setValue:@"链接异常" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)Even_PayErrorConnectionError]];
        [_errorDic setValue:@"未知异常" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)Even_PayErrorUnknownError]];
        [_errorDic setValue:@"请求超时" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)Even_PayErrorRequestTimeOut]];
        //新增异常
        [_errorDic setValue:@"请安装微信客户端后重试" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)Even_PayErrorWxNoInstalled]];
        [_errorDic setValue:@"调起支付控件失败" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)Even_PayErrorActivation]];
        [_errorDic setValue:@"验证支付凭证失败" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)Even_PayErrorInvalidCredential]];
        [_errorDic setValue:@"服务器身份验证失败" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)Even_PayErrorServerVerifyError]];
        [_errorDic setValue:@"订单缺失" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)Even_PayErrorNullOrder]];
        
        [_errorDic setValue:@"余额不足" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)Even_PayErrorDidNotHaveEnoughMoney]];
        
        [_errorDic setValue:@"密码输入错误" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)Even_PayErrorSendErrorPwd]];
        [_errorDic setValue:@"订单已支付" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)Even_PayErrorRePay]];
        
        [_errorDic setValue:@"密码输入错误三次,账号被冻结24小时" forKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)Even_PayErrorSendErrorPwdForThreeTimes]];

    }
    return self;
}

-(NSString*)getMsg{
    return [_errorDic objectForKey:[[NSString alloc] initWithFormat:@"%lu",(unsigned long)_errorOption]];
}

@end
