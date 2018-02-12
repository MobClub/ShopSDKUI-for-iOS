//
//  SPSDKProfileViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/12.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKProfileViewController.h"
#import "SPSDKProfileCell.h"
#import "SPSDKProfileHeaderView.h"
#import "SPSDKOrderRootViewController.h"
#import "SPSDKCouponRootViewController.h"
#import "SPSDKRefundViewController.h"
#import <MOBFoundation/MOBFoundation.h>
#import "SPSDKLoginManager.h"
#import <UMSSDK/UMSSDK.h>
#import "SPSDKAboutUsViewController.h"

static NSString *const SPSDKProfileCellId = @"SPSDKProfileCell";

@interface SPSDKProfileViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet SPSDKTableView *tableView;
@property (nonatomic, strong) SPSDKProfileHeaderView *headerView;

@end

@implementation SPSDKProfileViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([UMSSDK currentUser])
    {
        [ShopSDK getOrdersStatisticInfo:^(NSArray<SPSDKStatisticInfo *> *statisticInfoList, NSError *error) {
            if (!error)
            {
                self.headerView.countList = statisticInfoList;
            }
            else
            {
                [MBProgressHUD showTitle:error.message];
            }
        }];
    }
    
    [self setUser];
}

- (void)setUser
{
    if ([UMSSDK currentUser])
    {
        self.headerView.name = [UMSSDK currentUser].nickname;
        [self.headerView.iconImageV sd_setImageWithURL:[NSURL URLWithString:[UMSSDK currentUser].avatar] placeholderImage:[UIImage imageNamed:@"default_image"]];
    }
    else
    {
        self.headerView.name = @"点击头像登录";
        self.headerView.iconImageV.image = [UIImage imageNamed:@"default_image"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
 
    self.navigationItem.titleView = [UIView new];
    
//    [self createNavigatioItem:SPSDKNavItemTypeImage name:@"sz" isLeft:NO];
    
    self.headerView = [SPSDKProfileHeaderView loadInstanceFromNib];
    self.headerView.autoresizingMask = UIViewAutoresizingNone;
    self.tableView.tableHeaderView = self.headerView;
    __weak typeof(self) weakSelf = self;
    self.headerView.actionHandler = ^(NSInteger index) {

        if (![UMSSDK currentUser])
        {
            [weakSelf login];
            return;
        }
        
        if (index == 3)
        {
            SPSDKRefundViewController *refundVC = [[SPSDKRefundViewController alloc] initWithKeyword:nil hasSearch:YES];
            [weakSelf.navigationController pushViewController:refundVC animated:YES];
        }
        else
        {
            SPSDKOrderRootViewController *myOrderVC = [[SPSDKOrderRootViewController alloc] init];
            if (index != 4)
            {
                myOrderVC.selectIndex = (int)index + 1;
            }
            [weakSelf.navigationController pushViewController:myOrderVC animated:YES];
        }
     };
    
    self.headerView.tapHandler = ^{
        
        if (![UMSSDK currentUser])
        {
            [weakSelf login];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定退出登录吗?"
                                                                message:nil
                                                               delegate:weakSelf
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    };
}

- (void)login
{
    __weak typeof(self) weakSelf = self;
    [[SPSDKLoginManager sharedInstance] loginAtViewController:self handler:^(NSError *error) {
        weakSelf.headerView.name = [UMSSDK currentUser].nickname;
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [UMSSDK logoutWithResult:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!error)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:SPSDKLogoutNotif object:nil];
                [MobSDK clearUser];
                [self setUser];
            }
        }];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKProfileCellId];
    if (!cell)
    {
        cell = [SPSDKProfileCell loadInstanceFromNib];
    }
    cell.line.hidden = indexPath.row == 2;
    cell.detailLabel.hidden = YES;

    if (indexPath.row == 0)
    {
        cell.titleLabel.text = @"优惠券";
        cell.iconImageV.image = [UIImage imageNamed:@"yhq"];
    }
    else if (indexPath.row == 1)
    {
        cell.titleLabel.text = @"客服&帮助";
        cell.iconImageV.image = [UIImage imageNamed:@"kfbz"];
    }
    else
    {
        cell.titleLabel.text = @"关于我们";
        cell.iconImageV.image = [UIImage imageNamed:@"about"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0)
    {
        self.headerView.bgTopConstraint.constant = offsetY;
        [self.headerView layoutIfNeeded];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        if (![UMSSDK currentUser])
        {
            [self login];
            return;
        }
        
        SPSDKCouponRootViewController *couponVC = [[SPSDKCouponRootViewController alloc] init];
        [self.navigationController pushViewController:couponVC animated:YES];
    }
    else if (indexPath.row == 1)
    {
        [MBProgressHUD showTitle:@"敬请期待"];
    }
    else
    {
        SPSDKAboutUsViewController *aboutVC =  [[SPSDKAboutUsViewController alloc] init];
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
}

- (void)onRightBtnAction:(UIButton *)sender
{
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
