//
//  MBProgressHUD+SPSDKCommon.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/22.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (SPSDKCommon)

/**
 提示信息
 
 @param title 标题
 */
+ (void)showTitle:(NSString *)title;

/**
 提示信息
 
 @param title 标题
 @param detailTitle 子标题
 */
+ (void)showTitle:(NSString *)title detailTitle:(NSString *)detailTitle;

@end
