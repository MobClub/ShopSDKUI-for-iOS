//
//  SPSDKAppraiseModel.h
//  ShopSDKUI
//
//  Created by youzu on 2017/10/26.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPSDKAppraiseModel : NSObject

/**
 购买者名称
 */
@property (nonatomic, copy) NSString *buyerName;

/**
 照片集合
 */
@property (nonatomic, strong) NSMutableArray <UIImage *> *photos;

/**
 选中照片集合
 */
@property (nonatomic, strong) NSMutableArray *selectedAssets;

/**
 评论时间
 */
@property (nonatomic, assign) NSUInteger createAt;

/**
 产品名称
 */
@property (nonatomic, copy) NSString *productName;


/**
 评论内容
 */
@property (nonatomic, copy) NSString *comment;

/**
 评论星级
 */
@property (nonatomic, assign) NSUInteger commentStars;

/**
 型号名称
 */
@property (nonatomic, copy) NSString *propertyDescribe;

/**
 是否匿名
 */
@property (nonatomic, assign) BOOL anonymity;

/**
 订单商品Id
 */
@property (nonatomic, assign) UInt64 orderCommodityId;

/**
 商品Id
 */
@property (nonatomic, assign) UInt64 commodityId;

@end
