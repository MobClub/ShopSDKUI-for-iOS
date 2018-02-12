//
//  SPSDKTransportDesc.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/8/31.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>

/**
 *  物流信息描述实体
 */
@interface SPSDKTransportDesc : MOBFDataModel

/**
 *  时间描述
 */
@property (nonatomic, copy, readonly) NSString *time;

/**
 *  描述信息
 */
@property (nonatomic, copy, readonly) NSString *status;


@end
