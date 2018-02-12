//
//  SPSDKOrderDetailCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKOrderDetailCell.h"
#import "SPSDKTradingCommodity+SPSDKExtension.h"

@interface SPSDKOrderDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *productImageV;
@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPropertyLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UILabel *refundPriceLabel;

@end

@implementation SPSDKOrderDetailCell

- (void)setIsLast:(BOOL)isLast
{
    _isLast = isLast;
    
    self.leftConstraint.constant = isLast ? 0 : 15;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.productPriceLabel.textColor = SPSDKMainColor;
    self.productPropertyLabel.textColor = SPSDKTextColor;
    self.productNumLabel.textColor = SPSDKTextColor;
    self.line.backgroundColor = SPSDKLineColor;
    
    self.stateBtn.layer.cornerRadius = 2.f;
    self.stateBtn.layer.masksToBounds = YES;
    self.stateBtn.layer.borderWidth = 1.f;
    self.stateBtn.hidden = YES;
    
    self.refundPriceLabel.textColor = SPSDKMainColor;
    self.refundPriceLabel.userInteractionEnabled = YES;
    self.refundPriceLabel.hidden = YES;
}

- (void)setModel:(SPSDKTradingCommodity *)model
{
    _model = model;
    
    [self.productImageV sd_setImageWithURL:[NSURL URLWithString:model.commodity.image.src] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];
    self.productPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.commodity.currentCost / 100.f];
    self.productNameLabel.text = model.product.productName;
    self.productNumLabel.text = [NSString stringWithFormat:@"x%@", @(model.count)];
    self.productPropertyLabel.text = model.commodity.propertyDescribe;
    
    if (model.commodityStatus == SPSDKCommodityStatusNomal)
    {
        [self.stateBtn setTitleColor:SPSDKTextColor forState:UIControlStateNormal];
        self.stateBtn.layer.borderColor = SPSDKTextColor.CGColor;
        [self.stateBtn setTitle:@"退款" forState:UIControlStateNormal];
    }
    else if (model.commodityStatus == SPSDKCommodityStatusRefunding)
    {
        [self.stateBtn setTitleColor:SPSDKMainColor forState:UIControlStateNormal];
        self.stateBtn.layer.borderColor = SPSDKMainColor.CGColor;
        [self.stateBtn setTitle:@"退款中" forState:UIControlStateNormal];
    }
    else if (model.commodityStatus == SPSDKCommodityStatusRefundFinshined)
    {
        [self.stateBtn setTitleColor:SPSDKMainColor forState:UIControlStateNormal];
        self.stateBtn.layer.borderColor = SPSDKMainColor.CGColor;
        [self.stateBtn setTitle:@"已退款" forState:UIControlStateNormal];
    }
}

- (void)setStatus:(SPSDKOrderStatus)status
{
    _status = status;
    
    if (status == SPSDKOrderCanceled || status == SPSDKOrderUnpaid)
    {
        self.stateBtn.hidden = YES;
    }
    else
    {
        self.stateBtn.hidden = NO;
    }
}

- (void)setRefundModel:(SPSDKRefundCommodity *)refundModel
{
    _refundModel = refundModel;
    
    self.refundPriceLabel.hidden = NO;
    
    [self.productImageV sd_setImageWithURL:[NSURL URLWithString:refundModel.image.src] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];
    self.productPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", refundModel.paidMoney / 100.f];
    self.productNameLabel.text = refundModel.productName;
    self.productNumLabel.text = [NSString stringWithFormat:@"x%@", @(refundModel.orderCommodityCount)];
    self.productPropertyLabel.text = refundModel.propertyDescribe;
    self.refundPriceLabel.text = [NSString stringWithFormat:@"退款￥%.2f", refundModel.refundFee / 100.f];
}

- (IBAction)onStateAction:(id)sender
{
    if (self.refundHandler)
    {
        self.refundHandler(_model, _indexPath);
    }
}

@end
