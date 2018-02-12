//
//  SPSDKRefundFooterView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/20.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKRefundFooterView.h"

@interface SPSDKRefundFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;

@end

@implementation SPSDKRefundFooterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.detailBtn setTitleColor:SPSDKTextColor forState:UIControlStateNormal];
    self.detailBtn.layer.cornerRadius = 2.f;
    self.detailBtn.layer.masksToBounds = YES;
    self.detailBtn.layer.borderColor = SPSDKTextColor.CGColor;
    self.detailBtn.layer.borderWidth = 1.f;
    
    self.detailBtn.enlargeRadius = 10.f;
}

- (IBAction)onDetailAction:(id)sender
{
    if (self.detailHandler)
    {
        self.detailHandler(_section);
    }
}

- (void)setModel:(SPSDKRefundCommodity *)model
{
    _model = model;
    
    NSString *refundTypeString = model.refundType == SPSDKRefundTypeMoneyOnly ? @"仅退款" : @"退货退款";
    NSString *refundStatusString = [NSString progressStringWithStatus:model.status];
    
    self.detailLabel.text = [NSString stringWithFormat:@"%@，%@", refundTypeString, refundStatusString];
}

@end
