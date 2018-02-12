//
//  SPSDKApplyRefundCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/20.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKApplyRefundCell.h"

@interface SPSDKApplyRefundCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageV;

@end

@implementation SPSDKApplyRefundCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.prefixLabel.textColor = SPSDKMainColor;
    self.textField.delegate = self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.textFieldInputHandler)
    {
        self.textFieldInputHandler(textField.text, _indexPath);
    }
}

- (void)setHasArrow:(BOOL)hasArrow
{
    _hasArrow = hasArrow;
    
    self.arrowImageV.hidden = !hasArrow;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
