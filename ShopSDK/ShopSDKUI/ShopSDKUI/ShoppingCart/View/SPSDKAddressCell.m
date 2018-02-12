//
//  SPSDKAddressCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/5.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKAddressCell.h"

@interface SPSDKAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation SPSDKAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setModel:(SPSDKShippingAddress *)model
{
    _model = model;
    
    self.contactLabel.text = [NSString stringWithFormat:@"收货人：%@  %@", model.realName, model.telephone];
    self.addressLabel.text = model.shippingAddress;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
