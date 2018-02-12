//
//  SPSDKTextView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/6.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKTextView.h"

@interface SPSDKTextView ()

@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation SPSDKTextView

- (void)initialize
{
    self.tintColor = SPSDKMainColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshPlaceholder)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}

- (void)refreshPlaceholder
{
    if (self.text.length)
    {
        [_placeHolderLabel setAlpha:0];
    }
    else
    {
        [_placeHolderLabel setAlpha:1];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self refreshPlaceholder];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    _placeHolderLabel.font = self.font;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_placeHolderLabel sizeToFit];
    _placeHolderLabel.frame = CGRectMake(8, 8, CGRectGetWidth(self.frame) - 16, CGRectGetHeight(_placeHolderLabel.frame));
}

- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    if (_placeHolderLabel == nil)
    {
        _placeHolderLabel = [[UILabel alloc] init];
        _placeHolderLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _placeHolderLabel.numberOfLines = 0;
        _placeHolderLabel.font = self.font;
        _placeHolderLabel.backgroundColor = [UIColor clearColor];
        _placeHolderLabel.textColor = [UIColor lightGrayColor];
        _placeHolderLabel.alpha = 0;
        [self addSubview:_placeHolderLabel];
    }
    
    _placeHolderLabel.text = self.placeholder;
    [self refreshPlaceholder];
}

- (id<UITextViewDelegate>)delegate
{
    [self refreshPlaceholder];
    return [super delegate];
}

@end
