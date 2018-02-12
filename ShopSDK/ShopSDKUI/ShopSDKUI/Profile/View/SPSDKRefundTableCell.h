//
//  SPSDKRefundTableCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/18.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPSDKRefundTableModel;

@interface SPSDKRefundTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic, assign) BOOL hasPicture;
@property (nonatomic, strong) SPSDKRefundTableModel *model;

@end
