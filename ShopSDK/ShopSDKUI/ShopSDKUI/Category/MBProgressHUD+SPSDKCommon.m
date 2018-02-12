//
//  MBProgressHUD+SPSDKCommon.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/22.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "MBProgressHUD+SPSDKCommon.h"

@implementation MBProgressHUD (SPSDKCommon)

+ (void)showTitle:(NSString *)title
{
    if ([NSString isNullOrEmpty:title])
    {
        return;
    }
    [MBProgressHUD showTitle:title detailTitle:nil];
}

+ (void)showTitle:(NSString *)title detailTitle:(NSString *)detailTitle
{
    UIView *view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationZoom;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.9];
    hud.label.text = title;
    hud.label.textColor = [UIColor whiteColor];
    hud.label.font = [UIFont boldSystemFontOfSize:16];
    hud.detailsLabel.text = detailTitle;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    hud.userInteractionEnabled = NO;
    [hud hideAnimated:YES afterDelay:1.5f];
}

@end
