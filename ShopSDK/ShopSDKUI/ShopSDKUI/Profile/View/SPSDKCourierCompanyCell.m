//
//  SPSDKCourierCompanyCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/17.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKCourierCompanyCell.h"
#import "SPSDKTransportCompany+SPSDKExtension.h"

@interface SPSDKCourierCompanyCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageV;

@end

@implementation SPSDKCourierCompanyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectedImageV.hidden = YES;
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelect)]];
}

- (void)setModel:(SPSDKTransportCompany *)model
{
    _model = model;
    
    self.selectedImageV.hidden = !model.selected;
    self.titleLabel.text = model.abbreviation;
}

- (void)onSelect
{
    if (self.didSelectHandler)
    {
        self.didSelectHandler(_indexPath);
    }
}

@end
