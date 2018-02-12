//
//  ShopSDK.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/8/29.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SPSDKArea.h"
#import "SPSDKOrder.h"
#import "SPSDKImage.h"
#import "SPSDKCoupon.h"
#import "SPSDKProduct.h"
#import "SPSDKPreOrder.h"
#import "SPSDKPreRefund.h"
#import "SPSDKTransport.h"
#import "SPSDKCommodity.h"
#import "SPSDKRefundDesc.h"
#import "SPSDKRefundDetail.h"
#import "SPSDKProductLabel.h"
#import "SPSDKRefundReason.h"
#import "SPSDKTransportDesc.h"
#import "SPSDKStatisticInfo.h"
#import "SPSDKProductComment.h"
#import "SPSDKRefundCommodity.h"
#import "SPSDKShippingAddress.h"
#import "SPSDKTradingCommodity.h"
#import "SPSDKTransportCompany.h"
#import "SPSDKCommodityProperty.h"
#import "SPSDKTransportStrategy.h"


#import "SPSDKTypeDefine.h"

@interface ShopSDK : NSObject


#pragma mark - 全局配置

/**
 物流公司查询
 
 @param result 回调
 */
+ (void)queryTransportCompanyResult:(SPSDKGetTransportCompanyHandler)result;

/**
 获取省市区详细信息
 
 @param result 回调
 */
+ (void)getArea:(SPSDKGetAreaHandler)result;

/**
 获取商品列表配送策略
 
 @param result 回调
 */
+ (void)getTransportStrategy:(SPSDKTransportStrategyHandler)result;

/**
 获取商品列表产品标签
 
 @param numb 标签数量
 @param result 回调
 */
+ (void)getLabelsWithNumb:(NSUInteger)numb result:(SPSDKProductLabelHandler)result;

/**
 获取订单自定义字段
 
 @param result 回调
 */
+ (void)getOrderCustomField:(SPSDKOrderCustomFieldHandler)result;

#pragma mark - 用户相关
/**
 创建收货地址
 
 @param address     收件地址实体
 */
+ (void)createShippingAddress:(SPSDKShippingAddress *)address result:(SPSDKCreateAddressHandler)result;

/**
 修改收货地址
 
 @param shippingAddrId 原收货地址id
 @param address 收货地址信息
 @param result 回调
 */
+ (void)modifyShippingAddressWithId:(UInt64)shippingAddrId
                            address:(SPSDKShippingAddress *)address
                             result:(SPSDKCreateAddressHandler)result;

/**
 查询收货地址
 
 @param result  回调
 */
+ (void)getShippingAddress:(SPSDKShippingAddressHandler)result;

/**
 删除收货地址信息
 
 @param address 地址信息
 @param result 回调
 */
+ (void)deleteShippingAddress:(SPSDKShippingAddress *)address result:(SPSDKGeneralHandler)result;


#pragma mark - 商品相关
/**
 产品列表查询接口
 
 @param keyword         关键字
 @param minPrice        最低价格
 @param maxPrice        最高价格
 @param strategyId      配送策略ID
 @param list            标签id数组
 @param timeOrdered     时间排序
 @param priceOrdered    价格排序
 @param salesOrdered    销量排序
 @param pageSize        单页数量
 @param pageIndex       页码(从1开始)
 @param result          回调结果
 */
+ (void)getProductsWithKeyword:(NSString *)keyword
                      minPrice:(NSUInteger)minPrice
                      maxPrice:(NSUInteger)maxPrice
           transportStrategyId:(UInt64)strategyId
                   labelIdList:(NSArray <NSNumber *>*)list
                      timeSort:(SPSDKOrdered)timeOrdered
                     priceSort:(SPSDKOrdered)priceOrdered
                     salesSort:(SPSDKOrdered)salesOrdered
                      pageSize:(NSUInteger)pageSize
                     pageIndex:(NSUInteger)pageIndex
                        result:(SPSDKProductHandler)result;

/**
 根据产品id数组获取产品列表 (未开放,待定)
 
 @param productIds 产品id数组
 @param timeOrdered 时间排序
 @param priceOrdered 价格排序
 @param salesOrdered 销量排序
 @param result 回调
 */
+ (void)getProductsWithProductIDs:(NSArray<NSNumber *> *)productIds
                         timeSort:(SPSDKOrdered)timeOrdered
                        priceSort:(SPSDKOrdered)priceOrdered
                        salesSort:(SPSDKOrdered)salesOrdered
                           result:(SPSDKProductFromIDsHandler)result;


/**
 产品详情查询接口(通过产品查询)
 
 @param product 产品实体
 @param result  回调结果
 */
+ (void)getProductDetailWithProduct:(SPSDKProduct *)product result:(SPSDKProductDetailHandler)result;

/**
 商品详情查询接口
 
 @param product   商品
 @param result    回调结果
 */
+ (void)getCommodityDetailsWithProduct:(SPSDKProduct *)product result:(SPSDKCommodityDetailHandler)result;

/**
 添加商品评论
 
 @param order   需要进行评论的订单
 @param comments 评论实体,支持对同一订单下多个商品进行批量评论
 @param result  回调
 */
+ (void)addCommentWithOrder:(SPSDKOrder *)order
                   comments:(NSArray <SPSDKProductComment *>*)comments
                     result:(SPSDKGeneralHandler)result;

/**
 获取产品评论接口
 
 @param product   产品实体
 @param level     评论等级 (过滤条件,最优先)
 @param stars     评论星级 (过滤条件)
 @param picFilter 是否带图 (过滤条件)
 @param pageSize  单页数量
 @param pageIndex 页码(从1开始)
 @param result    回调
 */
+ (void)getCommentsWithProduct:(SPSDKProduct *)product
                         level:(SPSDKCommentLevel)level
                  commentStars:(SPSDKCommentStars)stars
                    hasPicture:(SPSDKPictureFilter)picFilter
                      pageSize:(NSUInteger)pageSize
                     pageIndex:(NSUInteger)pageIndex
                        result:(SPSDKProductCommentHandler)result;

#pragma mark - 商品相关(购物车)
/**
 添加到购物车
 
 @param tradingCommodity 通用商品
 @param result          回调
 */
+ (void)addIntoShoppingCartWithCommodity:(SPSDKTradingCommodity *)tradingCommodity result:(SPSDKGeneralHandler)result;

/**
 获取购物车列表
 
 @param buyerId 用户id
 @param result  回调
 */
+ (void)getShoppingCartItems:(SPSDKShoppingCartItemHandler)result;

/**
 修改购物车商品数量
 
 @param modifyList  需要修改数量的购物车商品列表
 @param result      回调
 */
+ (void)modifyShoppingCartItemAmount:(NSArray <SPSDKTradingCommodity *> *)modifyList result:(SPSDKGeneralHandler)result;

/**
 购物车删除指定商品
 
 @param deleteList  需要删除的购物车商品列表
 @param result      回调
 */
+ (void)deleteFromShoppingCart:(NSArray <SPSDKTradingCommodity *> *)deleteList result:(SPSDKGeneralHandler)result;

#pragma mark - 商品相关(辅助接口)
/**
 商品筛选
 
 一个产品下有多个规格(属性)组成了商品。本方法提供便捷功能,通过选中的商品属性以及产品,帮助筛选出唯一的商品
 
 @param properties 产品
 @param product 选中的属性数组
 @return 经筛选得出的商品对象。  【注:如果返回为空,则表示选中的属性数组条件不足以决定一个商品,或无法决定一个商品。建议用户每次改变选择时均调用此方法进行筛选】
 */
+ (SPSDKCommodity *)commodityWithProperties:(NSArray <SPSDKCommodityProperty *> *)properties product:(SPSDKProduct *)product;

/**
 商品筛选 - 确认商品可选属性
 
 @param selectedProperties 已选择的属性
 @param key 需要查找的属性项
 @param product 产品
 @return 某属性下的可选属性
 */
+ (NSArray <SPSDKCommodityProperty *> *)filterProperties:(NSArray < SPSDKCommodityProperty *> *)selectedProperties
                                             propertyKey:(NSString *)key
                                                 product:(SPSDKProduct *)product;


#pragma mark - 订单相关

/**
 预订单提交
 
 预订单提交,是会根据 商品,快递地址,优惠券等若干因素组成一个预订单实体。预订单可以提供价格的参考,为确认生成订单提供准备。
 变更条件时(例如变更使用的快递地址,变更使用或不使用优惠券,变更商品列表),应再次调用本接口重新获取预订单。【因为不同的条件,展示的价格是不同的】
 
 @param shippingAddress 快递地址
 @param commodityList 商品列表
 @param couponList 优惠券集合
 @param enable 是否使用优惠券
 
 @param result 回调
 */
+ (void)preOrderWithAddress:(SPSDKShippingAddress *)shippingAddress
              commodityList:(NSArray <SPSDKTradingCommodity *> *)commodityList
                 couponList:(NSArray <SPSDKCoupon *> *)couponList
               enableCoupon:(BOOL)enable
                     result:(SPSDKPreOrderHandler)result;

/**
 创建订单
 
 本接口应在调取【预订单提交】后调用。真正的订单将会在此接口生成。
 
 @param preOrder 预订单对象
 @param buyerRemark 买家留言备注
 @param result 回调
 */
+ (void)createOrderWithPreOrder:(SPSDKPreOrder *)preOrder
                    buyerRemark:(NSString *)buyerRemark
                         result:(SPSDKCreateOrderHandler)result;

/**
 修改订单状态(订单取消/删除/确认收货)
 
 @param status  需要进行修改的状态
 @param order   订单
 @param result  回调
 */
+ (void)modifyOrderStatus:(SPSDKModifyOrderStatus)status
                    order:(SPSDKOrder *)order
                   result:(SPSDKGeneralHandler)result;


/**
 根据 订单状态/关键字 查询订单
 
 @param keyWord   关键字
 @param status    需要查询的订单状态
 @param pageSize  单页数量
 @param pageIndex 页码(从1开始)
 @param result    回调
 */
+ (void)getOrdersWithKeyWord:(NSString *)keyWord
                  OrderStaus:(SPSDKOrderStatus)status
                    pageSize:(NSUInteger)pageSize
                   pageIndex:(NSUInteger)pageIndex
                      result:(SPSDKGetOrdersHandler)result;

/**
 获取各订单状态统计数据
 
 @param result  回调
 */
+ (void)getOrdersStatisticInfo:(SPSDKStatisticInfoHandler)result;

/**
 获取单个订单详情(根据订单获取)
 
 @param order   订单
 @param result  回调
 */
+ (void)getOrderDetailWithOrder:(SPSDKOrder *)order result:(SPSDKGetOrderDetailHandler)result;

/**
 查询物流信息

 @param transport   订单物流
 @param result      回调
 */
+ (void)queryExpressWithTransport:(SPSDKTransport *)transport result:(SPSDKTransportHandler)result;

#pragma mark - 支付模块

/**
 支付订单
 
 @param order 订单对象
 @param payType 支付类型
 @param result 回调
 */
+ (void)payWithOrder:(SPSDKOrder *)order
             payType:(SPSDKPayType)payType
              result:(SPSDKPayOrderHandler)result;

/**
 订单交易结果查询
 
 @param order 订单实体
 @param payMode 支付模式
 @param status 客户端支付结果
 @param result 回调
 */
+ (void)queryOrderTradingResultWithOrder:(SPSDKOrder *)order
                                 payMode:(SPSDKPayMode)payMode
                         clientPayStatus:(SPSDKClientPayStatus)status
                                  result:(SPSDKPayResultHandler)result;

#pragma mark - 退换货相关

/**
 预申请退款接口(根据商品进行预退款申请)

 @param orderCommodity 订单商品
 @param result 回调
 */
+ (void)refundPreviewWithOrderCommodity:(SPSDKTradingCommodity *)orderCommodity result:(SPSDKPreRefundHandler)result;

/**
 退款申请
 
 @param orderCommodity 退款订单商品
 @param reason 退款理由
 @param result 回调
 */
+ (void)refundWithOrderCommodity:(SPSDKTradingCommodity *)orderCommodity
                    refundReason:(SPSDKRefundReason *)reason
                          result:(SPSDKGeneralHandler)result;

/**
 取消退款
 
 @param orderCommodity 订单商品
 @param result 回调
 */
+ (void)cancelRefundWithOrderCommodity:(SPSDKTradingCommodity *)orderCommodity result:(SPSDKGeneralHandler)result;

/**
 查询退款商品列表
 @param keyWord 关键字
 @param pageSize 单页数量
 @param pageIndex 页码(从1开始)
 @param result 回调
 */
+ (void)getRefundsWithKeyWord:(NSString *)keyWord
                     pageSize:(NSUInteger)pageSize
                    pageIndex:(NSUInteger)pageIndex
                       result:(SPSDKGetRefundsHandler)result;

/**
 查看退款商品详情
 
 @param orderCommodity 订单商品
 @param result 回调
 */
+ (void)getRefundDetailWithOrderCommodity:(SPSDKTradingCommodity *)orderCommodity result:(SPSDKGetRefundDetailHandler)result;

/**
 退款物流信息添加/修改操作
 
 @param orderCommodity 订单商品
 @param type 操作类型
 @param transport 物流信息实体
 @param expressCompany 物流公司实体
 @param result 回调
 */
+ (void)fillInExpressInfoWithOrderCommodity:(SPSDKTradingCommodity *)orderCommodity
                              operationType:(SPSDKRefundAddressType)type
                                  transport:(SPSDKTransport *)transport
                             expressCompany:(SPSDKTransportCompany *)expressCompany
                                     result:(SPSDKGeneralHandler)result;

#pragma mark - 优惠券相关

/**
 获取优惠券列表信息(已领取,已属于用户的优惠券)
 
 @param status  优惠券状态(查询条件)
 @param pageSize 单页数量
 @param pageIndex 页码(从1开始)
 @param result  回调
 */
+ (void)getCouponsWithStatus:(SPSDKCouponStatus)status
                    pageSize:(NSUInteger)pageSize
                   pageIndex:(NSUInteger)pageIndex
                      result:(SPSDKCouponHandler)result;

/**
 领取优惠券
 
 @param coupon 优惠券【可领取优惠券列表中优惠券对象】
 @param result 回调
 */
+ (void)receiveCoupon:(SPSDKCoupon *)coupon result:(SPSDKGeneralHandler)result;

/**
 获取可领取的优惠券列表
 
 @param pageSize 单页数量
 @param pageIndex 页码(从1开始)
 @param result 回调
 */
+ (void)getReceivableCouponsWithPageSize:(NSUInteger)pageSize
                               pageIndex:(NSUInteger)pageIndex
                                  result:(SPSDKCouponHandler)result;

/**
 根据订单商品列表查询可用的优惠券
 
 @param list 商品列表
 @param result 回调
 */
+ (void)getUsableCouponWithCommodityList:(NSArray <SPSDKTradingCommodity *> *)list result:(SPSDKCouponListHandler)result;

@end
