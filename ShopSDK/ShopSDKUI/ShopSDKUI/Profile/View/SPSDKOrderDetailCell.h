//
//  SPSDKOrderDetailCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKOrderDetailCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, assign) BOOL isLast;
@property (nonatomic, assign) SPSDKOrderStatus status;
@property (nonatomic, strong) SPSDKTradingCommodity *model;
@property (nonatomic, strong) SPSDKRefundCommodity *refundModel;
@property (nonatomic, copy) void (^refundHandler) (SPSDKTradingCommodity *model, NSIndexPath *index);

@end
