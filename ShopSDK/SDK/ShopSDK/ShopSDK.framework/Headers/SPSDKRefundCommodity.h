//
//  SPSDKRefundCommodity.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/9/4.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>
#import "SPSDKTypeDefine.h"

@class SPSDKImage;

/**
 退款商品实体
 */
@interface SPSDKRefundCommodity : MOBFDataModel

/**
 所属订单商品
 */
@property (nonatomic, readonly, strong) SPSDKTradingCommodity *orderCommodity;

/**
 商品名称
 */
@property (nonatomic, copy, readonly) NSString *productName;

/**
 订单商品数量
 */
@property (nonatomic, readonly) UInt64 orderCommodityCount;

/**
 购买金额
 */
@property (nonatomic, readonly) NSUInteger paidMoney;

/**
 购买商品型号名称
 */
@property (nonatomic, copy, readonly) NSString *propertyDescribe;

/**
 商品照片路径
 */
@property (nonatomic, copy, readonly) SPSDKImage *image;

/**
 退款金额
 */
@property (nonatomic, readonly) NSUInteger refundFee;

/**
 退款退货类型
 */
@property (nonatomic, readonly) SPSDKRefundType refundType;

/**
 退货状态
 */
@property (nonatomic, readonly) SPSDKRefundStatus status;

@end
