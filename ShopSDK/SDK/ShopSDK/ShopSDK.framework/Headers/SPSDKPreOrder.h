//
//  SPSDKPreOrder.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/9/5.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>
#import "SPSDKTypeDefine.h"

@class SPSDKShippingAddress;
@class SPSDKCommodity;
@class SPSDKCoupon;

/**
 预订单实体
 */
@interface SPSDKPreOrder : MOBFDataModel

/**
 *  总运费
 */
@property (nonatomic, readonly) NSInteger totalFreight;

/**
 *  商品总金额
 */
@property (nonatomic, readonly) NSUInteger totalMoney;

/**
 *  优惠金额
 */
@property (nonatomic, readonly) NSUInteger totalCoupon;

/**
 *  商品需要支付金额
 */
@property (nonatomic, readonly) NSUInteger paidMoney;

/**
 *  订单商品列表
 */
@property (nonatomic, strong, readonly) NSArray <SPSDKTradingCommodity <SPSDKOrderCommodity> *> *orderCommodityList;

/**
 快递地址信息
 */
@property (nonatomic, readonly, strong) SPSDKShippingAddress *shippingAddrInfo;

/**
 搭配的优惠券列表
 */
@property (nonatomic, readonly, strong) NSArray <SPSDKCoupon *> *couponsList;

/**
 预订单状态
 */
@property (nonatomic, readonly) SPSDKPreOrderStatus status;

@end
