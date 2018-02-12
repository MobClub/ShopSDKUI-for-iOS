//
//  SPSDKStarView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/12.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKStarView.h"

static NSInteger const SPSDKDefaultStarNumber = 5;

@interface SPSDKStarView ()

@property (nonatomic, strong) UIView *foregroundStarView;
@property (nonatomic, strong) UIView *backgroundStarView;
@property (nonatomic, assign) NSInteger numberOfStars;
@property (nonatomic, assign) BOOL isTap;

@end

@implementation SPSDKStarView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    _numberOfStars = SPSDKDefaultStarNumber;
    _scorePercent = 1;
    _allowTap = YES;
    _allowInteger = NO;
    _padding = 5.f;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configureUI];
}

- (void)configureUI
{
    self.foregroundStarView = [self createStarViewWithImage:@"star_fg"];
    self.backgroundStarView = [self createStarViewWithImage:@"star_bg"];
    
    [self addSubview:self.backgroundStarView];
    [self addSubview:self.foregroundStarView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapRateView:)];
    tapGesture.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapGesture];
}

- (void)userTapRateView:(UITapGestureRecognizer *)gesture
{
    if (_allowTap)
    {
        _isTap = YES;
        CGPoint tapPoint = [gesture locationInView:self];
        CGFloat offset = tapPoint.x;
        CGFloat realStarScore = offset / (self.bounds.size.width / self.numberOfStars);
        CGFloat starScore = self.allowInteger ? realStarScore : ceilf(realStarScore);
        self.scorePercent = starScore / self.numberOfStars;
    }
}

- (UIView *)createStarViewWithImage:(NSString *)imageName
{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    view.backgroundColor = [UIColor clearColor];
    float starWidth = (self.bounds.size.width - (self.numberOfStars - 1) * _padding) / self.numberOfStars;
    for (NSInteger i = 0; i < self.numberOfStars; i++)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * (starWidth + _padding), 0, starWidth, self.bounds.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
    }
    return view;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_isTap)
    {
        [UIView animateWithDuration:0.3 animations:^{
            _isTap = NO;
            self.foregroundStarView.frame = CGRectMake(0, 0, self.bounds.size.width * self.scorePercent, self.bounds.size.height);
        }];
    }
    else
    {
        self.foregroundStarView.frame = CGRectMake(0, 0, self.bounds.size.width * self.scorePercent, self.bounds.size.height);
    }
}

#pragma mark - Get and Set Methods

- (void)setScorePercent:(CGFloat)scroePercent
{
    if (_scorePercent == scroePercent)
    {
        return;
    }
    
    if (scroePercent < 0)
    {
        _scorePercent = 0;
    }
    else if (scroePercent > 1)
    {
        _scorePercent = 1;
    }
    else
    {
        _scorePercent = scroePercent;
    }
    
    if ([self.delegate respondsToSelector:@selector(starView:scorePercent:)])
    {
        [self.delegate starView:self scorePercent:_scorePercent];
    }
    
    [self setNeedsLayout];
}

@end
