//
//  Order.h
//  JTime
//
//  Created by Even on 16/11/23.
//  Copyright © 2016年 Cube. All rights reserved.
//支付宝支付模型

#import <Foundation/Foundation.h>

@interface Order : NSObject

//合作商户ID
@property(nonatomic, copy) NSString * partner;
//支付宝收款账号
@property(nonatomic, copy) NSString * seller;
//订单号
@property(nonatomic, copy) NSString * tradeNO;
//商品名称
@property(nonatomic, copy) NSString * productName;
//商品描述
@property(nonatomic, copy) NSString * productDescription;
//价格
@property(nonatomic, copy) NSString * amount;
//支付宝服务器回传url
@property(nonatomic, copy) NSString * notifyURL;
//mobile.securitypay.pay 服务类型
@property(nonatomic, copy) NSString * service;
//支付类型
@property(nonatomic, copy) NSString* paymentType;

@property(nonatomic, copy) NSString * inputCharset;
//超时时间
@property(nonatomic, copy) NSString * excessTime;

@property(nonatomic, copy) NSString * showUrl;


@property(nonatomic, copy) NSString * rsaDate;//可选
@property(nonatomic, copy) NSString * appID;//可选

@property(nonatomic, readonly) NSMutableDictionary * extraParams;

// 遍历构造器
+ (id)order;


@end
