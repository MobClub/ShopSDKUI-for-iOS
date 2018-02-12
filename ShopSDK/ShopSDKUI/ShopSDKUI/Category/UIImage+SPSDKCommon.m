//
//  UIImage+SPSDKCommon.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/4.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "UIImage+SPSDKCommon.h"

@implementation UIImage (SPSDKCommon)

+ (UIImage *)gradientImageFromSize:(CGSize)size
{
    UIImage *image = [UIImage imageFromGradientColors:@[[UIColor colorForString:@"#DE4A34"], [UIColor colorForString:@"#FB7E41"]]
                                         gradientType:SPSDKGradientTypeLeftToRight
                                                 size:size];
    return image;
}

+ (UIImage *)imageFromGradientColors:(NSArray *)colors
                        gradientType:(SPSDKGradientType)gradientType
                                size:(CGSize)size
{
    NSMutableArray *ar = [NSMutableArray array];
    for(UIColor *c in colors)
    {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start;
    CGPoint end;
    switch (gradientType) {
        case SPSDKGradientTypeTopToBottom:
        {
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        }
        case SPSDKGradientTypeLeftToRight:
        {
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, 0.0);
            break;
        }
        case SPSDKGradientTypeUpLeftToLowRight:
        {
            start = CGPointMake(0.0, 0.0);
            end = CGPointMake(size.width, size.height);
            break;
        }
        case SPSDKGradientTypeUpRightToLowLeft:
        {
            start = CGPointMake(size.width, 0.0);
            end = CGPointMake(0.0, size.height);
            break;
        }
        default:
            break;
    }
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}

@end
