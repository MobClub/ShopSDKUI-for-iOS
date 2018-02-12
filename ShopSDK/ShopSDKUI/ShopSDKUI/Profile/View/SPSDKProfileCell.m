//
//  SPSDKProfileCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/12.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKProfileCell.h"

@interface SPSDKProfileCell ()

@end

@implementation SPSDKProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.detailLabel.textColor = SPSDKTextColor;
    self.line.backgroundColor = SPSDKLineColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
