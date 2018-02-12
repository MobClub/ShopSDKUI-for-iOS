//
//  SPSDKShippingAddress.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/8/30.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>
#import "SPSDKArea.h"

/**
 *  收件地址实体
 */
@interface SPSDKShippingAddress : MOBFDataModel
/**
 *  收货地址ID
 */
@property (nonatomic, readonly) UInt64 shippingAddrId;

/**
 *  省市区+详细地址
 */
@property (nonatomic, copy, readonly) NSString *shippingAddress;

/**
 *  收件人姓名
 */
@property (nonatomic, copy) NSString *realName;

/**
 *  联系电话
 */
@property (nonatomic, copy) NSString *telephone;

/**
 *  是否默认为收货地址
 */
@property (nonatomic) BOOL defaultAddr;

/**
 省
 */
@property (nonatomic, strong) SPSDKArea *province;

/**
 市
 */
@property (nonatomic, strong) SPSDKArea *city;

/**
 区
 */
@property (nonatomic, strong) SPSDKArea *district;

/**
 *  详细地址
 */
@property (nonatomic, copy) NSString *street;


/**
 创建收货地址

 @param realName 收货人名称
 @param telephone 收货人联系方式
 @param province 省
 @param city 市
 @param district 区
 @param street 详细地址
 @param isDef 是否为默认地址
 @return 地址实体
 */
- (instancetype)initWithRealName:(NSString *)realName
                       telephone:(NSString *)telephone
                        province:(SPSDKArea *)province
                            city:(SPSDKArea *)city
                        district:(SPSDKArea *)district
                          street:(NSString *)street
                       isDefault:(BOOL)isDef;

@end
