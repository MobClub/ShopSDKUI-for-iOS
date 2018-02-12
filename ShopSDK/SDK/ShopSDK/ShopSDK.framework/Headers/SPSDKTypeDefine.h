//
//  SPSDKTypeDefine.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/8/30.
//  Copyright © 2017年 Mob. All rights reserved.
//

#ifndef SPSDKTypeDefine_h
#define SPSDKTypeDefine_h

@class SPSDKProduct;
@class SPSDKCommodity;
@class SPSDKCommodityProperty;
@class SPSDKOrderCommodity;
@class SPSDKProductComment;
@class SPSDKShoppingCartCommodity;
@class SPSDKCoupon;
@class SPSDKShippingAddress;
@class SPSDKTransportStrategy;
@class SPSDKProductLabel;
@class SPSDKStatisticInfo;
@class SPSDKPreOrder;
@class SPSDKOrder;
@class SPSDKTransport;
@class SPSDKRefundReason;
@class SPSDKRefundDetail;
@class SPSDKRefundCommodity;
@class SPSDKArea;
@class SPSDKTransportCompany;
@class SPSDKPreRefund;
@class SPSDKTradingCommodity;

@protocol SPSDKOrderCommodity;
@protocol SPSDKShoppingCartCommodity;
/**
 错误域
 */
static NSString * const SPSDKErrorDomain = @"SPSDKErrorDomain";
static NSString * const SPSDKErrorMessage = @"SPSDKErrorMessage";
/**
 错误状态码枚举
 */
typedef NS_ENUM(NSUInteger, SPSDKErrorCode) {
    SPSDKErrorCodeInterfaceFailed           = 140001,   //内部接口失败
    SPSDKErrorCodeInvalidParams             = 140002,   //参数无效
    SPSDKErrorCodeInsufficientPermissions   = 140003,   //权限不足
    SPSDKErrorCodeUnknow                    = 140010,   //服务器未知错误
    SPSDKErrorCodeSystemError               = 140020,   //系统级错误
};

/**
 查询订单排序
 */
typedef NS_ENUM(NSUInteger, SPSDKOrdered) {
    SPSDKOrderedNone = 0,   //无序
    SPSDKOrderedAscending,  //升序
    SPSDKOrderedDescending  //降序
};

/**
 评论查询星级筛选
 */
typedef NS_ENUM(NSUInteger, SPSDKCommentStars) {
    SPSDKCommentStarsNone = 0,      //不区分星级
    SPSDKCommentStarsOne = 1,       //一星
    SPSDKCommentStarsTwo = 2,       //二星
    SPSDKCommentStarsThree = 3,     //三星
    SPSDKCommentStarsFour = 4,      //四星
    SPSDKCommentStarsFive = 5,      //五星
};

/**
 评论查询评级筛选
 */
typedef NS_ENUM(NSUInteger, SPSDKCommentLevel) {
    SPSDKCommentLevelNone = 0,  //不区分评论等级
    SPSDKCommentLevelPositive,  //好评
    SPSDKCommentLevelMedium,    //中评
    SPSDKCommentLevelNegative   //差评
};

/**
 评论查询图片筛选
 */
typedef NS_ENUM(NSUInteger, SPSDKPictureFilter) {
    SPSDKPictureFilterNone = 0,     //不区分是否有图片
    SPSDKPictureFilterHasPicture,   //带图片
    SPSDKPictureFilterNoPicture     //不带图片
};

/**
 优惠券状态
 */
typedef NS_ENUM(NSUInteger, SPSDKCouponStatus) {
    SPSDKCouponStatusReceivable = 0,    //未领取(可以领取)
    SPSDKCouponStatusUnused,            //未使用(已领取)
    SPSDKCouponStatusUsed,              //已使用
    SPSDKCouponStatusExpired,           //已过期
    SPSDKCouponStatusDisabled           //已禁用
};

/**
 预订单状态
 */
typedef NS_ENUM(NSUInteger, SPSDKPreOrderStatus) {
    SPSDKPreOrderStatusNomal = 0,       //正常
    SPSDKPreOrderCommodityError,        //预订单存在问题商品
    SPSDKPreOrderAddressError,          //预订单地址错误
};

/**
 订单状态
 */
typedef NS_ENUM(NSUInteger, SPSDKOrderStatus) {
    SPSDKOrderStatusAll = 0,    //0.不区分状态(全部)
    SPSDKOrderUnpaid,           //1.待付款
    SPSDKOrderUnDelivery,       //2.已支付,待发货
    SPSDKOrderUnReceive,        //3.待收货
    SPSDKOrderFinished,         //4.订单完成
    SPSDKOrderCanceled          //5.订单取消
};

/**
 商品状态
 */
typedef NS_ENUM(NSUInteger, SPSDKCommodityStatus) {
    SPSDKCommodityStatusNomal = 0,      //正常
    SPSDKCommodityStatusOffShelf,       //下架
    SPSDKCommodityStatusOutOffStock,    //库存不足
    SPSDKCommodityStatusUnavailable,    //商品不可用
    SPSDKCommodityStatusOutOffDelivery, //不在配送范围
    SPSDKCommodityStatusRefunding,      //退货中
    SPSDKCommodityStatusRefundFinshined //退款完成
};

/**
 修改订单状态枚举
 */
typedef NS_ENUM(NSUInteger, SPSDKModifyOrderStatus) {
    SPSDKModifyOrderStatusCancel = 1,   //取消订单
    SPSDKModifyOrderStatusDelete,       //删除订单
    SPSDKModifyOrderStatusReceived      //确认收货
};


typedef NS_ENUM(NSUInteger, SPSDKRefundAddressType) {
    SPSDKRefundAddressTypeAdd = 0,      //添加
    SPSDKRefundAddressTypeModify        //修改
};

typedef NS_ENUM(NSUInteger, SPSDKSupportedRefundType) {
    SPSDKSupportedRefundTypeAll = 0,    //支持退款退货
    SPSDKSupportedRefundTypeMoneyOnly   //仅支持退款退款
};

typedef NS_ENUM(NSUInteger, SPSDKRefundType) {
    SPSDKRefundTypeMoneyOnly = 0,      //仅退款
    SPSDKRefundTypeAll                  //退款退货
};

typedef NS_ENUM(NSUInteger, SPSDKRefundStatus) {
    SPSDKRefundStatusApplying = 0,        //申请退款中
    SPSDKRefundStatusAgree,               //商家同意,等待发货
    SPSDKRefundStatusSellerRejected,      //商家驳回
    SPSDKRefundStatusTransporting,        //退货商品寄送中
    SPSDKRefundStatusSuccess,             //退款成功
    SPSDKRefundStatusRefundClosed,        //取消退款或操作超时
    SPSDKRefundStatusRefunding            //正在退款中
};

typedef NS_ENUM(NSUInteger, SPSDKPayType) {
    SPSDKPayTypeWechat = 22,      //微信支付
    SPSDKPayTypeAlipay = 50       //支付宝支付
};

typedef NS_ENUM (NSUInteger, SPSDKClientPayStatus){
    SPSDKClientPayStatusSuccess = 1,    //客户端支付成功
    SPSDKClientPayStatusFail,       //客户端支付失败
    SPSDKClientPayStatusCancel,     //客户端取消支付
    SPSDKClientPayStatusUnknown,    //客户端未知状态
};

typedef NS_ENUM (NSUInteger, SPSDKPayResult){
    SPSDKPayResultSuccess,      //订单确认支付成功
    SPSDKPayResultFail,         //订单确认支付失败
    SPSDKPayResultCancel,       //订单确认取消支付
    SPSDKPayResultPaying        //订单正在支付中
};

typedef NS_ENUM(NSUInteger, SPSDKCommodityType) {
    SPSDKCommodityTypeShoppingCart = 1, //购物车商品
    SPSDKCommodityTypeOrder = 2         //订单商品
};

typedef NS_ENUM(NSUInteger, SPSDKPayMode) {
    SPSDKPayModeMobPay,      //支付模块使用MobPay
    SPSDKPayModeCustom       //支付模块使用自定义
};

typedef NS_ENUM(NSUInteger, SPSDKCouponType) {
    SPSDKCouponTypeCash = 1,      //现金类型优惠券
    SPSDKCouponTypeDiscount,      //折扣类型优惠券
};

/**
 *  通用回调(无任何参数返回)
 *
 *  @param error 错误
 */
typedef void(^SPSDKGeneralHandler) (NSError *error);

/**
 *  获取产品列表回调
 *
 *  @param pageIndex     页码
 *  @param countNum      数量
 *  @param productList   商品列表
 *  @param error         错误
 */
typedef void(^SPSDKProductHandler) (NSUInteger pageIndex,
                                    NSUInteger countNum,
                                    NSArray<SPSDKProduct *> *productList,
                                    NSError *error);


/**
 *  获取产品列表回调
 *
 *  @param productList   商品列表
 *  @param error         错误
 */
typedef void(^SPSDKProductFromIDsHandler) (NSArray<SPSDKProduct *> *productList,
                                           NSError *error);


/**
 *  获取商品详情回调
 *
 *  @param properties    商品属性
 *  @param commodityList 商品列表
 *  @param error         错误
 */
typedef void(^SPSDKCommodityDetailHandler) (NSDictionary <NSString *, NSArray <SPSDKCommodityProperty*> *> *properties,
                                            NSArray<SPSDKCommodity *> *commodityList,
                                            NSError *error);

/**
 *  获取产品详情回调
 *
 *  @param product 产品实体
 *  @param error   错误
 */
typedef void(^SPSDKProductDetailHandler) (SPSDKProduct *product, NSError *error);

/**
 *  获取产品评论回调
 *
 *  @param pageIndex                 页码
 *  @param countNum                  数量
 *  @param praiseRate 好评率
 *  @param commentList               评论列表
 *  @param error                     错误
 */
typedef void(^SPSDKProductCommentHandler) (NSUInteger pageIndex,
                                           NSUInteger countNum,
                                           NSString *praiseRate,
                                           NSArray<SPSDKProductComment *> *commentList,
                                           NSUInteger picCommentCount,
                                           NSDictionary *countByStars,
                                           NSError *error);
/**
 *  获取购物车列表回调
 *
 *  @param itemList 购物车列表
 *  @param error    错误
 */
typedef void(^SPSDKShoppingCartItemHandler) (NSArray<SPSDKTradingCommodity <SPSDKShoppingCartCommodity> *> * shoppingCartCommodityList,
                                             NSError *error);
/**
 *  获取优惠券列表回调
 *
 *  @param pageIndex  页码
 *  @param count      数量
 *  @param couponList 优惠券列表
 *  @param error      错误
 */
typedef void(^SPSDKCouponHandler) (NSUInteger pageIndex,
                                   NSUInteger count,
                                   NSArray<SPSDKCoupon *> *couponList,
                                   NSError *error);

/**
 获取优惠券列表回调(无翻页)

 @param couponList 优惠券列表
 @param error 错误
 */
typedef void(^SPSDKCouponListHandler) (NSArray<SPSDKCoupon *> *couponList,
                                       NSError *error);

/**
 创建收获地址回调

 @param address 收获地址
 @param error 回调
 */
typedef void(^SPSDKCreateAddressHandler) (SPSDKShippingAddress *address, NSError *error);


/**
 *  获取收货地址回调
 *
 *  @param addressList  地址列表
 *  @param error        错误
 */
typedef void(^SPSDKShippingAddressHandler) (NSArray<SPSDKShippingAddress *> *addressList,
                                            NSError *error);

/**
 *  商品列表配送策略回调
 *
 *  @param strategyList 策略列表
 *  @param error        错误
 */
typedef void(^SPSDKTransportStrategyHandler) (NSArray<SPSDKTransportStrategy *> *strategyList,
                                              NSError *error);

/**
 *  商品列表产品标签回调
 *
 *  @param strategyList 标签列表
 *  @param error        错误
 */
typedef void(^SPSDKProductLabelHandler) (NSArray<SPSDKProductLabel *> *labelList,
                                         NSError *error);

/**
 *  订单状态统计回调
 *
 *  @param statisticInfoList 状态信息列表
 *  @param error             错误
 */
typedef void(^SPSDKStatisticInfoHandler) (NSArray<SPSDKStatisticInfo *> *statisticInfoList,
                                          NSError *error);

/**
 生成预订单回调

 @param preOrder 预订单
 @param error 错误
 */
typedef void(^SPSDKPreOrderHandler) (SPSDKPreOrder *preOrder,
                                      NSError *error);

/**
 生成订单回调

 @param orderId 订单号
 @param error 错误
 */
typedef void(^SPSDKCreateOrderHandler) (SPSDKOrder *order,
                                        NSError *error);


typedef void(^SPSDKGetOrdersHandler) (NSUInteger pageIndex,
                                      NSUInteger count,
                                      NSArray<SPSDKOrder *> *orderList,
                                      NSError *error);

typedef void(^SPSDKGetOrderDetailHandler) (SPSDKOrder *order,
                                           NSError *error);

/**
 查询物流信息回调
 
 @param transport 物流信息
 @param error     错误
 */
typedef void(^SPSDKTransportHandler) (SPSDKTransport *transport,
                                      NSError *error);

/**
 查询退款商品列表回调

 @param pageIndex 页码
 @param countNum 总量
 @param commodityList 退款商品列表
 @param error 错误
 */
typedef void(^SPSDKGetRefundsHandler) (NSUInteger pageIndex,
                                       NSUInteger countNum,
                                       NSArray<SPSDKRefundCommodity *> *commodityList,
                                       NSError *error);

/**
 预申请退款回调

 @param preRefund 预退款实体
 @param error 错误
 */
typedef void(^SPSDKPreRefundHandler) (SPSDKPreRefund *preRefund,
                                      NSError *error);
/**
 获取商品退款详细信息回调

 @param detail 退款详细信息
 @param error 错误
 */
typedef void(^SPSDKGetRefundDetailHandler) (SPSDKRefundDetail *detail,
                                            NSError *error);


/**
 查询省市区信息列表回调

 @param gisList 信息列表
 @param error 错误
 */
typedef void(^SPSDKGetAreaHandler) (NSArray<SPSDKArea *> *areaList,
                                   NSError *error);

/**
 订单运费查询

 @param Freight 总运费
 @param invalidOrderCommoityList 无效订单id列表
 @param error 错误
 */
typedef void(^SPSDKFreightHandler) (NSUInteger Freight,
                                    NSArray <NSString *> *invalidOrderCommoityList,
                                    NSError *error);

/**
 获取物流公司列表回调

 @param companyList 物流公司列表
 @param error 错误
 */
typedef void(^SPSDKGetTransportCompanyHandler) (NSArray<SPSDKTransportCompany *> *companyList,
                                                NSError *error);

/**
 查询订单交易状态回调

 @param payStatus 交易结果
 @param error 错误
 */
typedef void(^SPSDKPayResultHandler) (SPSDKPayResult payResult,
                                      NSError *error);

/**
 获取支付票据回调
 
 @param clientPayStatus 客户端支付结果
 @param error 错误
 */
typedef void(^SPSDKPayOrderHandler) (SPSDKClientPayStatus clientPayStatus,
                                     NSError *error);

/**
 获取订单自定义字段回调

 @param customField 自定义字段
 @param error 错误
 */
typedef void(^SPSDKOrderCustomFieldHandler) (NSArray *customFields,
                                             NSError *error);

#endif /* SPSDKTypeDefine_h */
