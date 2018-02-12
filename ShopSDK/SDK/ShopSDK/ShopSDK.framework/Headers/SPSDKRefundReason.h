//
//  SPSDKRefundReason.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/9/4.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>
#import <UIKit/UIKit.h>
#import "SPSDKTypeDefine.h"
/**
 退款原因实体
 */
@interface SPSDKRefundReason : MOBFDataModel

/**
 退货类型 1:退款  2：退款退货
 */
@property (nonatomic, readonly) SPSDKRefundType refundType;

/**
 退款原因
 */
@property (nonatomic, copy ,readonly) NSString *refundReason;

/**
 退款说明
 */
@property (nonatomic, copy ,readonly) NSString *refundDesc;

/**
 退款金额
 */
@property (nonatomic, readonly) NSUInteger refundFee;

/**
 照片
 */
@property (nonatomic, copy ,readonly) NSArray <UIImage *> *refundImgs;

/**
 创建退款原因实体

 @param type 退款操作类型
 @param reason 原因
 @param desc 说明描述
 @param fee 金额
 @param urls 图片集合
 @return 对象
 */
- (instancetype)initWithType:(SPSDKRefundType)type
                      reason:(NSString *)reason
                        desc:(NSString *)desc
                         fee:(NSUInteger)fee
                      images:(NSArray <UIImage *> *)images;


@end
