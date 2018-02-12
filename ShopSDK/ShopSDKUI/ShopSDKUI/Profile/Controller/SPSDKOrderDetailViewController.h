//
//  SPSDKOrderDetailViewController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseViewController.h"

@interface SPSDKOrderDetailViewController : SPSDKBaseViewController

- (instancetype)initWithOrder:(SPSDKOrder *)order;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^modifyHandler) (NSInteger section, SPSDKModifyOrderStatus status);
@property (nonatomic, copy) void (^appraiseHandler) (NSInteger section);
@property (nonatomic, copy) void (^payHandler) (NSInteger section);

@end
