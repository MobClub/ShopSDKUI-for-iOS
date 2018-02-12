//
//  UIView+SPSDKNib.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/7.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "UIView+SPSDKNib.h"

@implementation UIView (SPSDKNib)

+ (UINib *)loadNib
{
    return [self loadNibNamed:NSStringFromClass([self class])];
}

+ (UINib *)loadNibNamed:(NSString *)nibName
{
    return [self loadNibNamed:nibName bundle:[NSBundle mainBundle]];
}

+ (UINib *)loadNibNamed:(NSString *)nibName bundle:(NSBundle *)bundle
{
    return [UINib nibWithNibName:nibName bundle:bundle];
}

+ (instancetype)loadInstanceFromNib
{
    return [self loadInstanceFromNibWithName:NSStringFromClass([self class])];
}

+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName
{
    return [self loadInstanceFromNibWithName:nibName owner:nil];
}

+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner
{
    return [self loadInstanceFromNibWithName:nibName owner:owner bundle:[NSBundle mainBundle]];
}

+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle
{
    UIView *result = nil;
    NSArray *elements = [bundle loadNibNamed:nibName owner:owner options:nil];
    for (id object in elements)
    {
        if ([object isKindOfClass:[self class]])
        {
            result = object;
            break;
        }
    }
    return result;
}

@end
