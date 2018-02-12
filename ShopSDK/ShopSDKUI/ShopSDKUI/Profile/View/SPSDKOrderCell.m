//
//  SPSDKOrderCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKOrderCell.h"

@interface SPSDKOrderCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPropertyLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *prouctPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation SPSDKOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.productNumLabel.textColor = SPSDKTextColor;
    self.productPropertyLabel.textColor = SPSDKTextColor;
    
    self.containerView.backgroundColor = [UIColor colorForHex:0xfafafa];
}

- (void)setModel:(SPSDKTradingCommodity *)model
{
    _model = model;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.commodity.image.src] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];
    self.prouctPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.commodity.currentCost / 100.f];
    self.productNameLabel.text = model.product.productName;
    self.productNumLabel.text = [NSString stringWithFormat:@"x%@", @(model.count)];
    self.productPropertyLabel.text = model.commodity.propertyDescribe;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
