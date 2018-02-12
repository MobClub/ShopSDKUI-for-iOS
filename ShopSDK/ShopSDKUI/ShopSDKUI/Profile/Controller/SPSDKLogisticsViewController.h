//
//  SPSDKLogisticsViewController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseViewController.h"

typedef NS_ENUM(NSInteger, SPSDKLogisticsType) {
    SPSDKLogisticsTypeProduct = 0, // 查看物流
    SPSDKLogisticsTypeRefund       // 售后详情
};

@interface SPSDKLogisticsViewController : SPSDKBaseViewController

- (instancetype)initWithTransport:(SPSDKTransport *)transport type:(SPSDKLogisticsType)type;

@end
