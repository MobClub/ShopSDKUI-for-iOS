//
//  UIView+Extension.m
//  AppGo
//
//  Created by LeeJay on 16/7/6.
//  Copyright © 2016年 Mob. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect newframe = self.frame;
    newframe.size.width = width;
    self.frame = newframe;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect newframe = self.frame;
    newframe.size.height = height;
    self.frame = newframe;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)top
{
    CGRect newframe = self.frame;
    newframe.origin.y = top;
    self.frame = newframe;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect newframe = self.frame;
    newframe.origin.y = bottom - self.frame.size.height;
    self.frame = newframe;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left
{
    CGRect newframe = self.frame;
    newframe.origin.x = left;
    self.frame = newframe;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGFloat delta = right - (self.frame.origin.x + self.frame.size.width);
    CGRect newframe = self.frame;
    newframe.origin.x += delta;
    self.frame = newframe;
}
- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint newCenter = self.center;
    newCenter.x = centerX;
    self.center = newCenter;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint newCenter = self.center;
    newCenter.y = centerY;
    self.center = newCenter;
}

@end
