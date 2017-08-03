//
//  Even_ParsingContext.h
//  IntegratePayProject
//
//  Created by Even on 2017/5/27.
//  Copyright © 2017年 Cube. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Even_IParsing.h"

//持有策略接口引用
@interface Even_ParsingContext : NSObject

-(instancetype)initWithParsing:(id<Even_IParsing>)parsing;
-(Even_Charge*)parsing:(NSString*)charge;

@end
