//
//  SPSDKApplyRefundCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/20.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKTableViewCell.h"

@interface SPSDKApplyRefundCell : SPSDKTableViewCell

@property (nonatomic, assign) BOOL hasArrow;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *prefixLabel;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void (^textFieldInputHandler) (NSString *text, NSIndexPath *indexPath);

@end
