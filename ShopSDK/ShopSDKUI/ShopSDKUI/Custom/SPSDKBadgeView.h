//
//  SPSDKBadgeView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/13.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseView.h"

@interface SPSDKBadgeView : SPSDKBaseView

@property (nonatomic, strong) IBInspectable UIImage *image;
@property (nonatomic, assign) IBInspectable NSInteger count;
@property (nonatomic, copy) IBInspectable NSString *title;
@property (nonatomic, copy) void (^clickHandler) (void);

@end
