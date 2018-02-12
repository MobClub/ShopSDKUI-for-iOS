//
//  NSError+SPSDKCommon.m
//  ShopSDKUI
//
//  Created by youzu on 2017/11/15.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "NSError+SPSDKCommon.h"

@implementation NSError (SPSDKCommon)

- (NSString *)message
{
    NSDictionary *userInfo = self.userInfo;
    NSString *msg;
    if ([userInfo isKindOfClass:[NSDictionary class]])
    {
        msg = userInfo[@"message"];
        if (!msg)
        {
            msg = userInfo[@"NSLocalizedDescription"];
        }
    }
    return msg;
}

@end
