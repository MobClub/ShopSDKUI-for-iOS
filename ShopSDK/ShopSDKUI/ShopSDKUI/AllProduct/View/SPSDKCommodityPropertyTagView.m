//
//  AGOCommentTagView.m
//  AppGo
//
//  Created by LeeJay on 2017/4/5.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKCommodityPropertyTagView.h"
#import "UIView+Extension.h"
#import <MOBFoundation/MOBFColor.h>
#import <ShopSDK/SPSDKCommodityProperty.h>
#import <objc/runtime.h>

static float const Margin = 10.f;
static float const LeftPadding = 15.f;
static float const RightPading = 0.f;
static float const TopPadding = 15.f;
static float const BottomPadding = 15.f;

@interface SPSDKCommodityPropertyTagView ()

@property (nonatomic, copy) NSArray *models;

@end

@implementation SPSDKCommodityPropertyTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    self.backgroundColor = [UIColor whiteColor];
}

- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
   
    [label setText:title];
    [label setTextColor:[UIColor grayColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont systemFontOfSize:12]];
    
    [self setLabelBackgroundColor:label];
    label.userInteractionEnabled = YES;
    label.layer.cornerRadius = 4;
    label.clipsToBounds = YES;
    [label sizeToFit];
    label.width += 20;
    label.height += 14;
    return label;
}

- (void)setLabelBackgroundColor:(UILabel *)label
{
    label.backgroundColor = [MOBFColor colorWithRGB:0xF7F7F7];
    label.textColor = [MOBFColor colorWithRGB:0x000000];
}

- (NSMutableArray *)tags
{
    if (!_tags)
    {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

- (CGFloat)calculateHeightWithTags:(NSArray<SPSDKCommodityProperty *> *)tags
{
    _models = tags;
    
    // 清空标签容器的子控件
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 添加标签
    NSMutableArray *tagsM = [NSMutableArray array];
    for (int i = 0; i < tags.count; i++)
    {
        SPSDKCommodityProperty *model = tags[i];
        UILabel *label = [self labelWithTitle:model.propertyValue];
        
        objc_setAssociatedObject(label, "property", model, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [label addGestureRecognizer:tap];
        [self addSubview:label];
        [tagsM addObject:label];
    }
    
    self.tags = tagsM;
    
    // 计算位置
    CGFloat currentX = 0;
    CGFloat currentY = 0;
    CGFloat countRow = 0;
    CGFloat countCol = 0;
    // 调整布局
    for (int i = 0; i < self.subviews.count; i++)
    {
        UILabel *subView = self.subviews[i];
        
//        if (i == 0)
//        {
//            subView.backgroundColor = [MOBFColor colorWithRGB:0x09A9EC];
//            subView.textColor = [UIColor whiteColor];
//        }
        
        subView.tag = i + 10;
        
        // 当字数过多，宽度为contentView的宽度
        if (subView.width > ScreenWidth - 20 - LeftPadding - RightPading) subView.width = ScreenWidth - 20 - LeftPadding - RightPading;
        
        if (currentX + subView.width + Margin * countRow > ScreenWidth - 20 - LeftPadding - RightPading)
        { // 得换行
            subView.left = LeftPadding;
            subView.top = (currentY += subView.height) + Margin * ++countCol + TopPadding;
            currentX = subView.width;
            countRow = 1;
        }
        else
        { // 不换行
//            subView.left = (currentX += subView.width) - subView.width + Margin * countRow + LeftPadding;
            subView.left = (currentX += subView.width) - subView.width + Margin * countRow + 0;
            
            subView.top = currentY + Margin * countCol + TopPadding;
            countRow ++;
        }
    }
    // 设置contentView高度
    self.height = CGRectGetMaxY(self.subviews.lastObject.frame) + BottomPadding;
    
    return self.height;
}


- (void)onTap:(UITapGestureRecognizer *)tap
{
    if (self.didSelectTag)
    {
        NSInteger index = tap.view.tag - 10;
        
        SPSDKCommodityProperty *model = _models[index];
        
        self.didSelectTag(index, model,(UILabel *)tap.view);
    }
}

@end
