//
//  SPSDKTabBarViewController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/1.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShopSDK/SPSDKTypeDefine.h>

extern NSString *const SPSDKUINeedCustomPayNotification;
extern NSString *const SPSDKUICustomPayResultNotification;

@interface SPSDKTabBarViewController : UITabBarController

/**
 设定集成的支付模块,默认为使用MobPay
 
 @param payMode 支付模块选择
 */
- (void)setPayMode:(SPSDKPayMode)mode;

/**
 设定支持的支付平台(当payMode仅为SPSDKPayModeMobPay时才生效)

 @param types   支付平台选择。 请传入NSNumber数组，例如 @[@(SPSDKPayTypeAlipay),@(SPSDKPayTypeAlipay)];
 */
- (void)setPayTypes:(NSArray *)types;

@end
