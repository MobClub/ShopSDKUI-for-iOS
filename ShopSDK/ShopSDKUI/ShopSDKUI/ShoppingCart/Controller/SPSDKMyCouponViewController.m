//
//  SPSDKMyCouponViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKMyCouponViewController.h"
#import "SPSDKCouponViewController.h"

static CGFloat const SPSDKItemHeight = 37.f;

@interface SPSDKMyCouponViewController ()

@property (nonatomic, strong) NSArray *couponList;
@property (nonatomic, strong) UIButton *getCouponBtn;
@property (nonatomic, assign) NSInteger count;

@end

@implementation SPSDKMyCouponViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.scrollEnable = NO;
    self.titleSizeSelected = 14.f;
    self.titleSizeNormal = 14.f;
    self.progressWidth = 80.f;
    self.progressHeight = 3.f;
    self.progressColor = SPSDKMainColor;
    self.titleColorNormal = [UIColor colorForHex:0x666666];
    self.titleColorSelected = SPSDKMainColor;
    self.menuViewContentMargin = 0;
    self.progressViewBottomSpace = 0;
    self.menuItemWidth = ScreenWidth / 3;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
}

- (void)configureBtn
{
    self.getCouponBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.getCouponBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateNormal];
    [self.getCouponBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateHighlighted];
    self.getCouponBtn.hidden = YES;
    [self.getCouponBtn addTarget:self action:@selector(onCouponAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getCouponBtn];
}

- (void)onCouponAction
{
    SPSDKCouponViewController *couponVC = [[SPSDKCouponViewController alloc] initWithType:SPSDKCouponPageTypeGet];
    [self.navigationController pushViewController:couponVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureBtn];
    
    [ShopSDK getReceivableCouponsWithPageSize:SPSDKPageSize
                                    pageIndex:1
                                       result:^(NSUInteger pageIndex, NSUInteger countNum, NSArray<SPSDKCoupon *> *couponList, NSError *error) {
                                           _count = couponList.count;
                                           if (_count)
                                           {
                                               self.getCouponBtn.hidden = NO;
                                               [self.getCouponBtn setTitle:[NSString stringWithFormat:@"你有可领取的优惠券(%@)", @(countNum)] forState:UIControlStateNormal];
                                               [self forceLayoutSubviews];
                                           }
                                           
                                           if (error)
                                           {
                                               [MBProgressHUD showTitle:error.message];
                                           }
                                       }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    UIView *line = [UIView new];
    line.frame = CGRectMake(0, SPSDKItemHeight - 0.5, ScreenWidth, 0.5);
    line.backgroundColor = SPSDKLineColor;
    [self.view addSubview:line];
    
    self.getCouponBtn.frame = CGRectMake(0, self.view.frame.size.height - 45.f - (SPSDKiPhoneX ? 34.f : 0.f), self.view.frame.size.width, 45.f);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return 3;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0: return @"未使用";
        case 1: return @"已过期";
        case 2: return @"已使用";
    }
    return @"";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    SPSDKCouponViewController *couponVC = [[SPSDKCouponViewController alloc] initWithType:SPSDKCouponPageTypePersonal];
    switch (index)
    {
        case 0:
            {
                couponVC.status = SPSDKCouponStatusUnused;
            }
            break;
        case 1:
        {
            couponVC.status = SPSDKCouponStatusExpired;
        }
            break;
        case 2:
        {
            couponVC.status = SPSDKCouponStatusUsed;
        }
            break;
        default:
            break;
    }
    return  couponVC;
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index
{
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView
{
    return CGRectMake(0, 0, self.view.frame.size.width, SPSDKItemHeight);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView
{
    return CGRectMake(0, SPSDKItemHeight, self.view.frame.size.width, self.view.frame.size.height - SPSDKItemHeight - (_count ? 45.f : 0.f) - (SPSDKiPhoneX ? 34.f : 0.f));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
