//
//  WalletPayPasswordView.h
//  jishijian
//
//  Created by Even on 2017/6/19.
//  Copyright © 2017年 JiShiJian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Even_Charge.h"
#import "Even_PayComplation.h"

typedef void(^GetPayPwdBlock)(NSString* pwd,BOOL isSettingFpass);
@interface WalletPayPasswordView : UIView

+(instancetype)sharedPayPasswordView;

-(void)removeWalletView;
-(void)showPasswordViewWithFpassView:(BOOL)needShowFpassView isSettingFpass:(BOOL)isSetting andFee:(double)fee andWalletFee:(double)walletFee AndPayPwdBlock:(GetPayPwdBlock)getPayPwdBlock;

@end
