//
//  SPSDKNavigationController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/4.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKNavigationController.h"

@interface SPSDKNavigationController () <UIGestureRecognizerDelegate>

@end

@implementation SPSDKNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _enablePopGesture = YES;
    _isWhite = YES;
    
    self.interactivePopGestureRecognizer.delegate = self;
    
    [self configureNavBarTheme];
}

- (void)configureNavBarTheme
{
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    // 设置导航栏的标题颜色，字体
    NSDictionary *textAttrs = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                NSFontAttributeName : [UIFont fontWithName:@"Helvetica"size:16.0]};
    [self.navigationBar setTitleTextAttributes:textAttrs];
    
    //设置导航栏的背景图片
    [self.navigationBar setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    
    // 去掉导航栏底部阴影
    [self.navigationBar setShadowImage:[[UIImage alloc]init]];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count <= 1)
    {
        return NO;
    }
    return self.enablePopGesture;
}

#pragma mark - override

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count >= 1)
    {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(navGoBack)];
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - action

- (void)navGoBack
{
    [self popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (_isWhite)
    {
        return UIStatusBarStyleLightContent;
    }
    else
    {
        return UIStatusBarStyleDefault;
    }
}

- (void)setIsWhite:(BOOL)isWhite
{
    if (_isWhite != isWhite)
    {
        _isWhite = isWhite;
        
        [self setNeedsStatusBarAppearanceUpdate];
    }
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
