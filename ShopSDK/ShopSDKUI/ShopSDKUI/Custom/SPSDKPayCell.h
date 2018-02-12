//
//  SPSDKPayCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/17.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKTableViewCell.h"

@class SPSDKPayModel;

@interface SPSDKPayCell : SPSDKTableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) SPSDKPayModel *model;
@property (nonatomic, copy) void (^didSelectHandler) (NSIndexPath *indexPath);

@end
