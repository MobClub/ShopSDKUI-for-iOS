//
//  SPSDKTableViewCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/21.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKTableViewCell.h"

@interface SPSDKTableViewCell ()

@property (weak, nonatomic) UIView *line;

@end

@implementation SPSDKTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIView *line = [UIView new];
    line.frame = CGRectMake(15, self.frame.size.height - 0.5, ScreenWidth - 15, 0.5);
    line.backgroundColor = SPSDKLineColor;
    [self.contentView addSubview:line];
    self.line = line;
}

- (void)setLineLeftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding
{
    self.line.frame = CGRectMake(leftPadding, self.frame.size.height - 0.5, ScreenWidth - leftPadding - rightPadding, 0.5);
}

- (void)setHiddenLine:(BOOL)hiddenLine
{
    _hiddenLine = hiddenLine;
    
    self.line.hidden = hiddenLine;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
