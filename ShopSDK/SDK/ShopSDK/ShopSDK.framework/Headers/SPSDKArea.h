//
//  SPSDKArea.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/9/5.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>

/**
 区域实体(可能是省/市/区)
 */
@interface SPSDKArea : MOBFDataModel

/**
 自身标识
 */
@property (nonatomic, readonly) UInt64 areaId;
/**
 名称
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 父级标识
 */
@property (nonatomic, readonly) UInt64 parentId;

/**
 下级城市列表
 */
@property (nonatomic, strong, readonly) NSArray <SPSDKArea *> *children;


@end
