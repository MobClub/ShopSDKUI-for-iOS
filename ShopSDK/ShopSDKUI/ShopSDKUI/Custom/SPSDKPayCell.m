//
//  SPSDKPayCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/17.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKPayCell.h"
#import "SPSDKPayModel.h"

@interface SPSDKPayCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageV;

@end

@implementation SPSDKPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setLineLeftPadding:15.f rightPadding:15.f];
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap)]];
}

- (void)onTap
{
    if (self.didSelectHandler)
    {
        self.didSelectHandler(_indexPath);
    }
}

- (void)setModel:(SPSDKPayModel *)model
{
    _model = model;
    
    self.selectedImageV.hidden = !model.selected;
    self.titleLabel.text = model.payPlatform;
    self.iconImageV.image = [UIImage imageNamed:model.icon];
}

@end
