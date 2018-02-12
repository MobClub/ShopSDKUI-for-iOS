//
//  UINavigationItem+SPSDKCommon.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/27.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "UINavigationItem+SPSDKCommon.h"

@implementation UINavigationItem (SPSDKCommon)

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = 0;
        
        if (leftBarButtonItem)
        {
            [self setLeftBarButtonItems:@[negativeSeperator, leftBarButtonItem]];
        }
        else
        {
            [self setLeftBarButtonItems:@[negativeSeperator]];
        }
    }
    else
    {
        [self setLeftBarButtonItem:leftBarButtonItem animated:NO];
    }
}

- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = 0;
        
        if (rightBarButtonItem)
        {
            [self setRightBarButtonItems:@[negativeSeperator, rightBarButtonItem]];
        }
        else
        {
            [self setRightBarButtonItems:@[negativeSeperator]];
        }
    }
    else
    {
        [self setRightBarButtonItem:rightBarButtonItem animated:NO];
    }
}

@end
