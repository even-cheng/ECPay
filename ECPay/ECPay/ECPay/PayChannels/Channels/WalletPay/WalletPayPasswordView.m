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
#import "Even_NumberKeyboard.h"
#import "UIView+Frame.h"

//数字输入栏高度
static CGFloat kKeyboardHei = 358;
#define SCREEN_HEIGHT [[UIScreen mainScreen]bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen]bounds].size.width

@interface WalletPayPasswordView ()<Even_NumberKeyboardDelegate>

@property (strong,nonatomic) CoverView* coverView;
//支付密码输入整体view
@property (strong,nonatomic) UIView* payPasswordView;

//密码显示view
@property (nonatomic, strong) UIView *showPasswordView;
//密码键盘
@property (strong, nonatomic)  UITextField *textField;
@property (nonatomic, strong) Even_NumberKeyboard *passwordKeyboardView;

@property (nonatomic, strong) NSMutableArray *passwordLabelArray;
@property (nonatomic, copy) NSString *passwordString;
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

-(void)showPasswordViewWithFee:(double)fee andPayPwdBlock:(GetPayPwdBlock)getPayPwdBlock;{
    
    _getPayPwdBlock = getPayPwdBlock;
    
    [self beginEditing];
    
    __weak typeof(self) weakSelf = self;
    [self.coverView coverWithView:self.payPasswordView andCloseBlock:^{

        [self endEditing];

        self.textField.text = nil;
        for (int i = 0; i < self.passwordLabelArray.count; i++)
        {
            UILabel* lab = self.passwordLabelArray[i];
            lab.text = nil;
        }

        if (weakSelf.passwordKeyboardView.superview) {
            [weakSelf.passwordKeyboardView removeFromSuperview];
            weakSelf.passwordKeyboardView = nil;
        }

        if (weakSelf.payPasswordView.superview) {
            [weakSelf.payPasswordView removeFromSuperview];
            weakSelf.payPasswordView = nil;
        }
    }];
}


//确认支付
- (void)confirmScanf{
    
    //支付
    [self payFee];
}


//执行支付
- (void)payFee {
    
    NSString *pass = [self.textField.text md5String];
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
        self.payPasswordView.y -= kKeyboardHei;
    }];
}

- (void)endEditing
{
    self.payPasswordView.y = [UIScreen mainScreen].bounds.size.height;
}


- (void)cancelAction:(UIButton *)sender {
    
    [self dismissPayPasswordView];
}

#pragma mark- 懒加载
- (UIView *)payPasswordView{
    
    if (!_payPasswordView) {
        
        _payPasswordView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, kKeyboardHei)];
        _payPasswordView.backgroundColor = [UIColor whiteColor];

        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [_payPasswordView addSubview:cancelButton];
        cancelButton.frame = CGRectMake(15, 15, 20, 20);

        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"请输入支付密码";
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textColor = [UIColor blackColor];
        [_payPasswordView addSubview:titleLabel];
        titleLabel.frame = CGRectMake(50, 15, SCREEN_WIDTH-50, 20);

        UIView *lineView = [[UIView alloc]init];
        lineView.backgroundColor = [UIColor darkGrayColor];
        [_payPasswordView addSubview:lineView];
        lineView.frame = CGRectMake(0, 40, SCREEN_WIDTH, 1);

        [_payPasswordView addSubview:self.showPasswordView];
        self.showPasswordView.frame = CGRectMake(15, 50, SCREEN_WIDTH-30, (SCREEN_WIDTH - 30) / 6);

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

        [_payPasswordView addSubview:self.passwordKeyboardView];
        self.passwordKeyboardView.frame = CGRectMake(0, 120, SCREEN_WIDTH, 243);
//
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

@end
