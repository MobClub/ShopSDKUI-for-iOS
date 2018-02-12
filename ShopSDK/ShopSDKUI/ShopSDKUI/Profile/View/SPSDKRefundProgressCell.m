//
//  SPSDKRefundProgressCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/27.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKRefundProgressCell.h"

@implementation SPSDKRefundProgressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.progressLabel.textColor = SPSDKMainColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
