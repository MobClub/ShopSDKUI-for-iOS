//
//  SPSDKRefundDesc.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/9/5.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>
#import "SPSDKTypeDefine.h"

@class SPSDKImage;

/**
 退款描述
 */
@interface SPSDKRefundDesc : MOBFDataModel

//*  所有状态的公共属性 *//

/**
 状态
 */
@property (nonatomic, readonly) SPSDKRefundStatus status;

/**
 事件时间
 */
@property (nonatomic, readonly) NSUInteger createAt;

/**
 退货类型 1:退款  2：退款退货
 */
@property (nonatomic, readonly) SPSDKRefundType refundType;


#pragma mark - SPSDKRefundStatusApplying - 0 申请退款
//* 申请退款 *//

/**
 退款金额
 */
@property (nonatomic, readonly) NSUInteger refundFee;

/**
 照片
 */
@property (nonatomic, copy ,readonly) NSArray <SPSDKImage *> *refundImgs;

/**
 退款说明
 */
@property (nonatomic, copy ,readonly) NSString *refundDesc;

/**
 退款原因
 */
@property (nonatomic, copy ,readonly) NSString *refundReason;


#pragma mark - SPSDKRefundStatusAgree - 1 商家同意,等待发货

/**
 收货人
 */
@property (nonatomic, copy ,readonly) NSString *receiver;

/**
 联系电话
 */
@property (nonatomic, copy ,readonly) NSString *receiverTelephone;

/**
 收货地址
 */
@property (nonatomic, copy ,readonly) NSString *receiverAddress;

/**
 收货备注
 */
@property (nonatomic, copy ,readonly) NSString *remark;


#pragma mark - SPSDKRefundStatusSellerRejected - 2 商家不同意/驳回

/**
 商家驳回原因
 */
@property (nonatomic, copy ,readonly) NSString *rejectReason;


#pragma mark - SPSDKRefundStatusTransporting - 3 退款商品寄送中

/**
 物流单号
 */
@property (nonatomic, copy, readonly) NSString *expressNo;

/**
 物流ID唯一标识
 */
//@property (nonatomic, readonly) UInt64 transportId;

@property (nonatomic, readonly, strong) SPSDKTransport *transport;

/**
 物流公司名称
 */
@property (nonatomic, copy ,readonly) NSString *expressCompanyName;


#pragma mark - SPSDKRefundStatusSuccess - 4 商家退款成功

/**
 退款金额  - 属性 refundFee
 */

/**
 退款成功类型 0 商户退款 1 超时退款
 */
@property (nonatomic, readonly) NSUInteger successType;


#pragma mark - SPSDKRefundStatusRefundClosed - 5 关闭退款

/**
 退款备注 - 属性 remark
 */

/**
 关闭退款类型 0 商户关闭退款  1 买家取消退款  2 超时关闭退款
 */
@property (nonatomic, readonly) NSUInteger closeType;

@end
