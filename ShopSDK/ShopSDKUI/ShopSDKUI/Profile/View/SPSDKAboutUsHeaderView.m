//
//  SPSDKAboutUsHeaderView.m
//  ShopSDKUI
//
//  Created by youzu on 2017/11/14.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKAboutUsHeaderView.h"

@interface SPSDKAboutUsHeaderView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation SPSDKAboutUsHeaderView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadNibName:@"SPSDKAboutUsHeaderView"];
    }
    return self;
}

- (IBAction)onClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (self.clickHandler)
    {
        self.clickHandler(sender.selected);
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.selectBtn.enlargeRadius = 20.f;
    self.line.backgroundColor = [UIColor colorForHex:0xCFCFD1];
    self.titleLabel.textColor = [UIColor colorForHex:0xC2C2C2];
}

@end
