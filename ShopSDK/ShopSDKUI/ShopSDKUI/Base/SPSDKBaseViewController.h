//
//  SPSDKBaseViewController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/1.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SPSDKNavItemType) {
    SPSDKNavItemTypeImage,               // 前景图片button
    SPSDKNavItemTypeTitle,               // 标题button
    SPSDKNavItemTypeNone,                // 空白
};

@interface SPSDKBaseViewController : UIViewController

@property (nonatomic, strong, readonly) UIButton *leftBtn;
@property (nonatomic, strong, readonly) UIButton *rightBtn;

/**
 *  创建导航按钮
 *
 *  @param type 按钮类型
 *  @param name 标题或图片名
 *  @param isLeft 左边还是右边
 */
- (void)createNavigatioItem:(SPSDKNavItemType)type
                       name:(NSString *)name
                     isLeft:(BOOL)isLeft;

/**
 *  右边导航按钮点击事件
 */
- (void)onRightBtnAction:(UIButton *)sender;

/**
 *  左边导航按钮点击事件
 */
- (void)onLeftBtnAction:(UIButton *)sender;

@end
