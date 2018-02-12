//
//  SPSDKTransportStrategy.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/8/30.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>

/**
 *  配送策略实体
 */
@interface SPSDKTransportStrategy : MOBFDataModel

/**
 *  策略名称
 */
@property (nonatomic, copy, readonly) NSString *strategyName;

/**
 *  策略Id
 */
@property (nonatomic, readonly) UInt64 strategyId;

@end
