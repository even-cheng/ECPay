//
//  HttpUtils.m
//  IntegratePayProject
//
//  Created by Even on 2017/5/18.
//  Copyright © 2017年 Tz. All rights reserved.
//

#import "HttpUtils.h"
#import "Even_Channel.h"

@implementation HttpUtils

+(void)postWithParams:(NSDictionary*)params callback:(Callback)callback{
    
    //请求地址
    NSString* baseStr = @"";
    
 
    //第一步：创建URL地址
    NSURL* url = [[NSURL alloc] initWithString:baseStr];
    
    //第二步：创建请求
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    
    //第三步：设置（绑定）请求参数(AFNetwork内部实现也是这样的)
    request.HTTPMethod = @"POST";
    
    //转成Json传递给我们服务器
    NSData* data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *bodyData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    request.HTTPBody = [NSData dataWithBytes:[bodyData UTF8String] length:strlen([bodyData UTF8String])];
    
    [request setValue:@"1234567890" forHTTPHeaderField:@"X-TIME-APPCODE"];
    [request setValue:[NSObject getObjectForKey:kJtimeToken] forHTTPHeaderField:kJtimeToken];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    //第四步：创建请求回话
    NSURLSession* session = [NSURLSession sharedSession];
    
    //第五步：根据回话创建请求任务
    NSURLSessionDataTask* task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //第七步：处理返回结果
        if (error != nil) {
            
            NSLog(@"请求失败...");
            
        } else {
            NSLog(@"请求成功...");
            //回调
            NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            callback(result);
        }
    }];
    
    //第六步：执行任务
    [task resume];
}

@end
