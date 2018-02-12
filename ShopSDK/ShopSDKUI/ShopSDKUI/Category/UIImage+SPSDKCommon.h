//
//  UIImage+SPSDKCommon.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/4.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SPSDKGradientType) {
    SPSDKGradientTypeTopToBottom = 0,  // 从上到下
    SPSDKGradientTypeLeftToRight,      // 从左到右
    SPSDKGradientTypeUpLeftToLowRight, // 左上到右下
    SPSDKGradientTypeUpRightToLowLeft  // 右上到左下
};

@interface UIImage (SPSDKCommon)

+ (UIImage *)gradientImageFromSize:(CGSize)size;

/**
 获取渐变色的图片
 
 @param colors 渐变色数组
 @param gradientType 渐变方向
 @param size 图片大小
 @return 渐变色图片
 */
+ (UIImage *)imageFromGradientColors:(NSArray *)colors
                        gradientType:(SPSDKGradientType)gradientType
                                size:(CGSize)size;

@end
