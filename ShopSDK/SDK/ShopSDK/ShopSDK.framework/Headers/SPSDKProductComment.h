//
//  SPSDKProductComment.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/8/30.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>
#import <UIKit/UIKit.h>

@class SPSDKImage;

/**
 *  产品评论实体
 */
@interface SPSDKProductComment : MOBFDataModel

/**
 购买者名称
 */
@property (nonatomic, copy, readonly) NSString *buyerName;

/**
 照片集合(一般情况下,在获取评论列表展示时使用)
 */
@property (nonatomic, strong, readonly) NSArray <SPSDKImage *> *commentImgs;

/**
 评论时间
 */
@property (nonatomic, readonly) NSUInteger createAt;

/**
 产品名称
 */
@property (nonatomic, copy, readonly) NSString *productName;


/**
 评论内容
 */
@property (nonatomic, copy, readonly) NSString *comment;

/**
 评论星级
 */
@property (nonatomic, readonly) NSUInteger commentStars;

/**
 型号名称
 */
@property (nonatomic, readonly) NSString *propertyDescribe;

/**
 是否匿名
 */
@property (nonatomic, readonly) BOOL anonymity;

/**
 订单商品Id
 */
@property (nonatomic, readonly) UInt64 orderCommodityId;

/**
 商品Id
 */
@property (nonatomic, readonly) UInt64 commodityId;

/**
 初始化方法
 
 请在添加评论时构造实体使用

 @param orderCommodityId 订单商品Id
 @param commodityId 商品Id
 @param comment 评论内容
 @param stars 评论星级
 @param imgs 图片集合
 @param isAnonymity 是否匿名
 @return 实例对象
 */
- (instancetype)initWithOrderCommodityId:(UInt64)orderCommodityId
                             commodityId:(UInt64)commodityId
                                 comment:(NSString *)comment
                                   stars:(NSUInteger)stars
                              submitImgs:(NSArray <UIImage *>*)imgs
                             isAnonymity:(BOOL)isAnonymity;

/**
 用与提交评论的照片对象集合(一般情况下,仅在添加评论时使用)
 */
@property (nonatomic, strong) NSArray <UIImage *> *submitImgs;

@end
