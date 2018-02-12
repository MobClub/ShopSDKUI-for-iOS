//
//  SPSDKOrderStateView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKOrderStateView : UIView

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) SPSDKOrder *model;
@property (nonatomic, copy) void (^actionHandler) (NSInteger section, NSInteger btnIndex, SPSDKOrderStatus status);

@end
