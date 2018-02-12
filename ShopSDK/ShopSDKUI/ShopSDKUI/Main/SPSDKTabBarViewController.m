//
//  SPSDKTabBarViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/1.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKTabBarViewController.h"
#import "SPSDKHomeViewController.h"
#import "SPSDKAllProductViewController.h"
#import "SPSDKShoppingCartViewController.h"
#import "SPSDKProfileViewController.h"
#import "SPSDKNavigationController.h"
#import "SPSDKUIPayConfig.h"
#import "IQKeyboardManager.h"

NSString *const SPSDKUINeedCustomPayNotification = @"SPSDKUINeedCustomPayNotification";
NSString *const SPSDKUICustomPayResultNotification = @"SPSDKUICustomPayResultNotification";


@interface SPSDKTabBarViewController ()

@end

@implementation SPSDKTabBarViewController

- (void)setPayMode:(SPSDKPayMode)mode
{
    [SPSDKUIPayConfig defaultConfig].payMode = mode;
}

- (void)setPayTypes:(NSArray *)types
{
    [SPSDKUIPayConfig defaultConfig].payTypes = types;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [IQKeyboardManager sharedManager].toolbarTintColor = SPSDKMainColor;
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;
    
    [self configureChildViewControllers];
    
    [self configureTabBar];
}

- (void)configureTabBar
{
    self.tabBar.backgroundColor = [UIColor colorForHex:0xf9f9f9 alpha:0.9];
    
    [[UITabBarItem appearanceWhenContainedIn:[SPSDKTabBarViewController class], nil] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:9], NSForegroundColorAttributeName : SPSDKTextColor} forState:UIControlStateNormal];
    
    [[UITabBarItem appearanceWhenContainedIn:[SPSDKTabBarViewController class], nil] setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:9], NSForegroundColorAttributeName : SPSDKMainColor} forState:UIControlStateSelected];
}

- (void)configureChildViewControllers
{
    // 首页
//    [self addHomeController];
    
    // 全部商品
    [self addAllProductController];
    
    // 购物车
    [self addShoppingCartController];
    
    // 我的
    [self addProfileController];
}

#pragma mark - add childVC

- (void)addHomeController
{
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, -2);

    SPSDKHomeViewController *homeVC = [[SPSDKHomeViewController alloc] init];
    
    [self _addChildViewController:homeVC
                            title:@"首页"
                            image:@"tabbar_home_normal"
                    selectedImage:@"tabbar_home_selected"
                      imageInsets:imageInsets
                    titlePosition:titlePosition
               navControllerClass:[SPSDKNavigationController class]];
}

- (void)addAllProductController
{
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, -2);
    
    SPSDKAllProductViewController *allProductVC = [[SPSDKAllProductViewController alloc] init];
    [self _addChildViewController:allProductVC
                            title:@"全部商品"
                            image:@"tabbar_allproduct_normal"
                    selectedImage:@"tabbar_allproduct_selected"
                      imageInsets:imageInsets
                    titlePosition:titlePosition
               navControllerClass:[SPSDKNavigationController class]];
}

- (void)addShoppingCartController
{
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, -2);
    
    SPSDKShoppingCartViewController *shoppingCartVC = [[SPSDKShoppingCartViewController alloc] init];
    [self _addChildViewController:shoppingCartVC
                            title:@"购物车"
                            image:@"tabbar_shopcart_normal"
                    selectedImage:@"tabbar_shopcart_selected"
                      imageInsets:imageInsets
                    titlePosition:titlePosition
               navControllerClass:[SPSDKNavigationController class]];
}

- (void)addProfileController
{
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIOffset titlePosition = UIOffsetMake(0, -2);
    
    SPSDKProfileViewController *profileVC = [[SPSDKProfileViewController alloc] init];
    [self _addChildViewController:profileVC
                            title:@"我的"
                            image:@"tabbar_profile_normal"
                    selectedImage:@"tabbar_profile_selected"
                      imageInsets:imageInsets
                    titlePosition:titlePosition
               navControllerClass:[SPSDKNavigationController class]];
}

#pragma mark - Private

- (void)_addChildViewController:(UIViewController *)childVc
                          title:(NSString *)title
                          image:(NSString *)image
                  selectedImage:(NSString *)selectedImage
                    imageInsets:(UIEdgeInsets)imageInsets
                  titlePosition:(UIOffset)titlePosition
             navControllerClass:(Class)navControllerClass
{
    [self _configureChildViewController:childVc
                                  title:title
                                  image:image
                          selectedImage:selectedImage
                            imageInsets:imageInsets
                          titlePosition:titlePosition];
    
    id nav = nil;
    if (navControllerClass == nil)
    {
        nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    }
    else
    {
        nav = [[navControllerClass alloc] initWithRootViewController:childVc];
    }
    
    [self addChildViewController:nav];
}

- (void)_configureChildViewController:(UIViewController *)childVc
                                title:(NSString *)title
                                image:(NSString *)image
                        selectedImage:(NSString *)selectedImage
                          imageInsets:(UIEdgeInsets)imageInsets
                        titlePosition:(UIOffset)titlePosition
{
    childVc.title = title;
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.imageInsets = imageInsets;
    childVc.tabBarItem.titlePositionAdjustment = titlePosition;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
