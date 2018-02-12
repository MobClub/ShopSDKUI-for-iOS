//
//  SPSDKShopCartCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/5.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKShopCartCell.h"
#import "SPSDKCountView.h"
#import "SPSDKTradingCommodity+SPSDKExtension.h"

@interface SPSDKShopCartCell ()

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCategoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *productNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *prductImageV;
@property (weak, nonatomic) IBOutlet UIView *arrowView;
@property (weak, nonatomic) IBOutlet UILabel *arrowCategoryLabel;
@property (weak, nonatomic) IBOutlet SPSDKCountView *countView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageVLeftLayout;
@property (weak, nonatomic) IBOutlet UILabel *lapseLabel;
@property (weak, nonatomic) IBOutlet UILabel *lapseDescLabel;
@property (nonatomic, assign) BOOL isLapse; // 失效

@end

@implementation SPSDKShopCartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.lapseLabel.backgroundColor = SPSDKTextColor;
    self.lapseLabel.layer.cornerRadius = 8.f;
    self.lapseLabel.layer.masksToBounds = YES;
    
    self.lapseDescLabel.textColor = [UIColor colorForHex:0x858585];
    
    self.selectBtn.enlargeRadius = 8.f;
    
    self.priceLabel.textColor = SPSDKMainColor;
    self.productCategoryLabel.textColor = SPSDKTextColor;
    self.arrowCategoryLabel.textColor = SPSDKTextColor;
    self.productNumLabel.textColor = SPSDKTextColor;
    
    [self.arrowView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_onTap)]];
    
    __weak typeof(self) weakSelf = self;
    self.countView.resultHandler = ^(NSInteger number) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(cellForChangeNum:indexPath:)] )
        {
            [weakSelf.delegate cellForChangeNum:number indexPath:weakSelf.indexPath];
        }
    };
    
    self.countView.outRangeHandler = ^(NSInteger number) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(cellForChangeNum:indexPath:)] )
        {
            [weakSelf.delegate cellForChangeNum:number indexPath:weakSelf.indexPath];
        }
    };
}

#pragma mark - Action

- (void)_onTap
{
    if ([self.delegate respondsToSelector:@selector(cellForChooseIndexPath:)])
    {
        [self.delegate cellForChooseIndexPath:_indexPath];
    }
}

- (IBAction)_onSelectBtn:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cellForSelected:indexPath:)])
    {
        [self.delegate cellForSelected:!_model.selected indexPath:_indexPath];
    }
}

- (void)setHiddenSelectBtn:(BOOL)hiddenSelectBtn
{
    _hiddenSelectBtn = hiddenSelectBtn;
    
    self.selectBtn.hidden = hiddenSelectBtn;
    self.lapseDescLabel.hidden = YES;
    self.lapseLabel.hidden = YES;
    self.arrowView.hidden = YES;
    self.countView.hidden = YES;
    
    if (hiddenSelectBtn)
    {
        self.imageVLeftLayout.constant = 15;
    }
    else
    {
        self.imageVLeftLayout.constant = 38;
    }
}

- (void)setModel:(SPSDKTradingCommodity *)model
{
    _model = model;

    [self.prductImageV sd_setImageWithURL:[NSURL URLWithString:model.commodity.image.src] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.commodity.currentCost / 100.f];
    self.productNumLabel.text = [NSString stringWithFormat:@"x%@", @(model.count)];
    self.productNameLabel.text = model.product.productName;
    self.productCategoryLabel.text = model.commodity.propertyDescribe;
    self.arrowCategoryLabel.text = model.commodity.propertyDescribe;
    self.selectBtn.selected = model.selected;
    if (_isEditing)
    {
        self.countView.currentNumber = model.count;
    }
    self.countView.maxValue = model.commodity.usableStock;
    // 暂时先处理这两种情况
    self.isLapse = model.commodity.status == SPSDKCommodityStatusOffShelf || model.commodity.status == SPSDKCommodityStatusOutOffStock || model.commodity.status == SPSDKCommodityStatusUnavailable;
    if (self.isLapse)
    {
        if (model.commodity.status == SPSDKCommodityStatusOffShelf)
        {
            self.lapseDescLabel.text = @"商品下架";
        }
        else if (model.commodity.status == SPSDKCommodityStatusOutOffStock)
        {
            self.lapseDescLabel.text = @"商品库存不足";
        }
        else if (model.commodity.status == SPSDKCommodityStatusUnavailable)
        {
            self.lapseDescLabel.text = @"商品不可用";
        }
    }

    if (!_hiddenSelectBtn)
    {
        [self configureState];
    }
}

- (void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    
    if (!_hiddenSelectBtn)
    {
        [self configureState];
    }
}

- (void)configureState
{
    if (_isEditing && !_isLapse)
    {
        self.lapseDescLabel.hidden = YES;
        self.productNameLabel.textColor = [UIColor blackColor];
        self.lapseLabel.hidden = YES;
        self.selectBtn.hidden = NO;
        self.productNameLabel.hidden = YES;
        self.productCategoryLabel.hidden = YES;
        self.priceLabel.hidden = YES;
        self.productNumLabel.hidden = YES;
        if ([NSString isNullOrEmpty:_model.commodity.propertyDescribe])
        { // 单一商品隐藏
            self.arrowView.hidden = YES;
        }
        else
        {
            self.arrowView.hidden = NO;
        }
        self.countView.hidden = NO;
    }
    else if (!_isEditing && !_isLapse)
    {
        self.lapseDescLabel.hidden = YES;
        self.productNameLabel.textColor = [UIColor blackColor];
        self.lapseLabel.hidden = YES;
        self.selectBtn.hidden = NO;
        self.productNameLabel.hidden = NO;
        self.productCategoryLabel.hidden = NO;
        self.priceLabel.hidden = NO;
        self.productNumLabel.hidden = NO;
        self.arrowView.hidden = YES;
        self.countView.hidden = YES;
    }
    else
    {
        self.lapseDescLabel.hidden = NO;
        self.productNameLabel.textColor = SPSDKTextColor;
        self.lapseLabel.hidden = NO;
        self.selectBtn.hidden = YES;
        self.productNameLabel.hidden = NO;
        self.productCategoryLabel.hidden = YES;
        self.priceLabel.hidden = YES;
        self.productNumLabel.hidden = YES;
        self.arrowView.hidden = YES;
        self.countView.hidden = YES;
    }
}

@end
