//
//  SPSDKEditAddressCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/6.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKEditAddressCell.h"

@interface SPSDKEditAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;
@property (weak, nonatomic) IBOutlet UIView *line;

@end

@implementation SPSDKEditAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.defaultLabel.textColor = SPSDKMainColor;
    self.line.backgroundColor = SPSDKLineColor;
}

- (void)setHiddenLine:(BOOL)hiddenLine
{
    _hiddenLine = hiddenLine;
    
    self.line.hidden = hiddenLine;
}

- (void)setModel:(SPSDKShippingAddress *)model
{
    _model = model;
    
    self.nameLabel.text = model.realName;
    self.phoneNumLabel.text = model.telephone;
    self.detailAddressLabel.text = model.shippingAddress;
    
    if (!self.hiddenDefault)
    {
        self.defaultLabel.hidden = !model.defaultAddr;
    }
}

- (void)setHiddenDefault:(BOOL)hiddenDefault
{
    _hiddenDefault = hiddenDefault;
    
    self.defaultLabel.hidden = hiddenDefault;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
