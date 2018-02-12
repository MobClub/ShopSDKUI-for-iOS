//
//  SPSDKNavigationBar.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/11.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKNavigationBar : UIView

@property (nonatomic, assign) CGFloat backgroundAlpha;
@property (nonatomic, copy) void (^backHandler)(void);

@end
