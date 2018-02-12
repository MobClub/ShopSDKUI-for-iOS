//
//  SPSDKAddressInfoCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/6.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKTableViewCell.h"

@interface SPSDKAddressInfoCell : SPSDKTableViewCell

@property (nonatomic, assign) BOOL hiddenArrow;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL hasSwitch;
@property (nonatomic, copy) NSString *placeHolder;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) UIKeyboardType keyboadType;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageV;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;

@end
