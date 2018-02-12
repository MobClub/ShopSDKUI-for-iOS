//
//  SPSDKMyOrderViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKMyOrderViewController.h"
#import "SPSDKOrderStateViewController.h"

static CGFloat const SPSDKItemHeight = 37.f;

@interface SPSDKMyOrderViewController ()

@end

@implementation SPSDKMyOrderViewController

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
    self.progressWidth = 60.f;
    self.progressHeight = 3.f;
    self.progressColor = SPSDKMainColor;
    self.titleColorNormal = [UIColor colorForHex:0x666666];
    self.titleColorSelected = SPSDKMainColor;
    self.menuViewContentMargin = 0;
    self.progressViewBottomSpace = 0;
    self.menuItemWidth = ScreenWidth / 5;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.title = @"我的订单";
    
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
    return 5;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0: return @"全部";
        case 1: return @"待付款";
        case 2: return @"待发货";
        case 3: return @"待收货";
        case 4: return @"已完成";
    }
    return @"";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    SPSDKOrderStatus status = SPSDKOrderStatusAll;
    switch (index)
    {
        case 0:
            status = SPSDKOrderStatusAll;
            break;
        case 1:
            status = SPSDKOrderUnpaid;
            break;
        case 2:
            status = SPSDKOrderUnDelivery;
            break;
        case 3:
            status = SPSDKOrderUnReceive;
            break;
        case 4:
            status = SPSDKOrderFinished;
            break;
        default:
            break;
    }
    SPSDKOrderStateViewController *orderStateVC = [[SPSDKOrderStateViewController alloc] initWithState:status keyword:@""];
    return  orderStateVC;
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
    return CGRectMake(0, SPSDKItemHeight, self.view.frame.size.width, self.view.frame.size.height - SPSDKItemHeight);
}

- (void)pageController:(WMPageController *)pageController willEnterViewController:(nonnull __kindof UIViewController *)viewController withInfo:(nonnull NSDictionary *)info
{
    SPSDKOrderStateViewController *orderStateVC = (SPSDKOrderStateViewController *)viewController;
    [orderStateVC beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
