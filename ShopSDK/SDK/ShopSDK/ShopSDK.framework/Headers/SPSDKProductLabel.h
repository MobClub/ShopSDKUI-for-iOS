//
//  SPSDKProductLabel.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/8/30.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>

/**
 *  商品标签实体
 */
@interface SPSDKProductLabel : MOBFDataModel

/**
 *  标签名称
 */
@property (nonatomic, copy, readonly) NSString *labelName;

/**
 *  标签Id
 */
@property (nonatomic, readonly) UInt64 labelId;

@end
