//
//  SPSDKOrderRootViewController.m
//  ShopSDKUI
//
//  Created by youzu on 2017/11/24.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKOrderRootViewController.h"
#import "SPSDKMyOrderViewController.h"
#import "SPSDKSearchViewController.h"
#import "SPSDKOrderStateViewController.h"

@interface SPSDKOrderRootViewController ()

@end

@implementation SPSDKOrderRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我的订单";
    
    SPSDKMyOrderViewController *orderVC = [[SPSDKMyOrderViewController alloc] init];
    orderVC.selectIndex = _selectIndex;
    [self addChildViewController:orderVC];
    orderVC.view.frame = self.view.bounds;
    [self.view addSubview:orderVC.view];
    
    [self createNavigatioItem:SPSDKNavItemTypeImage name:@"search" isLeft:NO];
}

- (void)onRightBtnAction:(UIButton *)sender
{
    SPSDKSearchViewController *searchVC = [[SPSDKSearchViewController alloc] initWithSearchType:SPSDKSearchTypeOrder];
    searchVC.searchHandler = ^(NSString *key) {
        SPSDKOrderStateViewController *stateVC = [[SPSDKOrderStateViewController alloc] initWithState:SPSDKOrderStatusAll keyword:key];
        stateVC.isSearch = YES;
        [self.navigationController pushViewController:stateVC animated:NO];
    };
    searchVC.clickTagHandler = ^(NSInteger index, NSString *key) {
        SPSDKOrderStateViewController *stateVC = [[SPSDKOrderStateViewController alloc] initWithState:SPSDKOrderStatusAll keyword:key];
        stateVC.isSearch = YES;
        [self.navigationController pushViewController:stateVC animated:NO];
    };
    SPSDKNavigationController *nav = [[SPSDKNavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:nav animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
