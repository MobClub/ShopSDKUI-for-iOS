//
//  SPSDKSelectCouponRootViewController.h
//  ShopSDKUI
//
//  Created by youzu on 2018/1/23.
//  Copyright © 2018年 Mob. All rights reserved.
//

#import "SPSDKBaseViewController.h"

@interface SPSDKSelectCouponRootViewController : SPSDKBaseViewController

@property (nonatomic, strong) NSArray <SPSDKTradingCommodity *> *commodityList;
@property (nonatomic, strong) SPSDKCoupon *coupon;
@property (nonatomic, copy) void (^selectCouponHandler) (SPSDKCoupon *model);

@end
