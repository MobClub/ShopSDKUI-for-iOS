//
//  SPSDKRefundFooterView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/20.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKRefundFooterView : UIView

@property (nonatomic, copy) void (^detailHandler) (NSInteger section);
@property (nonatomic, strong) SPSDKRefundCommodity *model;
@property (nonatomic, assign) NSInteger section;

@end
