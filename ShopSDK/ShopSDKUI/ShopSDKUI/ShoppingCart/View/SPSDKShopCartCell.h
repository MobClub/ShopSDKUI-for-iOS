//
//  SPSDKShopCartCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/5.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKTableViewCell.h"

@protocol SPSDKShopCartCellDelegate <NSObject>

@optional

- (void)cellForChooseIndexPath:(NSIndexPath *)indexPath;
- (void)cellForChangeNum:(NSInteger)num indexPath:(NSIndexPath *)indexPath;
- (void)cellForSelected:(BOOL)selected indexPath:(NSIndexPath *)indexPath;

@end

@interface SPSDKShopCartCell : SPSDKTableViewCell

@property (nonatomic, strong) SPSDKTradingCommodity *model;

@property (nonatomic, weak) id<SPSDKShopCartCellDelegate> delegate;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) BOOL hiddenSelectBtn;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
