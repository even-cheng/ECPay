//
//  ViewController.m
//  ECPay
//
//  Created by Even on 2018/1/8.
//  Copyright © 2018年 Even-Cheng. All rights reserved.
//

#import "ViewController.h"
#import "Pay.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[Even_PayManager sharePayManager] payWithChannel:PayChannel_walletPay andAmount:100 andPayType:PayType_Wallet_In andPayId:@"12445" andDescription:@"测试支付" andController:self CompleteBlock:^(NSString *result, Even_PayError *error) {
        
        NSLog(@"%@",result);
    
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
