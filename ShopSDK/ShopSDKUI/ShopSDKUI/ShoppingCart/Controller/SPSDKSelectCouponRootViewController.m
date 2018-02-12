//
//  SPSDKSelectCouponRootViewController.m
//  ShopSDKUI
//
//  Created by youzu on 2018/1/23.
//  Copyright © 2018年 Mob. All rights reserved.
//

#import "SPSDKSelectCouponRootViewController.h"
#import "SPSDKSelectCouponViewController.h"

@interface SPSDKSelectCouponRootViewController ()

@end

@implementation SPSDKSelectCouponRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"选择优惠券";
    
    SPSDKSelectCouponViewController *couponVC = [[SPSDKSelectCouponViewController alloc] init];
    couponVC.commodityList = _commodityList;
    couponVC.coupon = _coupon;
    couponVC.selectCouponHandler = _selectCouponHandler;
    [self addChildViewController:couponVC];
    couponVC.view.frame = self.view.bounds;
    [self.view addSubview:couponVC.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
