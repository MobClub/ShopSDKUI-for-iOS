//
//  SPSDKStatisticInfo.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/8/30.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>
#import "SPSDKTypeDefine.h"

/**
 订单统计信息实体
 */
@interface SPSDKStatisticInfo : MOBFDataModel

/**
 *  订单状态
 */
@property (nonatomic, readonly) SPSDKOrderStatus status;

/**
 *  该状态订单的数量
 */
@property (nonatomic, readonly) NSUInteger count;

@end
