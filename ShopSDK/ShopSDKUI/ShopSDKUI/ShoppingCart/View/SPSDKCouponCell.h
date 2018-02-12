//
//  SPSDKCouponCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/7.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKCouponCell : UITableViewCell

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) SPSDKCoupon *model;
@property (nonatomic, copy) void (^selectHandler) (NSIndexPath *indexPath);
@property (nonatomic, copy) void (^getHandler) (NSIndexPath *indexPath);
@property (nonatomic, copy) void (^useNowHandler) (NSIndexPath *indexPath);
@property (weak, nonatomic) IBOutlet UIButton *useNowBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceConstraint;

@end
