//
//  SPSDKConfirmCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/6.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKConfirmCell.h"

@interface SPSDKConfirmCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;


@end

@implementation SPSDKConfirmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (void)setHasTextField:(BOOL)hasTextField
{
    _hasTextField = hasTextField;
    
    if (hasTextField)
    {
        self.detailLabel.hidden = YES;
        self.arrowImageV.hidden = YES;
        self.textField.hidden = NO;
    }
    else
    {
        self.detailLabel.hidden = NO;
        self.arrowImageV.hidden = NO;
        self.textField.hidden = YES;
    }
}

- (void)setHiddenArrow:(BOOL)hiddenArrow
{
    _hiddenArrow = hiddenArrow;
    
    self.textField.hidden = YES;

    if (hiddenArrow)
    {
        self.arrowImageV.hidden = YES;
        self.rightConstraint.constant = 15;
        self.detailLabel.textColor = SPSDKMainColor;
    }
    else
    {
        self.arrowImageV.hidden = NO;
        self.rightConstraint.constant = 30;
        self.detailLabel.textColor = SPSDKTextColor;
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setDetailTitle:(NSString *)detailTitle
{
    _detailTitle = detailTitle;
    
    self.detailLabel.text = detailTitle;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
