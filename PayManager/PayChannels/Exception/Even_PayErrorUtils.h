//
//  Even_PayErrorUtils.h
//  IntegratePayProject
//
//  Created by Even on 2017/5/27.
//  Copyright © 2017年 Cube. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Even_PayError.h"
#import "Even_PayComplation.h"
#import "Even_Charge.h"

//异常赋值和创建必需由内部实现，不能客户端创建，因为异常是从框架内步抛出
@interface Even_PayErrorUtils : NSObject

+(Even_PayError*)create:(Even_PayErrorOption)code;

+(BOOL)invalidCharge:(Even_Charge*)charge withComplation:(Even_PayComplation)complation;

@end
