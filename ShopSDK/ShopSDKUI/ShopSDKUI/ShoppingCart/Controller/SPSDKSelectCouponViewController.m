//
//  SPSDKSelectCouponViewController.m
//  ShopSDKUI
//
//  Created by youzu on 2018/1/23.
//  Copyright © 2018年 Mob. All rights reserved.
//

#import "SPSDKSelectCouponViewController.h"
#import "SPSDKCouponViewController.h"
#import "SPSDKCoupon+SPSDKExtension.h"

static CGFloat const SPSDKItemHeight = 37.f;

@interface SPSDKSelectCouponViewController ()

@property (nonatomic, strong) NSMutableArray *useDatas;
@property (nonatomic, strong) NSMutableArray *unuseDatas;

@end

@implementation SPSDKSelectCouponViewController

- (NSMutableArray *)useDatas
{
    if (!_useDatas)
    {
        _useDatas = [NSMutableArray array];
    }
    return _useDatas;
}

- (NSMutableArray *)unuseDatas
{
    if (!_unuseDatas)
    {
        _unuseDatas = [NSMutableArray array];
    }
    return _unuseDatas;
}

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
    self.menuItemWidth = ScreenWidth / 2;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ShopSDK getUsableCouponWithCommodityList:self.commodityList result:^(NSArray<SPSDKCoupon *> *couponList, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        for (SPSDKCoupon *coupon in couponList)
        {
            if (coupon.available)
            {
                [self.useDatas addObject:coupon];
            }
            else
            {
                [self.unuseDatas addObject:coupon];
            }
        }
        
        if (_coupon)
        {
            for (SPSDKCoupon *coupon in self.useDatas)
            {
                if (coupon.couponId == _coupon.couponId)
                {
                    coupon.selected = YES;
                }
            }
        }
        
        [self reloadData];
//
//        _count = couponList.count;
//
//        if (_count)
//        {
//            self.sureBtn.hidden = NO;
//            self.barHeight.constant = 45.f;
//        }
//        else
//        {
//            self.sureBtn.hidden = YES;
//            self.barHeight.constant = 0.f;
//        }
//        [self configureRefreshDataWithCouponList:couponList error:error];
    }];
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    UIView *line = [UIView new];
    line.frame = CGRectMake(0, SPSDKItemHeight - 0.5, ScreenWidth, 0.5);
    line.backgroundColor = SPSDKLineColor;
    [self.view addSubview:line];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return 2;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0: return @"可用的优惠券";
        case 1: return @"不可用的优惠券";
    }
    return @"";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    SPSDKCouponViewController *couponVC;
    switch (index)
    {
        case 0:
        {
            couponVC = [[SPSDKCouponViewController alloc] initWithType:SPSDKCouponPageTypeSelectUse];
            couponVC.selectCouponHandler = _selectCouponHandler;
            couponVC.couponList = self.useDatas;
        }
            break;
        case 1:
        {
            couponVC = [[SPSDKCouponViewController alloc] initWithType:SPSDKCouponPageTypeSelectUnuse];
            couponVC.couponList = self.unuseDatas;
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
    return CGRectMake(0, SPSDKItemHeight, self.view.frame.size.width, self.view.frame.size.height - SPSDKItemHeight  - (SPSDKiPhoneX ? 34.f : 0.f));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
