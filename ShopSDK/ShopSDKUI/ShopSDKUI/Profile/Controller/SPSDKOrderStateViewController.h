//
//  SPSDKOrderStateViewController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseViewController.h"

@interface SPSDKOrderStateViewController : SPSDKBaseViewController

- (instancetype)initWithState:(SPSDKOrderStatus)state keyword:(NSString *)keyword;

@property (nonatomic, assign) BOOL isSearch;

- (void)beginRefreshing;

@end
