//
//  SPSDKLogisticsCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKLogisticsCell : UITableViewCell

@property (nonatomic, assign) BOOL hiddenLine;
@property (nonatomic, strong) SPSDKTransportDesc *model;

@end
