//
//  SPSDKUIPayConfig.m
//  ShopSDKUI
//
//  Created by 陈剑东 on 2017/12/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKUIPayConfig.h"

@implementation SPSDKUIPayConfig

+ (SPSDKUIPayConfig *)defaultConfig
{
    static SPSDKUIPayConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[SPSDKUIPayConfig alloc] init];
    });
    
    return config;
}

@end
