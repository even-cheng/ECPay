//
//  Even_NumberKeyboard.h
//  jishijian
//
//  Created by Even on 2017/7/19.
//  Copyright © 2017年 JiShiJian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Even_NumberKeyboardDelegate <NSObject>
@optional
- (void)editChanage:(BOOL)isSure;
@end


@interface Even_NumberKeyboard : UIView
@property (nonatomic, weak) id<Even_NumberKeyboardDelegate> delegate;

@property (nonatomic, weak) UIButton *deleteButton;
@property (nonatomic, weak) UIButton *confirmButton;

@property (nonatomic, weak) UIButton *zeroButton;
@property (nonatomic, weak) UIButton *oneButton;
@property (nonatomic, weak) UIButton *twoButton;
@property (nonatomic, weak) UIButton *threeButton;
@property (nonatomic, weak) UIButton *fourButton;
@property (nonatomic, weak) UIButton *fiveButton;
@property (nonatomic, weak) UIButton *sixButton;
@property (nonatomic, weak) UIButton *sevenButton;
@property (nonatomic, weak) UIButton *eightButton;
@property (nonatomic, weak) UIButton *nineButton;

- (instancetype)initWithTextField:(UITextField *)textField;

@end
