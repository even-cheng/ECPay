//
//  WalletPayPasswordView.m
//  jishijian
//
//  Created by Even on 2017/6/19.
//  Copyright © 2017年 JiShiJian. All rights reserved.
//

#import "WalletPayPasswordView.h"
#import "CoverView.h"
#import "HDDrawTextField.h"
#import "NSString+Hash.h"
#import "SettingPayPasswordViewController.h"

@interface WalletPayPasswordView ()<HDDrawTextFieldDelegate>

@property (strong,nonatomic) CoverView* coverView;
@property (strong,nonatomic) UIView* payPasswordView;
@property (strong, nonatomic) HDDrawTextField *drawTextField;
@property (nonatomic, copy) GetPayPwdBlock getPayPwdBlock;

@end

@implementation WalletPayPasswordView

+(instancetype)sharedPayPasswordView;{

    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[WalletPayPasswordView alloc]init];
    });
    
    return instance;
}
-(void)removeWalletView;{

    [self.coverView removeCover];
}

-(void)showPasswordViewAndPayPwdBlock:(GetPayPwdBlock)getPayPwdBlock;{

    _getPayPwdBlock = getPayPwdBlock;

    //判断是否设置过支付密码
    if(设置密码){
        
        WEAKSELF
        [self.coverView coverWithView:self.payPasswordView andCloseBlock:^{
            
            if (weakSelf.drawTextField.superview) {
                [weakSelf.drawTextField removeFromSuperview];
                weakSelf.drawTextField = nil;
            }
            
            if (weakSelf.payPasswordView.superview) {
                [weakSelf.payPasswordView removeFromSuperview];
                weakSelf.payPasswordView = nil;
            }
        }];
        
    } else {
        
        [MBProgressHUD showMessage:@"请先设置支付密码"];
        SettingPayPasswordViewController *setPwVC = [[SettingPayPasswordViewController  alloc]init];
        BaseNavigationController * vc = kBaseNavigationController;

        if (!vc) {
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            RESideMenu* menu = (RESideMenu*)appDelegate.window.rootViewController;
            vc = (BaseNavigationController*)menu.contentViewController;
        }
        
        [vc pushViewController:setPwVC animated:YES];
    }
}


//确认支付
- (void)confirmScanf{
    
    //支付
    [self payFee];
}


//执行小费支付
- (void)payFee {
    
    NSString *pass = [self.drawTextField.text md5String];
    //支付
    if (self.getPayPwdBlock) {
        self.getPayPwdBlock(pass);
    }
}

- (void)dismissPayPasswordView {
    
    if (self.coverView.superview) {
        [self.coverView removeCover];
    }
}

#pragma mark - HDDrawTextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.drawTextField) {
        [UIView animateWithDuration:0.35 animations:^{
            self.payPasswordView.transform = CGAffineTransformMakeTranslation(0, -216);
        }];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.drawTextField) {
        [UIView animateWithDuration:0.35 animations:^{
            self.payPasswordView.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}


- (void)forgetPwdAction:(UIButton *)sender {
    
    [self dismissPayPasswordView];
    [XNotificationCenter postNotificationName:@"pushToForgetPwdVC" object:nil];
}

- (void)cancelAction:(UIButton *)sender {
    
    [self dismissPayPasswordView];
}

#pragma mark- 懒加载
- (UIView *)payPasswordView{
    
    if (!_payPasswordView) {
        
        _payPasswordView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, 210)];
        _payPasswordView.backgroundColor = [UIColor whiteColor];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setImage:[UIImage imageNamed:@"btn_delete_gray"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [_payPasswordView addSubview:cancelButton];
        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_payPasswordView).with.offset(15);
            make.top.equalTo(_payPasswordView).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"请输入支付密码";
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = TEXTCOLOR_Dark;
        [_payPasswordView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(cancelButton);
            make.centerX.equalTo(_payPasswordView);
            make.top.equalTo(cancelButton);
            make.left.equalTo(cancelButton.mas_right).with.offset(10);
        }];
        
        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = LINECOLOR;
        [_payPasswordView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(_payPasswordView);
            make.top.equalTo(titleLabel.mas_bottom).with.offset(15);
            make.height.mas_equalTo(1);
        }];
        
        [_payPasswordView addSubview:self.drawTextField];
        [self.drawTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(_payPasswordView);
            make.left.equalTo(_payPasswordView).with.offset(15);
            make.top.equalTo(lineView.mas_bottom).with.offset(20);
            make.height.mas_equalTo((SCREEN_WIDTH - 30) / 6);
        }];
        
        UIButton *forgerPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [forgerPwdButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [forgerPwdButton setTitleColor:FONTCOLOR forState:UIControlStateNormal];
        forgerPwdButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [forgerPwdButton addTarget:self action:@selector(forgetPwdAction:) forControlEvents:UIControlEventTouchUpInside];
        [_payPasswordView addSubview:forgerPwdButton];
        [forgerPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(_payPasswordView).with.offset(-15);
            make.top.equalTo(_drawTextField.mas_bottom).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(70, 30));
        }];
        
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.text = @"支付安全保障中";
        tipLabel.font = [UIFont systemFontOfSize:15];
        tipLabel.textColor = TEXTCOLOR_Dark;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [_payPasswordView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.equalTo(_payPasswordView);
            make.bottom.equalTo(_payPasswordView.mas_bottom).with.offset(-15);
            make.left.equalTo(_payPasswordView).with.offset(10);
            make.height.mas_equalTo(30);
        }];
        
    }
    
    return _payPasswordView;
}

- (HDDrawTextField *)drawTextField {
    
    if (!_drawTextField) {
        
        _drawTextField = [[HDDrawTextField alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, (SCREEN_WIDTH - 30) / 6)];
        _drawTextField.hDTextFieldDelegte = self;
        
        WEAKSELF;
        [_drawTextField addHDDrawTextFieldTextBlock:^(NSString *text) {
            
            if (text.length == 6) {
                
                [weakSelf confirmScanf];
            }
        }];
        
    }
    
    return _drawTextField;
}

-(CoverView *)coverView{

    if (!_coverView) {
        _coverView = [[CoverView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    
    return _coverView;
}

@end
