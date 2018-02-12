//
//  SPSDKAddressInfoCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/6.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKAddressInfoCell.h"

@interface SPSDKAddressInfoCell ()

@end

@implementation SPSDKAddressInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.textField.subviews.firstObject removeFromSuperview];
    [self setLineLeftPadding:0 rightPadding:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHiddenArrow:(BOOL)hiddenArrow
{
    _hiddenArrow = hiddenArrow;
    
    self.arrowImageV.hidden = hiddenArrow;
    self.textField.enabled = hiddenArrow;
    self.switchBtn.hidden = YES;
}

- (void)setHasSwitch:(BOOL)hasSwitch
{
    _hasSwitch = hasSwitch;
    
    if (hasSwitch)
    {
        self.switchBtn.hidden = NO;
        self.textField.hidden = YES;
    }
    else
    {
        self.textField.hidden = NO;
        self.switchBtn.hidden = YES;
    }
}

- (void)setKeyboadType:(UIKeyboardType)keyboadType
{
    _keyboadType = keyboadType;
    
    self.textField.keyboardType = keyboadType;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    
    self.textField.placeholder = placeHolder;
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    self.textField.text = text;
}

- (IBAction)_onSwitchAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

@end
