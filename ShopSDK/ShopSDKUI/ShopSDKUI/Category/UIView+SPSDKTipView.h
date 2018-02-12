//
//  UIView+SPSDKTipView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/20.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SPSDKTipView)

/**
 配置一个TipView

 @param tipString 提示信息
 @param hasData 是否有数据
 @param noDataImage 没有数据的图片
 */
- (void)configureTipViewWithTipMessage:(NSString *)tipString
                               hasData:(BOOL)hasData
                           noDataImage:(UIImage *)noDataImage;

/**
 配置一个TipView

 @param tipString 提示信息
 @param hasData 是否有数据
 @param noDataImage 没有数据的图片
 @param handler 点击回调
 */
- (void)configureTipViewWithTipMessage:(NSString *)tipString
                               hasData:(BOOL)hasData
                           noDataImage:(UIImage *)noDataImage
                         reloadHandler:(void (^)(id sender))handler;

@end
