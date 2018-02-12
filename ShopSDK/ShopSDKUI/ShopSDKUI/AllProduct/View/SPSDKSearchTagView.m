//
//  SPSDKSearchTagView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/22.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKSearchTagView.h"
#import "UIView+Extension.h"

static float const SPSDKMargin = 10.f;
static float const SPSDKLeftPadding = 15.f;
static float const SPSDKRightPading = 0.f;
static float const SPSDKTopPadding = 15.f;
static float const SPSDKBottomPadding = 15.f;

@interface SPSDKSearchTagView ()

@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, copy) NSArray<NSString *> *titles;

@end

@implementation SPSDKSearchTagView

- (UILabel *)labelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.backgroundColor = [UIColor colorForHex:0xf7f7f7];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.userInteractionEnabled = YES;
    label.layer.cornerRadius = 15;
    label.clipsToBounds = YES;
    [label sizeToFit];
    label.width += 28;
    label.height = 30;
    return label;
}

- (CGFloat)calculateHeightWithTitles:(NSArray<NSString *> *)titles
{
    _titles = titles;
    
    // 清空标签容器的子控件
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (!titles && !titles.count)
    {
        return 0.f;
    }
    
    // 添加标签
    NSMutableArray *tagsM = [NSMutableArray array];
    for (int i = 0; i < titles.count; i++)
    {
        UILabel *label = [self labelWithTitle:titles[i]];
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

        subView.tag = i + 10;
        
        // 当字数过多，宽度为contentView的宽度
        if (subView.width > ScreenWidth - 20 - SPSDKLeftPadding - SPSDKRightPading)
        {
            subView.width = ScreenWidth - 20 - SPSDKLeftPadding - SPSDKRightPading;
        }
        
        if (currentX + subView.width + SPSDKMargin * countRow > ScreenWidth - 20 - SPSDKLeftPadding - SPSDKRightPading)
        { // 得换行
            subView.left = SPSDKLeftPadding;
            subView.top = (currentY += subView.height) + SPSDKMargin * ++countCol + SPSDKTopPadding;
            currentX = subView.width;
            countRow = 1;
        }
        else
        { // 不换行
            subView.left = (currentX += subView.width) - subView.width + SPSDKMargin * countRow + SPSDKLeftPadding;
            subView.top = currentY + SPSDKMargin * countCol + SPSDKTopPadding;
            countRow ++;
        }
    }
    // 设置contentView高度
    self.height = CGRectGetMaxY(self.subviews.lastObject.frame) + SPSDKBottomPadding;
    
    return self.height;
}

- (void)onTap:(UITapGestureRecognizer *)tap
{
    if (self.clickTagHandler)
    {
        self.clickTagHandler(tap.view.tag - 10, _titles[tap.view.tag - 10]);
    }
}

@end
