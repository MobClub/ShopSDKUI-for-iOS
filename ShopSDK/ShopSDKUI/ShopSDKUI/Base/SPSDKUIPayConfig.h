//
//  SPSDKUIPayConfig.h
//  ShopSDKUI
//
//  Created by 陈剑东 on 2017/12/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPSDKUIPayConfig : NSObject

@property (nonatomic) NSUInteger payMode;

@property (nonatomic, strong) NSArray *payTypes;

+ (SPSDKUIPayConfig *)defaultConfig;

@end
