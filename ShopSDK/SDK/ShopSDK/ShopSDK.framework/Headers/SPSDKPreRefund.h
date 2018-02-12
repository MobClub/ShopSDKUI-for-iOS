//
//  SPSDKPreRefund.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/10/30.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>
#import "SPSDKTypeDefine.h"

@interface SPSDKPreRefund : MOBFDataModel

/**
 最大退款金额
 */
@property (nonatomic, readonly) NSUInteger maxRefundMoney;

/**
 退款运费
 */
@property (nonatomic, readonly) NSUInteger freight;

/**
 支持的退货类型 1:退款  2：退款退货
 */
@property (nonatomic, readonly) SPSDKSupportedRefundType supportedType;

/**
 退款所属商品
 */
@property (nonatomic, readonly, strong) SPSDKTradingCommodity *orderCommodity;

@end
