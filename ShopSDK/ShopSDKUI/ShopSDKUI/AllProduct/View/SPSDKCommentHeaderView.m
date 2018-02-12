//
//  SPSDKCommentHeaderView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/12.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKCommentHeaderView.h"

@interface SPSDKCommentHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodPercentLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;

@end

@implementation SPSDKCommentHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.goodPercentLabel.textColor = SPSDKMainColor;
    self.goodPercentLabel.layer.borderWidth = 1.f;
    self.goodPercentLabel.layer.borderColor = SPSDKMainColor.CGColor;
    self.goodPercentLabel.layer.cornerRadius = 2.f;
    self.goodPercentLabel.layer.masksToBounds = YES;
}

- (void)setIsImage:(BOOL)isImage
{
    _isImage = isImage;
    
    self.goodPercentLabel.hidden = isImage;
    self.moreLabel.hidden = isImage;
}

- (void)setPraiseRate:(NSString *)praiseRate
{
    _praiseRate = praiseRate;
    self.goodPercentLabel.text = [NSString stringWithFormat:@"好评%@", praiseRate];
}

- (void)setCommentCounts:(NSInteger)commentCounts
{
    _commentCounts = commentCounts;
    self.commentLabel.text = [NSString stringWithFormat:@"评价（%@）", @(commentCounts)];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.commentLabel.text = title;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.didSelectHandler)
    {
        self.didSelectHandler();
    }
}

@end
