//
//  SPSDKVersionView.m
//  ShopSDKUI
//
//  Created by youzu on 2017/11/14.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKVersionView.h"

@interface SPSDKVersionView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation SPSDKVersionView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadNibName:@"SPSDKVersionView"];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.titleLabel.textColor = [UIColor colorForHex:0xC2C2C2];
    self.detailLabel.textColor = [UIColor colorForHex:0xC2C2C2];
}

@end
