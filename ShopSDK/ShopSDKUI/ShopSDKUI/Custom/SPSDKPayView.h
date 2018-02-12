//
//  SPSDKPayView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/17.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKPayView : UIView

/**
 支付金额
 */
@property (nonatomic, assign) float price;

/**
 支付的订单模型
 */
@property (nonatomic, strong) SPSDKOrder *order;

/**
 取消支付回调
 */
@property (nonatomic, copy) void (^cancelHandler) (SPSDKOrder *order);

/**
 支付回调
 */
@property (nonatomic, copy) void (^payHandler) (SPSDKOrder *order, SPSDKPayType payType, float price);

/**
 弹出支付视图
 */
- (void)show;

/**
 隐藏视图
 */
- (void)hide;

@end
