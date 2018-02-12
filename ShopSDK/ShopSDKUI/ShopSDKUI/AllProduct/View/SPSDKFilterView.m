//
//  SPSDKFilterView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/8.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKFilterView.h"
#import "SPSDKFilterContentView.h"

@interface SPSDKFilterView ()

@property (strong, nonatomic) SPSDKFilterContentView *contentView;

@end

@implementation SPSDKFilterView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];

        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    self.contentView = [SPSDKFilterContentView loadInstanceFromNib];
    
    __weak typeof(self) weakSelf = self;
    self.contentView.resetHandler = ^{
        if (weakSelf.resetHandler)
        {
            weakSelf.resetHandler();
        }
    };
    
    self.contentView.sureHandler = ^(NSUInteger max, NSUInteger min, SPSDKTransportStrategy *stragtegy, NSArray<SPSDKProductLabel *> *labels) {
        if (weakSelf.sureHandler)
        {
            weakSelf.sureHandler(max, min, stragtegy, labels);
        }
    };
    
    [self addSubview:self.contentView];
    self.contentView.frame = CGRectMake(ScreenWidth, 0, SPSDKFilterContentWidth, ScreenHeight);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeSelfFromSupView];
}

- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(ScreenWidth - SPSDKFilterContentWidth, 0, SPSDKFilterContentWidth, ScreenHeight);
    }];
}

- (void)removeSelfFromSupView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(ScreenWidth, 0, SPSDKFilterContentWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
