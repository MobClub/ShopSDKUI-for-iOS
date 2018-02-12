//
//  SPSDKCommodity.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/8/30.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>
#import "SPSDKTypeDefine.h"

@class SPSDKImage;

/**
 *  商品实体
 */
@interface SPSDKCommodity : MOBFDataModel

#pragma mark - 基本属性
/**
 商品Id
 */
@property (nonatomic, readonly) UInt64 commodityId;

/**
 商品价格
 */
@property (nonatomic, readonly) NSUInteger currentCost;

/**
 商品销售总量
 */
@property (nonatomic, readonly) NSUInteger commoditySales;

/**
 库存数量
 */
@property (nonatomic, readonly) NSUInteger usableStock;

/**
 商品主照片
 */
@property (nonatomic, copy, readonly) SPSDKImage *image;

/**
 *  型号名称
 */
@property (nonatomic, copy, readonly) NSString *propertyDescribe;

/**
 商品状态
 */
@property (nonatomic, readonly) SPSDKCommodityStatus status;

/**
 所属产品
 */
@property (nonatomic, readonly, weak) SPSDKProduct *product;

@end
