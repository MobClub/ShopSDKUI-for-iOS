//
//  SPSDKOrder+SPSDKExtension.h
//  ShopSDKUI
//
//  Created by youzu on 2017/10/30.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <ShopSDK/ShopSDK.h>

@interface SPSDKOrder (SPSDKExtension)

@property (nonatomic, assign) SPSDKOrderStatus orderStatus;
@property (nonatomic, assign) BOOL hasComment;

@end
