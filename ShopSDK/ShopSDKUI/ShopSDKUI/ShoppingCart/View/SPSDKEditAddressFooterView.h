//
//  SPSDKEditAddressFooterView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/21.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKEditAddressFooterView : UIView

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, copy) void (^actionHandler) (NSInteger index, NSInteger section);
@property (nonatomic, assign) BOOL isDefault;

@end
