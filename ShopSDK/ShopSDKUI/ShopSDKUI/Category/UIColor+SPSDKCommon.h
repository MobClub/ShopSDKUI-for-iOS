//
//  UIColor+SPSDKCommon.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/4.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SPSDKCommon)

+ (UIColor *)colorForHex:(NSInteger)rgbHex;

+ (UIColor *)colorForHex:(NSInteger)rgbHex alpha:(CGFloat)alpha;

/**
 获取颜色

 @param string 颜色字符串
 @return 颜色
 */
+ (instancetype)colorForString:(NSString *)string;

@end
