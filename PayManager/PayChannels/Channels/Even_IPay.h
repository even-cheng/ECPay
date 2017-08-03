//
//  Even_IPay.h
//  IntegratePayProject
//
//  Created by Even on 2017/5/27.
//  Copyright © 2017年 Cube. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Even_Charge.h"
#import "Even_PayComplation.h"

@protocol Even_IPay <NSObject>

//调用支付接口(唤醒支付)
-(void)payWithCharge:(Even_Charge*)charge controller:(UIViewController*)controller scheme:(NSString*)scheme withComplation:(Even_PayComplation)complation;

//处理支付结果回调(9.0以前)
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication withComplation:(Even_PayComplation)complation;

//处理支付结果回调(9.0以后)
- (BOOL)handleOpenURL:(NSURL *)url withComplation:(Even_PayComplation)complation;
@end
