//
//  SPSDKLoginManager.h
//  ShopSDKUI
//
//  Created by youzu on 2017/11/3.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPSDKLoginManager : NSObject

+ (instancetype)sharedInstance;

- (void)loginAtViewController:(UIViewController *)vc  handler:(void (^) (NSError *error))handler;

@end
