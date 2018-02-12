//
//  SPSDKOrder.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/8/30.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>
#import "SPSDKTypeDefine.h"

/**
 订单实体
 */
@interface SPSDKOrder : MOBFDataModel

/**
 订单id
 */
@property (nonatomic, readonly) UInt64 orderId;

/**
 *  下单时间
 */
@property (nonatomic, readonly) NSUInteger createAt;

/**
 *  总运费
 */
@property (nonatomic, readonly) NSUInteger totalFreight;

/**
 *  用户实际支付金额
 */
@property (nonatomic, readonly) NSUInteger paidMoney;

/**
 *  优惠金额
 */
@property (nonatomic, readonly) NSUInteger totalCoupon;

/**
 *  商品总金额
 */
@property (nonatomic, readonly) NSUInteger totalMoney;

/**
 *  商品总数量
 */
@property (nonatomic, readonly) NSUInteger totalCount;

/**
 *  订单状态
 */
@property (nonatomic, readonly) SPSDKOrderStatus status;

/**
是否免单(例如经优惠后价格为0)
 */
@property (nonatomic, readonly) BOOL freeOfCharge;

/**
 *  订单商品列表
 */
@property (nonatomic, strong, readonly) NSArray <SPSDKTradingCommodity <SPSDKOrderCommodity>*> * orderCommodityList;


/*以下是 根据订单状态,关键字查询接口 时才有的属性*/

/**
 *  订单物流
 */
//@property (nonatomic, readonly) UInt64 transportId;

@property (nonatomic, readonly, strong) SPSDKTransport *transport;


/**
 本订单已被评论商品数
 */
@property (nonatomic, readonly) NSUInteger commentCount;

/**
 本订单中退款商品数
 */
@property (nonatomic, readonly) NSUInteger refundCount;

/*以下是 单个订单详情查询 时才有的属性*/

@property (nonatomic, strong, readonly) SPSDKShippingAddress *shippingAddrInfo;

/**
 *  买家留言
 */
@property (nonatomic, copy, readonly) NSString *buyerRemark;

/**
 *  客服留言
 */
@property (nonatomic, copy, readonly) NSString *sellerRemark;

/**
 待付款订单超时时间/待收货订单超时时间
 */
@property (nonatomic, readonly) NSUInteger expiration;
@end
