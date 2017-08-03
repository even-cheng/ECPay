//
//  Even_PayEngine.h
//  IntegratePayProject
//
//  Created by Even on 2017/5/27.
//  Copyright © 2017年 Cube. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Even_PayComplation.h"

@interface Even_PayEngine : NSObject

+(instancetype)sharedEngine;

//唤醒支付
//参数一：服务器返回支付信息,传递给我们框架进行解析处理
-(void)payWithCharge:(NSString*)charge controller:(UIViewController*)controller scheme:(NSString*)scheme withComplation:(Even_PayComplation)complation;

//回调处理（9.0之前）
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication withComplation:(Even_PayComplation)complation;

//回调处理（9.0之后）
- (BOOL)handleOpenURL:(NSURL *)url withComplation:(Even_PayComplation)complation;

@end
