//
//  SPSDKPriceRangeCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/26.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKPriceRangeCell.h"

@interface SPSDKPriceRangeCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation SPSDKPriceRangeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.containerView.backgroundColor = SPSDKGrayColor;
    
    self.leftTextField.delegate = self;
    self.rightTextField.delegate = self;
    self.leftTextField.layer.borderColor = SPSDKLineColor.CGColor;
    self.rightTextField.layer.borderColor = SPSDKLineColor.CGColor;
    self.leftTextField.layer.borderWidth = 0.5f;
    self.rightTextField.layer.borderWidth = 0.5f;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.textFieldHandler)
    {
        self.textFieldHandler(textField.text, self.leftTextField == textField);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
