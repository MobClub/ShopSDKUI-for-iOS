//
//  SPSDKBadgeView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/13.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBadgeView.h"

@interface SPSDKBadgeView ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UIView *badgeView;

@end

@implementation SPSDKBadgeView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self loadNibName:@"SPSDKBadgeView"];
        
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.badgeView.layer.borderColor = SPSDKMainColor.CGColor;
    self.badgeView.layer.borderWidth = 1.0f;
    self.badgeView.layer.cornerRadius = 7.5f;
    self.badgeView.layer.masksToBounds = YES;
    self.badgeLabel.textColor = SPSDKMainColor;
    
    self.badgeView.hidden = YES;
    self.badgeLabel.hidden = YES;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.clickHandler)
    {
        self.clickHandler();
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    _imageV.image = image;
}

- (void)setCount:(NSInteger)count
{
    if (count <= 0)
    {
        _badgeLabel.hidden = YES;
        _badgeView.hidden = YES;
        return;
    }
    
    _count = count;
    
    _badgeLabel.hidden = NO;
    _badgeView.hidden = NO;
    _badgeLabel.text = [NSString stringWithFormat:@"%@",@(count)];
}

@end
