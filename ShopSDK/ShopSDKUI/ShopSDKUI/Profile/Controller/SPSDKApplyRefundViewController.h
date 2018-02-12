//
//  SPSDKApplyRefundViewController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/20.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseViewController.h"

@interface SPSDKApplyRefundViewController : SPSDKBaseViewController

- (instancetype)initWithOrderCommodity:(SPSDKTradingCommodity *)commodity isModify:(BOOL)isModify;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^refundHandler) (NSIndexPath *indexPath);

@end
