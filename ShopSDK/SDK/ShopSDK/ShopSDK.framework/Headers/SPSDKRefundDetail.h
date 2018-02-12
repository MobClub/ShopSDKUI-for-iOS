//
//  SPSDKRefundDetail.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/9/4.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>
#import "SPSDKTypeDefine.h"
#import "SPSDKRefundDesc.h"

@class SPSDKProduct;

/**
 退款详情实体
 */
@interface SPSDKRefundDetail : MOBFDataModel

/**
 退货状态
 */
@property (nonatomic, readonly) SPSDKRefundStatus status;

/**
 *  订单ID
 */
@property (nonatomic, readonly, strong) SPSDKOrder *order;

/**
 *  订单商品
 */
@property (nonatomic, readonly, strong) SPSDKTradingCommodity *orderCommodity;

/**
 买家处理退货时间/商家处理退货时间 (秒)
 */
@property (nonatomic, readonly) NSUInteger expiration;

/**
 申请退款时间 (时间戳)
 */
@property (nonatomic, readonly) NSUInteger createAt;
/**
 退款详情列表信息
 */
@property (nonatomic, readonly, strong) NSArray <SPSDKRefundDesc *> *descirbeList;


@end
