//
//  SPSDKChooseContentView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/11.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShopSDK/ShopSDK.h>
@interface SPSDKChooseContentView : UIView

@property (nonatomic, copy) void (^closeHandler) (void);

@property (nonatomic, copy) void (^sureHandler) (SPSDKCommodity *comodity, NSInteger count);

@property (nonatomic, strong) SPSDKProduct *model;

@property (nonatomic) BOOL countViewHidden;

@end
