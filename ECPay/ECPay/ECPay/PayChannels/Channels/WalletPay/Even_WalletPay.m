//
//  Even_WalletPay.m
//  jishijian
//
//  Created by Even on 2017/5/31.
//  Copyright © 2017年 JiShiJian. All rights reserved.
//

#import "Even_WalletPay.h"
#import "ResString.h"
#import "Even_PayErrorUtils.h"
#import "WalletPayPasswordView.h"

@interface Even_WalletPay ()

@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, strong) WalletPayPasswordView *payPasswordView;
@property (nonatomic) Even_PayComplation complation;
@property (nonatomic, assign) double walletFee;

@end

@implementation Even_WalletPay

-(instancetype)init{

    if (self = [super init]) {
        
        [self loadWallet];
    }
    
    return self;
}

//业务方法一：需要调用支付接口
-(void)payWithCharge:(Even_Charge*)charge controller:(UIViewController*)controller scheme:(NSString*)scheme withComplation:(Even_PayComplation)complation{
    
    _complation = complation;
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithDictionary:charge.credential];
    
    if ([NSThread currentThread].isMainThread) {
        
        [self payWithParams:params];
        
    } else {
    
        //调用支付
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self payWithParams:params];
        });
    }
}

-(void)loadWallet{

//    WEAKSELF;
//    [[JUserService new] loadCurrentUserProfileSuccess:^(JBaseResponsModel *responseModel, BOOL isCache) {
//        
//        UserModel* user = (UserModel*)responseModel;
//        weakSelf.walletFee = [user.user.wallet longValue]*1.0/100;
//        UserModel* cacheUser = [UserViewModel currenUser];
//        cacheUser.user = user.user;
//        [UserViewModel cacheCurrentUserWithUserModel:cacheUser];
//
//    } failure:nil];

}

-(void)payWithParams:(NSMutableDictionary*)params{

    //当支付心意消息时候需要提示免密支付
//    NSUInteger isFpass = [[UserViewModel currenUser].chat.fpass integerValue];
//    BOOL needShowFpass = ([[params objectForKey:@"type"] integerValue] == 7 || [[params objectForKey:@"type"] integerValue] == 8) && !isFpass;
//    double fee = [[params objectForKey:@"cent"] integerValue]*1.0/100;
//    double walletFee = self.walletFee ?: [[UserViewModel currenUser].user.wallet longValue]*1.0/100;
//
//    //心意聊免密支付通道
//    if (isFpass && ([[params objectForKey:@"type"] integerValue] == 7 || [[params objectForKey:@"type"] integerValue] == 8)) {
//
//        [params setObject:@"" forKey:@"pwd"];
//        [params removeObjectForKey:@"paid"];
//        [HttpUtils postWithParams:params callback:^(NSString *result) {
//
//            NSDictionary* dic = [result mj_JSONObject];
//            Even_PayError* error = [self getErrorWithCode:[[dic objectForKey:@"code"] integerValue]];
//
//            if (self.complation) {
//
//                dispatch_async(dispatch_get_main_queue(), ^{
//
//                    self.complation([dic objectForKey:@"msg"],error);
//                });
//            }
//
//        }];
//
//    } else {
//
//        //收回键盘
//        [kWindow endEditing:YES];
//
//        self.payPasswordView = [WalletPayPasswordView sharedPayPasswordView];
//        BOOL isSettingFpass = [[params objectForKey:@"tag"] isEqualToString:@"开启免密"];
//
//
//        WEAKSELF;
//        [self.payPasswordView showPasswordViewWithFpassView:needShowFpass  isSettingFpass:isSettingFpass andFee:fee andWalletFee:walletFee AndPayPwdBlock:^(NSString *pwd,BOOL isSettingFpass) {
//
//            if (isSettingFpass) {
//
//                self.pwd = pwd;
//                [weakSelf setUpFpass];
//                return ;
//            }
//
//            //进行支付操作
//            [params setObject:pwd forKey:@"pwd"];
//            [params removeObjectForKey:@"paid"];
//
//            if ([NSThread currentThread].isMainThread) {
//                [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
//            } else {
//
//                dispatch_sync(dispatch_get_main_queue(), ^{
//
//                    [MBProgressHUD showHUDAddedTo:kWindow animated:YES];
//                });
//            }
//
//            [HttpUtils postWithParams:params callback:^(NSString *result) {
//
//                if ([NSThread currentThread].isMainThread) {
//                    [MBProgressHUD hideHUDForView:kWindow];
//                } else {
//
//                    dispatch_sync(dispatch_get_main_queue(), ^{
//
//                        [MBProgressHUD hideHUDForView:kWindow];
//                    });
//                }
//                NSDictionary* dic = [result mj_JSONObject];
//                Even_PayError* error = [self getErrorWithCode:[[dic objectForKey:@"code"] integerValue]];
//
//                if (weakSelf.complation) {
//
//                    dispatch_async(dispatch_get_main_queue(), ^{
//
//                        [weakSelf.payPasswordView removeWalletView];
//                        weakSelf.complation([dic objectForKey:@"msg"],error);
//                    });
//                }
//            }];
//
//        }];
//    }
  
}


-(Even_PayError*)getErrorWithCode:(NSInteger)code{

    switch (code) {
        
        case 1: //支付成功
            return nil;
            break;
            
        case 514: //支付密码错误
            return [Even_PayErrorUtils create:Even_PayErrorSendErrorPwd];
            break;
            
        case 510: //钱包余额不足
            return [Even_PayErrorUtils create:Even_PayErrorDidNotHaveEnoughMoney];
            break;
            
        case 515: //支付密码错误超过三次
            return [Even_PayErrorUtils create:Even_PayErrorSendErrorPwdForThreeTimes];
            break;
            
        case 501: //token
            return [Even_PayErrorUtils create:Even_PayErrorServerVerifyError];
            break;

        case 800: //重复支付
            return [Even_PayErrorUtils create:Even_PayErrorRePay];
            break;

        default:
            return [Even_PayErrorUtils create:Even_PayErrorUnknownError];;
            break;
    }
}






#pragma mark- 协议方法,钱包支付不用
//业务方法三：需要处理支付结果回调(钱包支付没有)
- (BOOL)handleOpenURL:(NSURL *)url withComplation:(Even_PayComplation)complation{
    return [self handleOpenURL:url sourceApplication:nil withComplation:complation];
}
//支付回调
//业务方法二：需要处理支付结果回调(钱包支付没有)
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {

    return YES;
}

-(void)setUpFpass{

//    XinyiChatFpassModel* model = [XinyiChatFpassModel new];
//    model.pwd = self.pwd;
//    model.t = @1;
//    [[JUserService new] xinyiChatFpassWithParameterModel:model success:^(JBaseResponsModel *responseModel, BOOL isCache) {
//        
//        [self.payPasswordView removeWalletView];
//        [MBProgressHUD showSuccess:@"免密支付设置成功"];
//        UserModel* user = [UserViewModel currenUser];
//        if (user.chat) {
//            
//            user.chat.fpass = @1;
//        } else {
//        
//            Chat* chat = [Chat new];
//            chat.fpass = @1;
//            user.chat = chat;
//        }
//        [UserViewModel cacheCurrentUserWithUserModel:user];
//        if (self.complation) {
//            self.complation(@"开启免密成功",nil);
//        }
//        
//    } failure:^(JBaseResponsModel *responseModel, NSError *error) {
//        
//        [MBProgressHUD showError:error.localizedDescription];
//    }];
}

//处理支付结果回调(9.0以前)
- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication withComplation:(Even_PayComplation)complation;{

    return  YES;
}


//- (ResultView *)cardTipView {
//    
//    if (!_cardTipView) {
//        
//        WEAKSELF;
//        _cardTipView = [[ResultView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) actionBlock:^(BOOL cancel) {
//            
//            [weakSelf.cardTipView removeFromSuperview];
//            weakSelf.cardTipView = nil;
//
//            if (cancel) {
//                return;
//            }
//            
//            [weakSelf setUpFpass];
//        }];
//        
//        _cardTipView.iconView.image = [UIImage imageNamed:@"bg_mianmiSetting_tip"];
//        _cardTipView.titleLabel.text = @"开启免密支付";
//        _cardTipView.msgLabel.text = @"开启后,发送付费心意聊消息及语音视频通话时不用输入支付密码.";
//        [_cardTipView.sureBtn setTitle:@"知道了" forState:UIControlStateNormal];
//        
//        _cardTipView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
//    }
//    return _cardTipView;
//}


@end
