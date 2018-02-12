//
//  AppDelegate.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/1.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "AppDelegate.h"
#import "SPSDKTabBarViewController.h"
#import <MOBDebug/MOBLocalServer.h>
#import "IQKeyboardManager.h"
#import <MOBFoundation/MOBFoundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [MOBLocalServer startupWithHost:@"192.168.1.123"];

//    [MobSDK setUserWithUid:@"lfy"
//                  nickName:@"laofoye"
//                    avatar:@"http://img3.imgtn.bdimg.com/it/u=634098145,264198475&fm=214&gp=0.jpg"
//                  userData:nil];
    
//    [MobSDK clearUser];
//    [MobSDK setUserWithUid:@"lfylfy"
//                  nickName:@"laofoye"
//                    avatar:@"http://img3.imgtn.bdimg.com/it/u=634098145,264198475&fm=214&gp=0.jpg"
//                  userData:nil];
    
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat)]
                             onImport:^(SSDKPlatformType platformType) {
                                 
                                 switch (platformType)
                                 {
                                     case SSDKPlatformTypeWechat:
                                         [ShareSDKConnector connectWeChat:[WXApi class]];
                                         break;
                                     default:
                                         break;
                                 }
                                 
    }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                          
                          switch (platformType)
                          {
                              case SSDKPlatformTypeWechat:
                                  [appInfo SSDKSetupWeChatByAppId:@"wxc551587ec5a55ceb"
                                                        appSecret:@"8bd6431d33b3125634330c3ea79e9aa5"];
                                  break;
                              default:
                                  break;
                          }
                          
                      }];
    
    [self addMainWindow];
    
    [IQKeyboardManager sharedManager].toolbarTintColor = SPSDKMainColor;
    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = NO;

    return YES;
}

- (void)addMainWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[SPSDKTabBarViewController alloc]init];
    [self.window makeKeyAndVisible];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
