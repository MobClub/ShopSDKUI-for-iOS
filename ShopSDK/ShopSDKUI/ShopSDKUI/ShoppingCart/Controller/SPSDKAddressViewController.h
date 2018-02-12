//
//  SPSDKAddressViewController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/6.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseViewController.h"

@interface SPSDKAddressViewController : SPSDKBaseViewController

- (instancetype)initWithManage:(BOOL)isManage;

@property (nonatomic, copy) void (^selectAddressHandler) (SPSDKShippingAddress *address);

@end
