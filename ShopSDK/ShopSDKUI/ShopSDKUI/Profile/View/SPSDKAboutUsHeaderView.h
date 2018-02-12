//
//  SPSDKAboutUsHeaderView.h
//  ShopSDKUI
//
//  Created by youzu on 2017/11/14.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseView.h"

@interface SPSDKAboutUsHeaderView : SPSDKBaseView

@property (nonatomic, copy) void (^clickHandler) (BOOL isSelected);

@end
