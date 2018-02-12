//
//  SPSDKCommodityProperty.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/8/30.
//  Copyright © 2017年 Mob. All rights reserved.
//


#import <MOBFoundation/MOBFDataModel.h>

/**
 *  商品属性实体
 */
@interface SPSDKCommodityProperty : MOBFDataModel

/**
 *  本属性的上级分类,例如"颜色"
 */
@property (nonatomic, copy) NSString *propertyKey;

/**
 *  本属性属性描述,例如"红色"
 */
@property (nonatomic, copy) NSString *propertyValue;

/**
 *  属性支持的唯一商品id
 */
@property (nonatomic, strong) NSArray <NSNumber *> *commodityIds;

@end
