//
//  SPSDKDetailAddressCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/6.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKDetailAddressCell.h"
#import "SPSDKTextView.h"

@interface SPSDKDetailAddressCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *placeholderView;

@end

@implementation SPSDKDetailAddressCell

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.placeholderView.backgroundColor = [UIColor colorForHex:0xf7f7f7];
    
    self.textView.placeholder = @"请填写详细地址";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
