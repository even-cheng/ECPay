//
//  HttpUtils.h
//  IntegratePayProject
//
//  Created by Even on 2017/5/18.
//  Copyright © 2017年 Tz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^Callback) (NSString* result);

@interface HttpUtils : NSObject

//发送POST请求
+(void)postWithParams:(NSDictionary*)params callback:(Callback)callback;

@end
