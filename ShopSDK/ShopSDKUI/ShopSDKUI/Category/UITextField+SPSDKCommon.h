//
//  UITextField+SPSDKCommon.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/8.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (SPSDKCommon)

/**
 *  设置placeholder的一些属性
 *
 *  @param textColor 字体颜色
 *  @param font      字体大小
 */
- (void)setPlaceholderTextColor:(UIColor *)textColor font:(UIFont *)font;

@end
