//
//  SPSDKConfirmOrderViewController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/5.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseViewController.h"

@interface SPSDKConfirmOrderViewController : SPSDKBaseViewController

- (instancetype)initWithSelectProducts:(NSArray <SPSDKTradingCommodity *> *)selectProducts totalPrice:(float)totalPrice;

@property (nonatomic, copy) void (^payResultHandler) (SPSDKOrder *order, BOOL isSuccess);

@end
