//
//  SPSDKCouponRootViewController.m
//  ShopSDKUI
//
//  Created by youzu on 2017/11/24.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKCouponRootViewController.h"
#import "SPSDKMyCouponViewController.h"

@interface SPSDKCouponRootViewController ()

@end

@implementation SPSDKCouponRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的优惠券";
    
    SPSDKMyCouponViewController *couponVC = [[SPSDKMyCouponViewController alloc] init];
    [self addChildViewController:couponVC];
    couponVC.view.frame = self.view.bounds;
    [self.view addSubview:couponVC.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
