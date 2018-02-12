//
//  SPSDKOrderStateView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKOrderStateView.h"
#import "SPSDKOrder+SPSDKExtension.h"

@interface SPSDKOrderStateView ()

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnConstraint;

@end

@implementation SPSDKOrderStateView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.stateLabel.textColor = SPSDKMainColor;
    self.lineLabel.backgroundColor = SPSDKLineColor;
    
    self.btn1.layer.cornerRadius = 2.f;
    self.btn1.layer.masksToBounds = YES;
    self.btn1.layer.borderWidth = 1.f;
    
    self.btn2.layer.cornerRadius = 2.f;
    self.btn2.layer.masksToBounds = YES;
    self.btn2.layer.borderWidth = 1.f;
    
    self.btn3.layer.cornerRadius = 2.f;
    self.btn3.layer.masksToBounds = YES;
    self.btn3.layer.borderWidth = 1.f;
    self.btn3.hidden = YES;
    
}

- (void)setButton:(UIButton *)btn title:(NSString *)title color:(UIColor *)color
{
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.borderColor = color.CGColor;
    [btn setTitleColor:color forState:UIControlStateNormal];
}

- (IBAction)onAction:(UIButton *)sender
{
    if (self.actionHandler)
    {
        self.actionHandler(_section, sender.tag, _model.status);
    }
}

- (void)setModel:(SPSDKOrder *)model
{
    _model = model;
    
    self.numLabel.text = [NSString stringWithFormat:@"共%@件", @(model.totalCount)];
    
    self.priceLabel.attributedText = [self priceStringWithPaidMoney:model.paidMoney totalFreight:model.totalFreight];
    
    switch (model.orderStatus)
    {
        case SPSDKOrderCanceled:
        {
            self.stateLabel.text = @"已取消";
            self.btn3.hidden = YES;
            self.btn2.hidden = YES;
            self.btn1.hidden = NO;
            [self setButton:self.btn1 title:@"删除订单" color:SPSDKTextColor];
            self.btnConstraint.constant = 60.f;
            break;
        }
        case SPSDKOrderUnpaid:
        {
            self.stateLabel.text = @"待付款";
            self.btn3.hidden = YES;
            self.btn2.hidden = NO;
            self.btn1.hidden = NO;
            [self setButton:self.btn1 title:@"付款" color:SPSDKMainColor];
            [self setButton:self.btn2 title:@"取消订单" color:SPSDKTextColor];
            self.btnConstraint.constant = 45.f;
            break;
        }
        case SPSDKOrderUnDelivery:
        {
            self.stateLabel.text =  @"待发货";
            self.btn3.hidden = YES;
            self.btn2.hidden = YES;
            self.btn1.hidden = YES;
            self.btnConstraint.constant = 60.f;
            break;
        }
        case SPSDKOrderUnReceive:
        {
            self.stateLabel.text =  @"已发货";
            self.btn3.hidden = YES;
            self.btn2.hidden = NO;
            self.btn1.hidden = NO;
            [self setButton:self.btn1 title:@"确认收货" color:SPSDKMainColor];
            [self setButton:self.btn2 title:@"查看物流" color:SPSDKTextColor];
            self.btnConstraint.constant = 60.f;
            break;
        }
        case SPSDKOrderFinished:
        {
            self.stateLabel.text =  @"已完成";
            self.btn2.hidden = NO;
            self.btn1.hidden = NO;
            if (model.hasComment)
            {
                self.btn3.hidden = YES;
            }
            else
            {
                self.btn3.hidden = NO;
                [self setButton:self.btn3 title:@"评价" color:SPSDKTextColor];
            }
            [self setButton:self.btn1 title:@"删除订单" color:SPSDKTextColor];
            [self setButton:self.btn2 title:@"查看物流" color:SPSDKTextColor];
            self.btnConstraint.constant = 60.f;
            break;
        }
        default:
            break;
    }
}

- (NSAttributedString *)priceStringWithPaidMoney:(NSInteger)paidMoney totalFreight:(NSInteger)totalFreight
{
    NSString *priceStr = [NSString stringWithFormat:@"实付：￥%.2f(含运费￥%.2f)", paidMoney / 100.f, totalFreight / 100.f];
    NSInteger priceLength = [NSString stringWithFormat:@"￥%.2f", paidMoney / 100.f].length;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attributedStr addAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] } range:NSMakeRange(0, 3)];
    [attributedStr addAttributes:@{ NSForegroundColorAttributeName : SPSDKMainColor } range:NSMakeRange(3, priceLength)];
    [attributedStr addAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] } range:NSMakeRange(priceLength + 3, priceStr.length - priceLength - 3)];
    return [attributedStr copy];
}

@end
