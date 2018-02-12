//
//  SPSDKAllProductGridCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/8.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKAllProductGridCell.h"

@interface SPSDKAllProductGridCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesLabel;

@end

@implementation SPSDKAllProductGridCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = [UIColor whiteColor];

    self.priceLabel.textColor = SPSDKMainColor;
    self.salesLabel.textColor = SPSDKTextColor;
}

- (void)setModel:(SPSDKProduct *)model
{
    _model = model;
    
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:model.showCommodity.image.src] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.showCommodity.currentCost / 100.f];
    self.descLabel.text = model.productName;
    self.salesLabel.text = [NSString stringWithFormat:@"%@人付款", @(model.showCommodity.commoditySales)];
}

@end
