//
//  SPSDKCommentRootViewController.h
//  ShopSDKUI
//
//  Created by youzu on 2017/11/24.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseViewController.h"

@interface SPSDKCommentRootViewController : SPSDKBaseViewController

@property (nonatomic, strong) SPSDKProduct *product;
@property (nonatomic, copy) NSDictionary *countByStars;
@property (nonatomic, assign) NSInteger picCommentCount;
@property (nonatomic, assign) NSInteger commentCounts;

@end
