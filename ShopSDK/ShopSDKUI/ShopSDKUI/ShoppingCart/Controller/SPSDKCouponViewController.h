//
//  SPSDKCouponViewController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/7.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseViewController.h"

typedef NS_ENUM(NSInteger, SPSDKCouponPageType) {
    
    SPSDKCouponPageTypeSelectUse = 0,  // 选择优惠券可用
    SPSDKCouponPageTypePersonal,       // 个人
    SPSDKCouponPageTypeGet,            // 领取
    SPSDKCouponPageTypeSelectUnuse     // 选择优惠券不可用
    
};

@interface SPSDKCouponViewController : SPSDKBaseViewController

@property (nonatomic, assign) SPSDKCouponStatus status;
@property (nonatomic, strong) NSArray <SPSDKTradingCommodity *> *commodityList;
@property (nonatomic, strong) SPSDKCoupon *coupon;
@property (nonatomic, strong) NSArray *couponList;

- (instancetype)initWithType:(SPSDKCouponPageType)type;

@property (nonatomic, copy) void (^selectCouponHandler) (SPSDKCoupon *model);

@end
