//
//  SPSDKCouponCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/7.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKCouponCell.h"
#import "SPSDKCoupon+SPSDKExtension.h"

@interface SPSDKCouponCell ()

@property (weak, nonatomic) IBOutlet UIButton *couponBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;
@property (weak, nonatomic) IBOutlet UILabel *couponTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageV;
@property (weak, nonatomic) IBOutlet UIImageView *bottomDescView;
@property (weak, nonatomic) IBOutlet UILabel *unuseDescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageV;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageV;

@end

@implementation SPSDKCouponCell

- (IBAction)_onSelectAction:(UIButton *)sender
{
    if (self.getHandler)
    {
        self.getHandler(_indexPath);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.useNowBtn setTitleColor:SPSDKMainColor forState:UIControlStateNormal];
    self.useNowBtn.layer.cornerRadius = 14.f;
    self.useNowBtn.layer.masksToBounds = YES;
    self.useNowBtn.layer.borderColor = SPSDKMainColor.CGColor;
    self.useNowBtn.layer.borderWidth = 1.f;
    
    [self.couponBtn setTitle:@"立即领取" forState:UIControlStateNormal];
    [self.couponBtn setTitleColor:SPSDKMainColor forState:UIControlStateNormal];
    
    [self.couponBtn setTitle:@"已领取" forState:UIControlStateDisabled];
    [self.couponBtn setTitleColor:SPSDKTextColor forState:UIControlStateDisabled];
    
    self.couponBtn.enlargeRadius = 10.f;
    
    self.backgroundColor = [UIColor colorForHex:0xf7f7f7];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

- (IBAction)onUseNowAction:(id)sender
{
    if (self.useNowHandler)
    {
        self.useNowHandler(_indexPath);
    }
}

- (void)onTap
{
    if (_type == 0)
    {
        if (!_model.available)
        {
            [MBProgressHUD showTitle:@"此次订单不可用"];
            return;
        }
        
        if (self.selectHandler)
        {
            self.selectHandler(_indexPath);
        }
    }
}

- (void)setType:(NSInteger)type
{
    _type = type;
    
    if (type == 3)
    {
        self.bottomDescView.hidden = NO;
        self.unuseDescLabel.hidden = NO;
        self.leftImageV.image = [UIImage imageNamed:@"hyhq_bg_left"];
        self.rightImageV.image = [UIImage imageNamed:@"hyhq_bg_right"];
        self.selectedImageV.hidden = YES;
        self.couponBtn.hidden = YES;
    }
    else
    {
        self.bottomDescView.hidden = YES;
        self.unuseDescLabel.hidden = YES;
        self.leftImageV.image = [UIImage imageNamed:@"yhq_bg_left"];
        self.rightImageV.image = [UIImage imageNamed:@"yhq_bg_right"];
        
        if (type == 0)
        {// 选择
            self.selectedImageV.hidden = NO;
            self.couponBtn.hidden = YES;
        }
        else if (type == 1)
        {// 个人
            self.selectedImageV.hidden = YES;
            self.couponBtn.hidden = YES;
        }
        else if (type == 2)
        {// 领取
            self.selectedImageV.hidden = YES;
            self.couponBtn.hidden = NO;
        }
    }
}

- (void)setModel:(SPSDKCoupon *)model
{
    _model = model;
    
    if (_type == 0)
    {
        self.selectedImageV.image = model.selected ? [UIImage imageNamed:@"shopcart_selected"] : [UIImage imageNamed:@"shopcart_normal"];
    }
    
    if (_type == 2)
    {
        self.couponBtn.enabled = !model.isGet;
    }
    
    if (model.couponType == SPSDKCouponTypeCash)
    {
        self.priceLabel.attributedText = [self priceStringWithPrice:model.couponMoney];
    }
    else
    {
        self.priceLabel.attributedText = [self discountStringWithDiscount:model.discountRate];
    }
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@-%@", [NSDate dateYMDWithTimeStamp:model.validBeginAt], [NSDate dateYMDWithTimeStamp:model.validEndAt]];
    self.regionLabel.text = model.couponName;
    self.couponTypeLabel.text = model.labelIds.count ? [NSString stringWithFormat:@"指定商品满%zd元", model.lowerLimit / 100] : [NSString stringWithFormat:@"任意商品满%zd元", model.lowerLimit / 100];
    self.unuseDescLabel.text = [NSString stringWithFormat:@"指定商品金额满%.2f元可用，还差%.2f元", model.lowerLimit / 100.f, model.gap / 100.f];
}

- (NSAttributedString *)priceStringWithPrice:(NSInteger)price
{
    NSString *priceStr;
    if (price / 100.f < 1.f)
    {
        priceStr = [NSString stringWithFormat:@"￥%.2f", price / 100.f];
    }
    else
    {
        priceStr = [NSString stringWithFormat:@"￥%.f", price / 100.f];
    }
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attributedStr addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:17] } range:NSMakeRange(0, 1)];
    [attributedStr addAttributes:@{ NSFontAttributeName : [UIFont boldSystemFontOfSize:36] } range:NSMakeRange(1, priceStr.length - 1)];
    return [attributedStr copy];
}

- (NSAttributedString *)discountStringWithDiscount:(double)discount
{
    NSString *discountStr = [NSString stringWithFormat:@"%.1f折", discount];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:discountStr];
    [attributedStr addAttributes:@{  NSFontAttributeName : [UIFont boldSystemFontOfSize:36] } range:NSMakeRange(0, discountStr.length - 1)];
    [attributedStr addAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:17] } range:NSMakeRange(discountStr.length - 1, 1)];
    return [attributedStr copy];
}

@end
