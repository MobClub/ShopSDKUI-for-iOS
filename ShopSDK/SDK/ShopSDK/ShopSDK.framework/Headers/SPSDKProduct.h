//
//  SPSDKProduct.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/8/30.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>

@class SPSDKImage;
@class SPSDKCommodity;
@class SPSDKProductDetail;
@class SPSDKCommodityProperty;

/**
 *  产品信息实体
 */
@interface SPSDKProduct : MOBFDataModel

/**
 *  产品Id
 */
@property (nonatomic, readonly) UInt64 productId;

/**
 *  产品名称
 */
@property (nonatomic, copy, readonly) NSString *productName;

/**
 *  产品销售总量
 */
@property (nonatomic, readonly) NSUInteger productSales;

/**
 *  产品自定义字段
 */
@property (nonatomic, strong, readonly) NSArray *customProductFields;

/**
 *  当前展现的商品信息
 */
@property (nonatomic, weak, readonly) SPSDKCommodity *showCommodity;

/* 产品详情相关(需要调用产品详情接口) */

/**
 *  最高价格
 */
@property (nonatomic, readonly) NSUInteger maxPrice;

/**
 *  最低价格
 */
@property (nonatomic, readonly) NSUInteger minPrice;

/**
 *  产品照片路径以及对应的排序
 */
@property (nonatomic, strong, readonly) NSArray <SPSDKImage *> *productImages;

/**
 *  产品详情照片路径以及对应的排序信息
 */
@property (nonatomic, strong, readonly) NSArray <NSDictionary <NSString*, NSString*> *> *productAdditionalInfos;

/**
 *  产品属性信息(需要调用商品详情接口填充)
 */
@property (nonatomic, strong, readonly) NSDictionary <NSString*, NSMutableArray <SPSDKCommodityProperty*> *> *properties;

/**
 *  产品下属商品(需要调用商品详情接口填充)
 */
@property (nonatomic, strong, readonly) NSArray <SPSDKCommodity *> *commodities;

@end
