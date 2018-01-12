//
//  WalletPayPasswordView.m
//  jishijian
//
//  Created by Even on 2017/6/19.
//  Copyright © 2017年 JiShiJian. All rights reserved.
//

#import "WalletPayPasswordView.h"
#import "CoverView.h"
#import "NSString+Hash.h"
//#import "SettingPayPasswordViewController.h"
#import "Even_NumberKeyboard.h"
//#import "ResultView.h"

//数字输入栏高度
static CGFloat kKeyboardHei = 500;

@interface WalletPayPasswordView ()<Even_NumberKeyboardDelegate>

@property (strong,nonatomic) CoverView* coverView;
//支付密码输入整体view
@property (strong,nonatomic) UIView* payPasswordView;
//免密提示view
@property (strong,nonatomic) UIView* fpassView;
@property (weak, nonatomic)  UILabel *titleLabel;
@property (weak, nonatomic)  UILabel *feeLabel;
@property (weak, nonatomic)  UILabel *walletFeeLabel;
@property (nonatomic, weak) UIButton *fPassButton;
//密码显示view
@property (nonatomic, strong) UIView *showPasswordView;
//密码键盘
@property (strong, nonatomic)  UITextField *textField;
@property (nonatomic, strong) Even_NumberKeyboard *passwordKeyboardView;

@property (nonatomic, strong) NSMutableArray *passwordLabelArray;
@property (nonatomic, copy) NSString *passwordString;
@property (nonatomic, copy) GetPayPwdBlock getPayPwdBlock;

//@property (strong,nonatomic) ResultView* cardTipView;
@property(assign,nonatomic) double getWalletFee;

//是否需要显示免密支付按钮
@property(assign,nonatomic) BOOL needShowFpassView;

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

-(void)checkWallet{
    
//    WEAKSELF
//    [[JUserService new] loadCurrentUserProfileSuccess:^(JBaseResponsModel *responseModel, BOOL isCache) {
//
//        UserModel* user = (UserModel*)responseModel;
//        weakSelf.getWalletFee = [user.user.wallet floatValue]/100;
//        weakSelf.walletFeeLabel.text = [NSString stringWithFormat:@"钱包余额(%.1f)%@",weakSelf.getWalletFee*10, kMoneyUnit];
//
//    } failure:nil];

}

-(void)removeWalletView;{

    [self.coverView removeCover];
}

-(void)showPasswordViewWithFpassView:(BOOL)needShowFpassView isSettingFpass:(BOOL)isSetting andFee:(double)fee andWalletFee:(double)walletFee AndPayPwdBlock:(GetPayPwdBlock)getPayPwdBlock;{

    _getPayPwdBlock = getPayPwdBlock;

    if (!needShowFpassView) {
        
        [self hiddenFpassView];
        
    } else {
    
        [self checkWallet];
        [self showFpassView];
    }
    
    
//    VisibleByRegisteredUsers* user = [UserViewModel currenUser].visibleByRegisteredUsers;
//    //判断是否设置过支付密码
//    if([user.payPwd integerValue]){
//
//        [self beginEditing];
//
//        WEAKSELF
//        [self.coverView coverWithView:self.payPasswordView andCloseBlock:^{
//
//            [self endEditing];
//
//            self.textField.text = nil;
//            for (int i = 0; i < self.passwordLabelArray.count; i++)
//            {
//                UILabel* lab = self.passwordLabelArray[i];
//                lab.text = nil;
//            }
//
//            if (weakSelf.fpassView.superview) {
//                [weakSelf.fpassView removeFromSuperview];
//                weakSelf.fpassView = nil;
//            }
//
//            if (weakSelf.passwordKeyboardView.superview) {
//                [weakSelf.passwordKeyboardView removeFromSuperview];
//                weakSelf.passwordKeyboardView = nil;
//            }
//
//            if (weakSelf.payPasswordView.superview) {
//                [weakSelf.payPasswordView removeFromSuperview];
//                weakSelf.payPasswordView = nil;
//            }
//        }];
//
//
//        if (isSetting) {
//
//            [self openFpassAction:nil];
//        }
//
//    } else {
//
//        [MBProgressHUD showMessage:@"请先设置支付密码"];
//        SettingPayPasswordViewController *setPwVC = [[SettingPayPasswordViewController  alloc]init];
//        BaseNavigationController * vc = kBaseNavigationController;
//
//        if (!vc) {
//            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//            RESideMenu* menu = (RESideMenu*)appDelegate.window.rootViewController;
//            vc = (BaseNavigationController*)menu.contentViewController;
//        }
//
//        [vc pushViewController:setPwVC animated:YES];
//    }
//
//    self.walletFeeLabel.text = [NSString stringWithFormat:@"钱包余额 ¥%.1f%@",self.getWalletFee*10?:walletFee*10, kMoneyUnit];
//    self.feeLabel.text = [NSString stringWithFormat:@"%.1f",fee*10];
}


-(void)hiddenFpassView{

//    [self.fpassView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(0);
//    }];
//    self.fpassView.hidden = YES;
//    self.needShowFpassView = NO;
//
//    kKeyboardHei = 435;
//
//    if ([self.titleLabel.text isEqualToString: @"请输入密码以验证身份"]) {
//
//        [UIView animateWithDuration:0.25 animations:^{
//
//            self.payPasswordView.y += 65;
//        }];
//    }
}

-(void)showFpassView{
    
    self.needShowFpassView = YES;
    kKeyboardHei = 500;
}

-(void)setNeedShowFpassView:(BOOL)needShowFpassView{
    
    _needShowFpassView = needShowFpassView;
    self.fPassButton.hidden = !needShowFpassView;
}


//确认支付
- (void)confirmScanf{
    
    //支付
    [self payFee];
}


//执行小费支付
- (void)payFee {
    
    NSString *pass = [self.textField.text md5String];
    BOOL isSettingFpass = [self.titleLabel.text isEqualToString:@"请输入密码以验证身份"];
    //支付
    if (self.getPayPwdBlock) {
        self.getPayPwdBlock(pass,isSettingFpass);
    }
}

- (void)dismissPayPasswordView {
    
    if (self.coverView.superview) {
        [self.coverView removeCover];
    }
}

#pragma mark - Even_NumberKeyboardManagerDelegate
- (void)editChanage:(BOOL)isSure {

    if (self.textField.text.length > 6) {
        self.textField.text = [self.textField.text substringToIndex:6];
    }
    NSString* getText = self.textField.text;
    
    for (int i = 0; i < self.passwordLabelArray.count; i++)
    {
        UILabel* lab = self.passwordLabelArray[i];
        if (getText.length > i) {
            
//            lab.text = [getText substringWithRange:NSMakeRange(i, 1)];
            lab.text = @"•";//●
            
        } else {
        
            lab.text = nil;
        }
    }
    
    if (isSure) {
        
        if (self.textField.text.length != 6) {
//            [MBProgressHUD showError:@"密码有误,请重新输入"];
        } else {
        
            [self confirmScanf];
        }
        
        self.textField.text = nil;
        for (int i = 0; i < self.passwordLabelArray.count; i++)
        {
            UILabel* lab = self.passwordLabelArray[i];
            lab.text = nil;
        }
    }
}

- (void)beginEditing
{
    [UIView animateWithDuration:0.35 animations:^{
//        self.payPasswordView.y -= kKeyboardHei-205;
    }];
}

- (void)endEditing
{
//    self.payPasswordView.y = SCREEN_HEIGHT-205;
}


- (void)forgetPwdAction:(UIButton *)sender {
    
    [self dismissPayPasswordView];
//    [XNotificationCenter postNotificationName:@"pushToForgetPwdVC" object:nil];
}

-(void)openFpassAction:(UIButton*)sender{

//    [kWindow addSubview:self.cardTipView];
}

- (void)cancelAction:(UIButton *)sender {
    
    [self dismissPayPasswordView];
}

#pragma mark- 懒加载
- (UIView *)payPasswordView{
    
    if (!_payPasswordView) {
        
//        _payPasswordView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 200, SCREEN_WIDTH, kKeyboardHei)];
//        _payPasswordView.backgroundColor = [UIColor whiteColor];
//
//        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [cancelButton setImage:[UIImage imageNamed:@"btn_delete_gray"] forState:UIControlStateNormal];
//        [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_payPasswordView addSubview:cancelButton];
//        [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.equalTo(_payPasswordView).with.offset(15);
//            make.top.equalTo(_payPasswordView).with.offset(15);
//            make.size.mas_equalTo(CGSizeMake(20, 20));
//        }];
//
//        UILabel *titleLabel = [[UILabel alloc]init];
//        self.titleLabel = titleLabel;
//        titleLabel.text = @"请输入支付密码";
//        titleLabel.font = [UIFont systemFontOfSize:17];
//        titleLabel.textColor = TEXTCOLOR_Dark;
//        [_payPasswordView addSubview:titleLabel];
//        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.centerY.equalTo(cancelButton);
//            make.centerX.equalTo(_payPasswordView);
//            make.top.equalTo(cancelButton);
//            make.left.equalTo(cancelButton.mas_right).with.offset(10);
//        }];
//
//
//        UIView *lineView = [[UIView alloc]init];
//        lineView.backgroundColor = LINECOLOR;
//        [_payPasswordView addSubview:lineView];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.right.equalTo(_payPasswordView);
//            make.top.equalTo(titleLabel.mas_bottom).with.offset(15);
//            make.height.mas_equalTo(1);
//        }];
//
//        [_payPasswordView addSubview:self.fpassView];
//        [self.fpassView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.right.equalTo(_payPasswordView);
//            make.top.equalTo(lineView.mas_bottom);
//            make.height.mas_equalTo(64);
//        }];
//
//        [_payPasswordView addSubview:self.showPasswordView];
//        [self.showPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.centerX.equalTo(_payPasswordView);
//            make.left.equalTo(_payPasswordView).with.offset(15);
//            make.top.equalTo(self.fpassView.mas_bottom).offset(10);
//            make.height.mas_equalTo((SCREEN_WIDTH - 30) / 6);
//        }];
//
//
//        UIButton *forgerPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [forgerPwdButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
//        [forgerPwdButton setTitleColor:FONTCOLOR forState:UIControlStateNormal];
//        forgerPwdButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [forgerPwdButton addTarget:self action:@selector(forgetPwdAction:) forControlEvents:UIControlEventTouchUpInside];
//        [_payPasswordView addSubview:forgerPwdButton];
//        [forgerPwdButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.right.equalTo(_payPasswordView).with.offset(-15);
//            make.top.equalTo(_showPasswordView.mas_bottom).with.offset(5);
//            make.size.mas_equalTo(CGSizeMake(70, 30));
//        }];
//
//        UIButton *fPassButton = [UIButton new];
//        self.fPassButton = fPassButton;
//        fPassButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [fPassButton addTarget:self action:@selector(openFpassAction:) forControlEvents:UIControlEventTouchUpInside];
//        [fPassButton setTitle:@"开启免密支付" forState:UIControlStateNormal];
//        [fPassButton setTitleColor:FONTCOLOR forState:UIControlStateNormal];
//        [_payPasswordView addSubview:fPassButton];
//        [fPassButton mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.equalTo(_payPasswordView).with.offset(15);
//            make.top.equalTo(_showPasswordView.mas_bottom).with.offset(5);
//        }];
//        fPassButton.hidden = !self.needShowFpassView;
//
//        [_payPasswordView addSubview:self.passwordKeyboardView];
//        [self.passwordKeyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.equalTo(forgerPwdButton.mas_bottom).offset(40);
//            make.left.equalTo(_payPasswordView);
//            make.right.equalTo(_payPasswordView);
//            make.height.mas_equalTo(243);
//        }];
//
//        UILabel *tipLabel = [[UILabel alloc]init];
//        tipLabel.text = @"支付安全保障中";
//        tipLabel.font = [UIFont systemFontOfSize:15];
//        tipLabel.textColor = TEXTCOLOR_Dark;
//        tipLabel.textAlignment = NSTextAlignmentCenter;
//        [_payPasswordView addSubview:tipLabel];
//        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.centerX.equalTo(_payPasswordView);
//            make.bottom.equalTo(self.passwordKeyboardView.mas_top);
//            make.left.equalTo(_payPasswordView).with.offset(10);
//            make.height.mas_equalTo(30);
//        }];
        
    }
    
    return _payPasswordView;
}


-(CoverView *)coverView{

    if (!_coverView) {
        _coverView = [[CoverView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    
    return _coverView;
}

-(UIView *)fpassView{

    if (!_fpassView) {
//        _fpassView = [[UIView alloc]init];
//        _fpassView.backgroundColor = [UIColor whiteColor];
//
//        UILabel *feeLabel = [[UILabel alloc]init];
//        self.feeLabel = feeLabel;
//        feeLabel.font = [UIFont systemFontOfSize:30];
//        feeLabel.textColor = TEXTCOLOR_Dark;
//        [_fpassView addSubview:feeLabel];
//        [feeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.top.equalTo(_fpassView).offset(5);
//            make.centerX.equalTo(_fpassView).offset(10);
//        }];
//
//        UILabel *typeLabel = [[UILabel alloc]init];
//        typeLabel.text = @"心意聊";
//        typeLabel.font = [UIFont systemFontOfSize:17];
//        typeLabel.textColor = TEXTCOLOR_Dark;
//        [_fpassView addSubview:typeLabel];
//        [typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.bottom.equalTo(feeLabel).offset(-3);
//            make.trailing.equalTo(feeLabel.mas_leading).offset(-5);
//        }];
//
//
//        UILabel *unitLabel = [[UILabel alloc]init];
//        unitLabel.text = @"极点";
//        unitLabel.font = [UIFont systemFontOfSize:17];
//        unitLabel.textColor = TEXTCOLOR_Dark;
//        [_fpassView addSubview:unitLabel];
//        [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.bottom.equalTo(feeLabel).offset(-3);
//            make.leading.equalTo(feeLabel.mas_trailing).offset(5);
//        }];
//
//        UILabel *walletFeeLabel = [[UILabel alloc]init];
//        self.walletFeeLabel = walletFeeLabel;
//        walletFeeLabel.font = [UIFont systemFontOfSize:15];
//        walletFeeLabel.textColor = TEXTCOLOR_Gray;
//        [_fpassView addSubview:walletFeeLabel];
//        [walletFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.centerX.equalTo(_fpassView);
//            make.bottom.equalTo(_fpassView);
//        }];
//
//        UIImageView* logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_payKeyboard_jishijian"]];
//        [_fpassView addSubview:logoView];
//        [logoView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.centerY.equalTo(walletFeeLabel);
//            make.trailing.equalTo(walletFeeLabel.mas_leading);
//            make.size.mas_equalTo(CGSizeMake(15, 15));
//        }];

    }
    
    return _fpassView;
}

-(UIView *)showPasswordView{

    if (!_showPasswordView) {
        _showPasswordView = [[UIView alloc]init];
        _showPasswordView.backgroundColor = [UIColor whiteColor];
        
        CGFloat margin = 15;
        CGFloat wid = ([UIScreen mainScreen].bounds.size.width - margin*2)/6;
        for (int i = 0; i < 6; i++)
        {
            UILabel* passwordLabel = [UILabel new];
            passwordLabel.tag = i;
            passwordLabel.frame = CGRectMake(wid*i, 0, wid, wid);
            passwordLabel.textAlignment = NSTextAlignmentCenter;
            passwordLabel.font = [UIFont systemFontOfSize:50];
            passwordLabel.layer.borderWidth = 0.5;
            passwordLabel.layer.borderColor = [UIColor grayColor].CGColor;
            [_showPasswordView addSubview:passwordLabel];
            [self.passwordLabelArray addObject:passwordLabel];
        }
    }
    
    return _showPasswordView;
}


-(Even_NumberKeyboard *)passwordKeyboardView{

    if (!_passwordKeyboardView) {
        
        self.textField = [UITextField new];
        _passwordKeyboardView = [[Even_NumberKeyboard alloc]initWithTextField:self.textField];
        _passwordKeyboardView.delegate = self;
        self.textField.inputView = _passwordKeyboardView;
    }
    
    return _passwordKeyboardView;
}



-(NSMutableArray *)passwordLabelArray{

    if (!_passwordLabelArray) {
        _passwordLabelArray = [NSMutableArray array];
    }
    
    return _passwordLabelArray;
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
//                [weakSelf.coverView removeCover];
//                return;
//            }
//
//            self.titleLabel.text = @"请输入密码以验证身份";
//            [self hiddenFpassView];
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
