//
//  SPSDKEditAddressCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/6.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPSDKShippingAddress;

@interface SPSDKEditAddressCell : UITableViewCell

@property (nonatomic, assign) BOOL hiddenLine;
@property (nonatomic, strong) SPSDKShippingAddress *model;
@property (nonatomic, assign) BOOL hiddenDefault;

@end
