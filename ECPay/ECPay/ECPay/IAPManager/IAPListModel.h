//
//  IAPListModel.h
//  jishijian
//
//  Created by Even on 2017/11/16.
//  Copyright © 2017年 JiShiJian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAPListModel : NSObject

//商品id
@property (nonatomic, copy) NSString *pid;
//商品名称
@property (nonatomic, copy) NSString *name;
//商品价格
@property (copy,nonatomic) NSNumber *price;
//购买数量
@property (copy,nonatomic) NSNumber *number;
//商品备注
@property (copy,nonatomic) NSString* desc;

@end

