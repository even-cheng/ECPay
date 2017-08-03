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

typedef void(^GetPayPwdBlock)(NSString* pwd);
@interface WalletPayPasswordView : UIView

+(instancetype)sharedPayPasswordView;

-(void)removeWalletView;
-(void)showPasswordViewAndPayPwdBlock:(GetPayPwdBlock)getPayPwdBlock;

@end
