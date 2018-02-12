//
//  SPSDKEditAddressFooterView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/21.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKEditAddressFooterView.h"

@interface SPSDKEditAddressFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *defaultBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@end

@implementation SPSDKEditAddressFooterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.defaultBtn setTitleColor:SPSDKTextColor forState:UIControlStateNormal];
    [self.editBtn setTitleColor:SPSDKTextColor forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:SPSDKTextColor forState:UIControlStateNormal];
}

- (IBAction)onDefaultAction:(UIButton *)sender
{
    if (_isDefault)
    {
        return;
    }
    
    if (self.actionHandler)
    {
        self.actionHandler(0, _section);
    }
}

- (IBAction)onEditAction:(id)sender
{
    if (self.actionHandler)
    {
        self.actionHandler(1, _section);
    }
}

- (IBAction)onDeleteAction:(id)sender
{
    if (self.actionHandler)
    {
        self.actionHandler(2, _section);
    }
}

- (void)setIsDefault:(BOOL)isDefault
{
    _isDefault = isDefault;
    
    self.defaultBtn.selected = isDefault;
}

@end
