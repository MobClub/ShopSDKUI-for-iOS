//
//  UIButton+SPSDKCommon.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/21.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "UIButton+SPSDKCommon.h"
#import <objc/runtime.h>

@implementation UIButton (SPSDKCommon)

- (void)setEnlargeRadius:(CGFloat)enlargeRadius
{
    objc_setAssociatedObject(self, @selector(enlargeRadius), @(enlargeRadius), OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat)enlargeRadius
{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (CGRect)enlargedRect
{
    if (self.enlargeRadius)
    {
        return CGRectMake(self.bounds.origin.x - self.enlargeRadius,
                          self.bounds.origin.y - self.enlargeRadius,
                          self.bounds.size.width + self.enlargeRadius * 2,
                          self.bounds.size.height + self.enlargeRadius * 2);
    }
    else
    {
        return self.bounds;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super pointInside:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? YES : NO;
}

@end
