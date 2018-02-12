//
//  SPSDKConfirmCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/6.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKConfirmCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailTitle;
@property (nonatomic, assign) BOOL hiddenArrow;
@property (nonatomic, assign) BOOL hasTextField;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
