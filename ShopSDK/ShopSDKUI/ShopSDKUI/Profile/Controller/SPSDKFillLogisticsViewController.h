//
//  SPSDKFillLogisticsViewController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/17.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseViewController.h"

@interface SPSDKFillLogisticsViewController : SPSDKBaseViewController

- (instancetype)initWithOrderCommodity:(SPSDKTradingCommodity *)orderCommodity isAdd:(BOOL)isAdd;

@property (nonatomic, copy) void (^completHandler) (void);

@end
