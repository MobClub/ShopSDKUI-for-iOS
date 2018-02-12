//
//  SPSDKOrderDetailFooterView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/20.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKOrderDetailFooterView.h"

@interface SPSDKOrderDetailFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *freightLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLabel;

@end

@implementation SPSDKOrderDetailFooterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorForHex:0xf7f7f7];
    
    self.totalPriceLabel.textColor = SPSDKMainColor;
    
    self.orderNumLabel.textColor = SPSDKTextColor;
    self.orderDateLabel.textColor = SPSDKTextColor;
}

- (void)setModel:(SPSDKOrder *)model
{
    _model = model;
    
    self.freightLabel.text = [NSString stringWithFormat:@"￥%.2f", model.totalFreight / 100.f];
    self.discountsLabel.text = [NSString stringWithFormat:@"-￥%.2f", model.totalCoupon / 100.f];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.paidMoney / 100.f];
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单编号：%@", @(model.orderId)];
    self.orderDateLabel.text = [NSString stringWithFormat:@"下单日期：%@", [NSDate dateWithTimeStamp:model.createAt]];
}

@end
