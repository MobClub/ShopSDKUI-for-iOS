//
//  SPSDKChooseContentView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/11.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKChooseContentView.h"
#import "SPSDKFilterContentView.h"
#import "SPSDKCountView.h"
#import "SPSDKCommodityPropertyTagView.h"
#import <objc/runtime.h>
#import <MOBFoundation/MOBFColor.h>

static NSString *const SPSDKChooseProductCellId = @"SPSDKChooseProductCell.h";

@interface SPSDKChooseContentView ()

@property (weak, nonatomic) IBOutlet UIScrollView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIImageView *productImageV;
@property (weak, nonatomic) IBOutlet UIView *underLine;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unSaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *choosePropertyLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (strong, nonatomic) SPSDKCountView *countView;

@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) SPSDKCommodity *sureCommodity;
@property (nonatomic) NSInteger count;
@property (nonatomic, strong) NSMutableDictionary <NSString*, NSArray <UILabel *> *> *pLabels;
@property (nonatomic, strong) NSMutableArray *selectedProperties;

@end

@implementation SPSDKChooseContentView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bottomConstraint.constant = SPSDKiPhoneX ?  -34.f : 0.f;
    
    self.priceLabel.textColor = SPSDKMainColor;
    
    self.productImageV.layer.cornerRadius = 5;
    self.productImageV.layer.masksToBounds = YES;
    self.productImageV.layer.borderColor = [UIColor whiteColor].CGColor;
    self.productImageV.layer.borderWidth = 2.0f;
    
    [self.sureBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateNormal];
    [self.sureBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateHighlighted];
    
    self.closeBtn.enlargeRadius = 10.f;
    
    self.sureBtn.enabled = NO;
    
    __weak typeof(SPSDKChooseContentView) *theView = self;
    
    self.countView = [[SPSDKCountView alloc] init];
    self.countView.resultHandler = ^(NSInteger number){
        theView.count = number;
    };
}

- (void)setModel:(SPSDKProduct *)model
{
    _model = model;
    
    self.keys = model.properties.allKeys;
    [self setupContentView];
    
    [self.productImageV sd_setImageWithURL:[NSURL URLWithString:model.showCommodity.image.src] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", model.showCommodity.currentCost / 100.f];
    
    self.unSaleLabel.text = [NSString stringWithFormat:@"总库存%@件", @(model.showCommodity.usableStock)];
    
    NSString *needChoseProperties = [[model.properties allKeys] componentsJoinedByString:@" "];
    
    self.choosePropertyLabel.text = [NSString stringWithFormat:@"请选择:%@", needChoseProperties];
    
}

- (void)setupContentView
{
    __block CGFloat lastY = 0;
    __weak typeof(SPSDKChooseContentView) *theView = self;

    SPSDKLog(@"%@", self.keys);
    
    [self.keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSString *key = obj;
        NSDictionary <NSString*, NSMutableArray <SPSDKCommodityProperty*> *> *property = [NSDictionary dictionaryWithObject:theView.model.properties[key]
                                                                                                                     forKey:key];

        UIView *cell = [theView _createCellViewWithLastY:lastY
                                                property:property];
        
        [theView.contentView addSubview:cell];
        lastY = CGRectGetMaxY(cell.frame);

    }];
    
    UIView *foot = [self _createFootViewWithLastY:lastY];
    foot.hidden = self.countViewHidden;
    [self.contentView addSubview:foot];
    
    CGFloat iPhoneXAdjHight = 0;
    
    if (SPSDKiPhoneX)
    {
        iPhoneXAdjHight = 34;
    }
    
    self.contentView.frame = CGRectMake(0,
                                        CGRectGetMaxY(self.underLine.frame) + 3,
                                        ScreenWidth,
                                        SPSDKChooseContentHeight - CGRectGetMaxY(self.underLine.frame) - self.sureBtn.frame.size.height - 3 - iPhoneXAdjHight);
    
    self.contentView.contentSize = CGSizeMake(0, lastY + 120);
    
}

- (UIView *)_createCellViewWithLastY:(CGFloat)y property:(NSDictionary <NSString*, NSMutableArray <SPSDKCommodityProperty*> *> *)info
{
    
    NSString *key = info.allKeys.firstObject;
    UIView *cell = [[UIView alloc] init];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 80, 30)];

    label.font = [UIFont systemFontOfSize:14];
    label.text = key;
    [cell addSubview:label];
    
    SPSDKCommodityPropertyTagView *propertiesTagView = [[SPSDKCommodityPropertyTagView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame), ScreenWidth - 30, 0)];
    
    CGFloat tagsHeight = [propertiesTagView calculateHeightWithTags:info[key]];
    CGFloat cellHeight = tagsHeight + 30 + 30;
    
    __weak typeof(SPSDKChooseContentView) *theView = self;
    propertiesTagView.didSelectTag = ^(NSInteger selectedIndex, SPSDKCommodityProperty *p, UILabel *label){
        
        [theView _tagTapHandle:label];
    };
    
    self.pLabels[key] = propertiesTagView.tags;
    [cell addSubview:propertiesTagView];
    
    UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(15, cellHeight - 1, ScreenWidth - 30, 1)];
    underLine.backgroundColor = SPSDKLineColor;
    [cell addSubview:underLine];
    cell.frame = CGRectMake(0, y, ScreenWidth, cellHeight);
    
    return cell;
}

- (UIView *)_createFootViewWithLastY:(CGFloat)y
{
    UIView *foot = [[UIView alloc] initWithFrame:CGRectMake(0, y, ScreenWidth, 120)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 80, 40)];
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"购买数量";
    [foot addSubview:label];
    
    UIView *underLine = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(label.frame) + 19, ScreenWidth - 30, 1)];
    underLine.backgroundColor = SPSDKLineColor;
    [foot addSubview:underLine];
    
    [foot addSubview:self.countView];
    
    self.countView.frame = CGRectMake(ScreenWidth - 114 - 15, CGRectGetMinY(label.frame), 114, 25);
    self.countView.center = CGPointMake(self.countView.center.x, label.center.y);
    
    return foot;
}

- (void)_tagTapHandle:(UILabel *)tag
{
    SPSDKCommodityProperty *p = objc_getAssociatedObject(tag, "property");
    NSString *key = p.propertyKey;
    NSArray  <UILabel *> *labels = self.pLabels[key];
    
    __weak typeof(self) weakSelf = self;
    
    [labels enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        SPSDKCommodityProperty *labelP = objc_getAssociatedObject(obj, "property");
        
        if ([obj isEqual:tag])
        {
            obj.backgroundColor = [MOBFColor colorWithRGB:0XFEEEEB];
            obj.textColor = [MOBFColor colorWithRGB:0XF7583C];
            if (![weakSelf.selectedProperties containsObject:labelP])
            {
                [weakSelf.selectedProperties addObject:labelP];
            }
            else
            {
                obj.backgroundColor = [MOBFColor colorWithRGB:0xF7F7F7];
                obj.textColor = [UIColor blackColor];
                [weakSelf.selectedProperties removeObject:labelP];
            }
        }
        else
        {
            obj.backgroundColor = [MOBFColor colorWithRGB:0xF7F7F7];
            obj.textColor = [UIColor blackColor];
            [weakSelf.selectedProperties removeObject:labelP];
        }

    }];
    
    [self _updateContentView];
    
    
}

- (void)_updateContentView
{
    if (self.selectedProperties.count > 0)
    {
        __weak typeof(self) weakSelf = self;
        [self.pLabels enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray<UILabel *> * _Nonnull labelArray, BOOL * _Nonnull stop) {
            
            NSArray *canChoseProperty =  [ShopSDK filterProperties:weakSelf.selectedProperties propertyKey:key product:weakSelf.model];
            
            [labelArray enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                SPSDKCommodityProperty *labelP = objc_getAssociatedObject(obj, "property");
                
                if ([canChoseProperty containsObject:labelP])
                {
                    obj.userInteractionEnabled = YES;
                    
                    if (CGColorEqualToColor(obj.textColor.CGColor, [UIColor lightGrayColor].CGColor))
                    {
                        obj.textColor = [UIColor blackColor];
                    }
                    
                }
                else
                {
                    obj.userInteractionEnabled = NO;
                    obj.textColor = [UIColor lightGrayColor];
                }
                
            }];
            
        }];
    }
    
    SPSDKCommodity *sure = [ShopSDK commodityWithProperties:self.selectedProperties product:self.model];
    
    if (sure)
    {
        if (sure.usableStock > 0)
        {
            self.sureBtn.enabled = YES;
            [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        }
        else
        {
            self.sureBtn.enabled = NO;
            [self.sureBtn setTitle:@"库存不足" forState:UIControlStateNormal];
        }
        
        self.sureCommodity = sure;
//        self.sureCommodity.count = self.countView.currentNumber;
        self.count = self.countView.currentNumber;
        self.countView.maxValue = sure.usableStock;
        
        [self.productImageV sd_setImageWithURL:[NSURL URLWithString:sure.image.src] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];
        
        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", sure.currentCost / 100.f];
        self.unSaleLabel.text = [NSString stringWithFormat:@"库存%@件", @(sure.usableStock)];
        
//        NSMutableArray *selectedPropertyValues = [NSMutableArray array];
//        [self.selectedProperties enumerateObjectsUsingBlock:^(SPSDKCommodityProperty *p, NSUInteger idx, BOOL * _Nonnull stop) {
//            [selectedPropertyValues addObject:p.propertyValue];
//        }];
        
//        self.choosePropertyLabel.text = [NSString stringWithFormat:@"已选:%@",[selectedPropertyValues componentsJoinedByString:@"+"]];
        
        self.choosePropertyLabel.text = [NSString stringWithFormat:@"已选:%@",sure.propertyDescribe];

        
    }
    else
    {
        self.sureBtn.enabled = NO;
        [self.productImageV sd_setImageWithURL:[NSURL URLWithString:self.model.showCommodity.image.src] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];

        self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", self.model.showCommodity.currentCost / 100.f];
        self.unSaleLabel.text = [NSString stringWithFormat:@"总库存%@件", @(self.model.showCommodity.usableStock)];
        
        NSMutableArray *needChonsendPorpert = [NSMutableArray array];
        NSMutableArray *selectedKeys = [NSMutableArray array];
        
        [self.selectedProperties enumerateObjectsUsingBlock:^(SPSDKCommodityProperty *p, NSUInteger idx, BOOL * _Nonnull stop) {
            [selectedKeys addObject:p.propertyKey];
        }];
        
        [self.model.properties.allKeys enumerateObjectsUsingBlock:^(NSString * _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![selectedKeys containsObject:key])
            {
                [needChonsendPorpert addObject:key];
            }
        }];
        
         self.choosePropertyLabel.text = [NSString stringWithFormat:@"请选择:%@",[needChonsendPorpert componentsJoinedByString:@" "]];
    }
}

- (NSMutableDictionary<NSString *,NSArray<UILabel *> *> *)pLabels
{
    if (!_pLabels)
    {
        _pLabels = [NSMutableDictionary dictionary];
    }
    
    return _pLabels;
}

- (NSMutableArray *)selectedProperties
{
    if (!_selectedProperties)
    {
        _selectedProperties = [NSMutableArray array];
    }
    
    return _selectedProperties;
}

#pragma mark - SPSDKChooseProductCellDelegate


#pragma mark - Action

- (IBAction)_onCloseAction:(id)sender
{
    if (self.closeHandler)
    {
        self.closeHandler();
    }
}

- (IBAction)_onSureAction:(id)sender
{
    if (self.sureHandler)
    {
        self.sureHandler(self.sureCommodity, self.count);
    }
}

@end
