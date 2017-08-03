//
//  Even_PayComplation.h
//  IntegratePayProject
//
//  Created by Even on 2017/5/27.
//  Copyright © 2017年 Cube. All rights reserved.
//

#ifndef Even_PayComplation_h
#define Even_PayComplation_h

#import "Even_PayError.h"

//返回支付结果
typedef void (^Even_PayComplation)(NSString* result,Even_PayError* error);

#endif /* Even_PayComplation_h */
