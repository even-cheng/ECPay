//
//  CoverView.m
//  JTime
//
//  Created by Even on 2017/3/6.
//  Copyright © 2017年 Cube. All rights reserved.
//

#import "CoverView.h"
#import "AppDelegate.h"

#define kWindow [(AppDelegate*)[UIApplication sharedApplication].delegate window]

@interface CoverView ()

@property (nonatomic, weak) UIView *receiveView;
@property (nonatomic, copy) CloseCoverViewBlock closeBlock;
@property (nonatomic, weak) UITapGestureRecognizer *tapCoverViewGest;

@end

@implementation CoverView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
        self.animationAlpha = 0.65;
        UITapGestureRecognizer* tapCoverViewGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeCoverView)];
        [self addGestureRecognizer:tapCoverViewGest];
        self.tapCoverViewGest = tapCoverViewGest;
    }
    
    return self;
}

//禁用手势
-(void)disEnabledTouch;{

    self.tapCoverViewGest.enabled = NO;
}

//关闭筛选
-(void)closeCoverView{
    
    CoverView* cover = self;
    if (cover.closeBlock) {
        
        cover.closeBlock();
    }
    cover.alpha = self.animationAlpha;
    [UIView animateWithDuration:0.35 animations:^{
        
        cover.alpha -= self.animationAlpha;
        
    }  completion:^(BOOL finished) {
        
        [cover removeFromSuperview];
    }];
}

-(void)coverWithView:(UIView*)view andCloseBlock:(CloseCoverViewBlock)block;
{
    self.alpha = 0;
    self.closeBlock = block;
    [kWindow addSubview:self];
    if (view) {
    
        self.receiveView = view;
        [kWindow addSubview:view];
    }
    [UIView animateWithDuration:0.35 animations:^{
        
        self.alpha += self.animationAlpha;
    }];
}

/*
 view : 替换弹框,背景不变
 */
-(void)coverWithOtherView:(UIView*)view;{

    [self.receiveView removeFromSuperview];
    [kWindow addSubview:view];
    self.receiveView = view;
}

-(void)coverWithView:(UIView*)view andPopCoverViewBlock:(PopCoverViewBlock)popCoverViewBlock andCloseBlock:(CloseCoverViewBlock)closeCoverViewBlock;
{
    self.alpha = 0;
    self.closeBlock = closeCoverViewBlock;
    [kWindow addSubview:self];
    [kWindow addSubview:view];
    self.receiveView = view;

    if (popCoverViewBlock) {
        
        popCoverViewBlock();
    }
    
    [UIView animateWithDuration:0.35 animations:^{
        
        self.alpha += self.animationAlpha;
    }];
}

-(void)removeCover;
{
    [self closeCoverView];
}

@end
