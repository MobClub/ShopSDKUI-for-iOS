//
//  SPSDKAddAddressViewController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/6.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseViewController.h"

@class SPSDKShippingAddress;

typedef NS_ENUM(NSInteger, SPSDKAddressType) {
    SPSDKAddressTypeEdit = 0,
    SPSDKAddressTypeAdd,
};

@interface SPSDKAddAddressViewController : SPSDKBaseViewController

- (instancetype)initWithType:(SPSDKAddressType)type;

@property (nonatomic, strong) SPSDKShippingAddress *model;

@end
