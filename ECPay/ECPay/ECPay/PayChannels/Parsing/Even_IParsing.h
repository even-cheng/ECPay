//
//  Even_IParsing.h
//  IntegratePayProject
//
//  Created by Even on 2017/5/27.
//  Copyright © 2017年 Cube. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Even_Charge.h"

//策略接口
@protocol Even_IParsing <NSObject>

//解析服务器返回数据(xml解析、json解析等等...)
-(Even_Charge*)parsing:(NSString*)charge;

@end
