//
//  SPSDKFilterItemCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/26.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKFilterItemCell.h"
#import <MOBFoundation/MOBFColor.h>
@interface SPSDKFilterItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *selectIcon;

@end

@implementation SPSDKFilterItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.backgroundColor = SPSDKGrayColor;
    self.selectIcon.hidden = YES;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setSelected:(BOOL)selected isMultiple:(BOOL)mul
{
    
    if (selected)
    {
        self.backgroundColor = [MOBFColor colorWithRGB:0xFEEEEB];
        self.titleLabel.textColor = [MOBFColor colorWithRGB:0XF7583C];
    }
    else
    {
        self.backgroundColor = SPSDKGrayColor;
        self.titleLabel.textColor = [UIColor blackColor];
    }
    
    if (mul)
    {
        //多选,标签类型
        if (selected)
        {
            self.selectIcon.hidden = NO;
        }
        else
        {
            self.selectIcon.hidden = YES;
        }
    }
    else
    {
        //单选,策略类型
        self.selectIcon.hidden = YES;
    }
    
}

@end
