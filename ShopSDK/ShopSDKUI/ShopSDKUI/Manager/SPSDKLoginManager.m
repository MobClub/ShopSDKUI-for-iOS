//
//  SPSDKLoginManager.m
//  ShopSDKUI
//
//  Created by youzu on 2017/11/3.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKLoginManager.h"
#import <UMSSDK/UMSSDK.h>
#import <UMSSDKUI/UMSLoginModuleViewController.h>

@implementation SPSDKLoginManager

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)loginAtViewController:(UIViewController *)vc handler:(void (^) (NSError *error))handler
{
    UMSLoginModuleViewController *umsLoginVC = [[UMSLoginModuleViewController alloc] init];
    __weak typeof(UMSLoginModuleViewController) *weakLoginVC = umsLoginVC;
    umsLoginVC.loginVC.loginHandler = ^(NSError *error) {
        
        if (handler)
        {
            handler(error);
        }
        
        if (!error)
        {
            [weakLoginVC close];
            [[NSNotificationCenter defaultCenter] postNotificationName:SPSDKLoginNotif object:nil];
        }
    };
    [vc presentViewController:umsLoginVC animated:YES completion:nil];
}

@end
