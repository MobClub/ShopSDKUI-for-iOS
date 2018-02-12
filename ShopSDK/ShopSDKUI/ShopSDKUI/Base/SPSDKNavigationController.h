//
//  SPSDKNavigationController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/4.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKNavigationController : UINavigationController

/**
 是否开启侧滑返回 default YES
 */
@property (nonatomic, assign) BOOL enablePopGesture;

/**
 状态栏的颜色
 */
@property (nonatomic, assign) BOOL isWhite;

@end
