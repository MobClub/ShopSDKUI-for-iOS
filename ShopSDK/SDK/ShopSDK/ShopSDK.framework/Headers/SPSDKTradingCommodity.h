//
//  SPSDKTradingCommodity.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/12/6.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>
#import "SPSDKTypeDefine.h"

@class SPSDKCommodity;
@class SPSDKProduct;

@protocol SPSDKOrderCommodity;
@protocol SPSDKShoppingCartCommodity;

@interface SPSDKTradingCommodity : MOBFDataModel 

/**
 商品类型
 */
@property (nonatomic) SPSDKCommodityType commodityType;

/**
 所属产品
 */
@property (nonatomic, readonly, strong) SPSDKProduct *product;

/**
 所属基本商品
 */
@property (nonatomic, readonly, strong) SPSDKCommodity *commodity;

/**
 *  购买数量/商品数量
 */
@property (nonatomic) NSUInteger count;

#pragma mark - 购物车商品具备属性
/**
 购物车商品ID
 */
@property (nonatomic, readonly) UInt64 cartCommodityId;

#pragma mark - 订单商品具备属性
/**
 *  订单商品ID
 */
@property (nonatomic, readonly) UInt64 orderCommodityId;

/**
 支付金额
 */
@property (nonatomic, readonly) NSUInteger paidMoney;

/**
 运费
 */
@property (nonatomic) NSInteger freight;

/**
 是否已评价
 */
@property (nonatomic, readonly) BOOL comment;

/**
 基本商品转换通用商品
 
 @param commodity 基本商品
 @param count 数量
 @return 通用商品
 */
- (instancetype)initWithCommodity:(SPSDKCommodity *)commodity count:(NSUInteger)count;

@end

@protocol SPSDKOrderCommodity <NSObject>

/**
 *  订单商品ID
 */
@property (nonatomic, readonly) UInt64 orderCommodityId;

/**
 支付金额
 */
@property (nonatomic, readonly) NSUInteger paidMoney;

/**
 运费
 */
@property (nonatomic) NSInteger freight;

/**
 是否已评价
 */
@property (nonatomic, readonly) BOOL comment;

@end

@protocol SPSDKShoppingCartCommodity <NSObject>

/**
 购物车商品ID
 */
@property (nonatomic, readonly) UInt64 cartCommodityId;

@end
