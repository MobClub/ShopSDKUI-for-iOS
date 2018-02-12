//
//  SPSDKStarView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/12.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPSDKStarView;

@protocol SPSDKStarViewDelegate <NSObject>

@optional
- (void)starView:(SPSDKStarView *)starView scorePercent:(CGFloat)scorePercent;

@end

@interface SPSDKStarView : UIView

/**
 间距
 */
@property (nonatomic, assign) IBInspectable CGFloat padding;

/**
 得分值，范围为0--1，默认为1
 */
@property (nonatomic, assign) IBInspectable CGFloat scorePercent;

/**
 是否允许点击
 */
@property (nonatomic, assign) IBInspectable BOOL allowTap;

/**
 评分时是否允许不是整星，默认为NO
 */
@property (nonatomic, assign) IBInspectable BOOL allowInteger;

@property (nonatomic, weak) id<SPSDKStarViewDelegate>delegate;

@end
