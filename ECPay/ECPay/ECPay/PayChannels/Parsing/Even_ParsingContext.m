//
//  Even_ParsingContext.m
//  IntegratePayProject
//
//  Created by Even on 2017/5/27.
//  Copyright © 2017年 Cube. All rights reserved.
//

#import "Even_ParsingContext.h"
#import "Even_IParsing.h"


@interface Even_ParsingContext ()

@property (nonatomic) id<Even_IParsing> parsing;

@end

@implementation Even_ParsingContext

- (instancetype)initWithParsing:(id<Even_IParsing>)parsing{
    self = [super init];
    if (self) {
        _parsing = parsing;
    }
    return self;
}

-(Even_Charge*)parsing:(NSString*)charge{
    return [_parsing parsing:charge];
}

@end
