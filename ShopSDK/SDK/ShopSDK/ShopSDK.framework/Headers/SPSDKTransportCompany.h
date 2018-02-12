//
//  SPSDKTransportCompany.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/9/4.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>

/**
 物流公司实体
 */
@interface SPSDKTransportCompany : MOBFDataModel

/**
 物流公司唯一标识
 */
@property (nonatomic, readonly) UInt64 companyId;

/**
 物流公司简称
 */
@property (nonatomic, copy, readonly) NSString *abbreviation;

/**
 公司名称首字母
 */
@property (nonatomic, copy, readonly) NSString *firstLetter;

@end
