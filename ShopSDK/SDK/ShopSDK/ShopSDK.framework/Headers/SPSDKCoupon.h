//
//  SPSDKCoupon.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/8/30.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>
#import "SPSDKTypeDefine.h"

/**
 *  优惠券实体
 */
@interface SPSDKCoupon : MOBFDataModel

/**
 *  优惠券唯一标识
 */
@property (nonatomic, readonly) UInt64 couponId;

/**
 *  优惠券金额
 */
@property (nonatomic, readonly) NSUInteger couponMoney;

/**
 *  优惠券类型
 */
@property (nonatomic, readonly) SPSDKCouponType couponType;

/**
 *  优惠券名称
 */
@property (nonatomic, copy, readonly) NSString *couponName;

/**
 *  优惠券描述
 */
@property (nonatomic, copy, readonly) NSString *couponDescribe;

/**
 *  优惠券开始有效时间
 */
@property (nonatomic, readonly) NSUInteger validBeginAt;

/**
 *  优惠券有效时间结束
 */
@property (nonatomic, readonly) NSUInteger validEndAt;

/**
 *  优惠券使用状态
 */
@property (nonatomic, readonly) SPSDKCouponStatus status;

/**
 *  满减金额
 */
@property (nonatomic, readonly) NSUInteger lowerLimit;

/**
 此次订单是否可用
 */
@property (nonatomic, readonly) BOOL available;

/**
 若此次订单不可用,则不可用原因
 */
@property (nonatomic, copy, readonly) NSString *unavailability;

/**
 差额
 */
@property (nonatomic, readonly) NSInteger gap;

/**
 折扣率
 */
@property (nonatomic, readonly) double discountRate;

/**
 优惠券关联标签Id集合
 */
@property (nonatomic, readonly, strong) NSArray *labelIds;

@end
