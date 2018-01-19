//
//  IAPManager.h
//  IAPDemo
//
//  Created by Charles.Yao on 2016/10/31.
//  Copyright © 2016年 com.pico. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <StoreKit/StoreKit.h>


//=====================单例==================
// @interface
#define singleton_interface(className) \
+ (className *)shared;

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (className *)shared \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}

typedef NS_ENUM(NSInteger, IAPFiledCode) {
    /**
     *  苹果返回错误信息
     */
    IAP_FILEDCOED_APPLECODE = 0,
    
    /**
     *  用户禁止应用内付费购买
     */
    IAP_FILEDCOED_NORIGHT = 1,
    
    /**
     *  商品为空
     */
    IAP_FILEDCOED_EMPTYGOODS = 2,
    /**
     *  无法获取产品信息，请重试
     */
    IAP_FILEDCOED_CANNOTGETINFORMATION = 3,
    /**
     *  购买失败，请重试
     */
    IAP_FILEDCOED_BUYFILED = 4,
    /**
     *  用户取消交易
     */
    IAP_FILEDCOED_USERCANCEL = 5
    
};


@protocol IApRequestResultsDelegate <NSObject>

- (void)filedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error; //失败
- (void)IApRequestDone;

@end

@interface IAPManager : NSObject

singleton_interface(IAPManager)

@property (nonatomic, weak)id<IApRequestResultsDelegate>delegate;

/**
 启动工具
 */
- (void)startManager;

/**
 结束工具
 */
- (void)stopManager;

/**
 请求商品列表
 */
- (void)requestProductWithId:(NSString *)productId;


@end
