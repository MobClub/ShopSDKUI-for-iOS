//
//  SPSDKTransport.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/8/31.
//  Copyright © 2017年 Mob. All rights reserved.
//


#import <MOBFoundation/MOBFDataModel.h>

@class SPSDKTransportDesc;

/**
 *  物流信息实体
 */
@interface SPSDKTransport : MOBFDataModel

/**
 *  快递单号
 */
@property (nonatomic,readonly) UInt64 transportId;

/**
 *  真实物流单号
 */
@property (nonatomic,readonly) NSString *expressNo;

/**
 *  物流描述列表
 */
@property (nonatomic, strong, readonly) NSArray <SPSDKTransportDesc *> *expressDescribe;

/**
 *  物流公司
 */
@property (nonatomic, copy, readonly) NSString *expressCompanyName;

/**
 最后更新时间
 */
@property (nonatomic, readonly) NSUInteger updateAt;

/**
 *  物流创建时间
 */
@property (nonatomic, readonly) NSUInteger expressCreateAt;

/**
 最近一次描述
 */
@property (nonatomic, copy, readonly) NSString *expressDescribeLast;

/**
 通过快递单号构造物流对象

 @param transportId 快递单号
 */
- (instancetype)initWithTransportId:(UInt64)transportId;

@end
