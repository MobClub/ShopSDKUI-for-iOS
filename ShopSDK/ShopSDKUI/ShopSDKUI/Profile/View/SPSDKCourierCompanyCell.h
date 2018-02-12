//
//  SPSDKCourierCompanyCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/17.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKTableViewCell.h"

@interface SPSDKCourierCompanyCell : SPSDKTableViewCell

@property (nonatomic, strong) SPSDKTransportCompany *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^didSelectHandler) (NSIndexPath *indexPath);

@end
