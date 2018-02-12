//
//  SPSDKChooseView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/11.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKChooseView : UIView

- (instancetype)initWithCountViewHidden:(BOOL)hidden;

- (void)show;

@property (nonatomic, assign) BOOL isBuyNow;

@property (nonatomic, strong) SPSDKProduct *model;

@property (nonatomic, strong) SPSDKTradingCommodity *tradingCommodity;

@property (nonatomic, copy) void (^refreshHandler) (NSError *addError, NSError *deleteError);

@property (nonatomic, copy) void (^sureHandler) (SPSDKCommodity *commodity, NSInteger count);

- (void)hiddenAnimation;

@end
