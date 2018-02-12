//
//  SPSDKCourierCompanyViewController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/17.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseViewController.h"

@interface SPSDKCourierCompanyViewController : SPSDKBaseViewController

- (instancetype)initWithCompany:(SPSDKTransportCompany *)company;

@property (nonatomic, copy) void (^selectHandler) (SPSDKTransportCompany *company);

@end
