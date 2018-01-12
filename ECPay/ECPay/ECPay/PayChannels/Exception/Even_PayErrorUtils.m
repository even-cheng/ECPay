//
//  Even_PayErrorUtils.m
//  IntegratePayProject
//
//  Created by Even on 2017/5/27.
//  Copyright © 2017年 Cube. All rights reserved.
//

#import "Even_PayErrorUtils.h"

@implementation Even_PayErrorUtils

+(Even_PayError*)create:(Even_PayErrorOption)code{
    Even_PayError* error = [[Even_PayError alloc] init];
    error.errorOption = code;
    return error;
}

//验证支付对象
+(BOOL)invalidCharge:(Even_Charge*)charge withComplation:(Even_PayComplation)complation{
    
    if ([charge.failCode isEqualToString:@"1"]) {
        complation(nil,[Even_PayErrorUtils create:Even_PayErrorInvalidCredential]);
        return NO;
    }else if([charge.failCode isEqualToString:@"2"]) {
        complation(nil,[Even_PayErrorUtils create:Even_PayErrorInvalidCredential]);
        return NO;
    }else if([charge.failCode isEqualToString:@"11"]) {
        complation(nil,[Even_PayErrorUtils create:Even_PayErrorInvalidCredential]);
        return NO;
    }
    if (charge.credential == nil) {
        complation(@"验证失败",[Even_PayErrorUtils create:Even_PayErrorInvalidCredential]);
        return NO;
    }
    return YES;
}

@end
