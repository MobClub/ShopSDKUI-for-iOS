//
//  SPSDKProductCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/11.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKProductCell.h"
#import "SDCycleScrollView.h"

@interface SPSDKProductCell () <SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet SDCycleScrollView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payNumLabel;

@end

@implementation SPSDKProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.payNumLabel.textColor = SPSDKTextColor;
    
    self.bannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    self.bannerView.delegate = self;
    self.bannerView.showPageControl = YES;
    
    self.productPriceLabel.textColor = SPSDKMainColor;
}

- (void)setModel:(SPSDKProduct *)model
{
    _model = model;
    
    NSMutableArray *urls = [NSMutableArray array];
    for (SPSDKImage *image in model.productImages)
    {
        [urls addObject:image.src];
    }
    self.bannerView.imageURLStringsGroup = urls;
    
    self.productNameLabel.text = model.productName;
    self.payNumLabel.text = [NSString stringWithFormat:@"%@人付款", @(model.productSales)];
    
    self.productPriceLabel.attributedText = [self priceStringWithMinPrice:model.minPrice maxPrice:model.maxPrice];
}

- (NSAttributedString *)priceStringWithMinPrice:(NSInteger)minPrice maxPrice:(NSInteger)maxPrice
{
    if (minPrice == maxPrice)
    {
        NSString *minPriceStr = [NSString stringWithFormat:@"%.2f", minPrice / 100.f];
        NSString *priceStr = [NSString stringWithFormat:@"￥%@", minPriceStr];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [attributedStr addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14] } range:NSMakeRange(0, 1)];
        [attributedStr addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:20] } range:NSMakeRange(1, minPriceStr.length)];
        return [attributedStr copy];
    }
    else
    {
        NSString *minPriceStr = [NSString stringWithFormat:@"%.2f", minPrice / 100.f];
        NSString *maxPriceStr = [NSString stringWithFormat:@"%.2f", maxPrice / 100.f];
        NSString *priceStr = [NSString stringWithFormat:@"￥%@ ~ ￥%@", minPriceStr, maxPriceStr];
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [attributedStr addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14] } range:NSMakeRange(0, 1)];
        [attributedStr addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:20] } range:NSMakeRange(1, minPriceStr.length)];
        [attributedStr addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:17] } range:NSMakeRange(minPriceStr.length + 2, 1)];
        [attributedStr addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14] } range:NSMakeRange(minPriceStr.length + 4, 1)];
        [attributedStr addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:20] } range:NSMakeRange(minPriceStr.length + 5, maxPriceStr.length)];
        return [attributedStr copy];
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
