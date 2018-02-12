//
//  SPSDKCommentPageController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "WMPageController.h"

@interface SPSDKCommentPageController : WMPageController

@property (nonatomic, strong) SPSDKProduct *product;
@property (nonatomic, copy) NSDictionary *countByStars;
@property (nonatomic, assign) NSInteger picCommentCount;
@property (nonatomic, assign) NSInteger commentCounts;

@end
