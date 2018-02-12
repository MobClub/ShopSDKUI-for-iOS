//
//  SPSDKImage.h
//  ShopSDK
//
//  Created by 陈剑东 on 2017/11/6.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <MOBFoundation/MOBFDataModel.h>
#import <UIKit/UIKit.h>

/**
 通用图片对象
 */
@interface SPSDKImage : MOBFDataModel

/**
 *  图片源
 */
@property (nonatomic, copy, readonly) NSString *src;

/**
 *  高
 */
@property (nonatomic, readonly)  CGFloat height;

/**
 *  宽
 */
@property (nonatomic, readonly) CGFloat width;


@end
