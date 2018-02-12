//
//  SPSDKRefundDetailCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/18.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKRefundDetailCell : UITableViewCell

@property (nonatomic, strong) SPSDKRefundDesc *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^actionHandler) (NSString *title, SPSDKRefundDesc *refundDesc);

@end
