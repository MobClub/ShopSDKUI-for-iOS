//
//  SPSDKShopBarView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/4.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKShopBarView.h"

@interface SPSDKShopBarView ()

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end

@implementation SPSDKShopBarView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self loadNibName:@"SPSDKShopBarView"];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.payBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(130, 45)] forState:UIControlStateNormal];
    [self.payBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(130, 45)] forState:UIControlStateHighlighted];
    self.priceLabel.textColor = SPSDKMainColor;
}

- (IBAction)_onSelectAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (self.selectAllHandler)
    {
        self.selectAllHandler(_isAll);
    }
}

- (IBAction)_onPayAction:(id)sender
{
    if (self.payHandler)
    {
        self.payHandler();
    }
}

- (void)setBtnTitle:(NSString *)btnTitle
{
    _btnTitle = btnTitle;
    
    [self.payBtn setTitle:btnTitle forState:UIControlStateNormal];
}

- (void)setHiddenSelectBtn:(BOOL)hiddenSelectBtn
{
    _hiddenSelectBtn = hiddenSelectBtn;
    
    self.selectBtn.hidden = YES;
}

- (void)setHiddenPrice:(BOOL)hiddenPrice
{
    _hiddenPrice = hiddenPrice;
    
    self.priceLabel.hidden = hiddenPrice;
}

- (void)setPayBtnEnable:(BOOL)payBtnEnable
{
    _payBtnEnable = payBtnEnable;
    
    self.payBtn.enabled = payBtnEnable;
}

- (void)setTotalPrice:(float)totalPrice
{
    if (totalPrice < 0)
    {
        return;
    }
    
    _totalPrice = totalPrice;
    
    self.priceLabel.attributedText = [self priceStringWithTotalPrice:totalPrice];
}

- (NSAttributedString *)priceStringWithTotalPrice:(float)totalPrice
{
    NSString *priceStr = [NSString stringWithFormat:@"合计：￥%.2f", totalPrice];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attributedStr addAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] } range:NSMakeRange(0, 3)];
    [attributedStr addAttributes:@{ NSForegroundColorAttributeName : SPSDKMainColor } range:NSMakeRange(3, priceStr.length - 3)];
    return [attributedStr copy];
}

- (void)setIsAll:(BOOL)isAll
{
    _isAll = isAll;
    
    self.selectBtn.selected = isAll;
}

@end
