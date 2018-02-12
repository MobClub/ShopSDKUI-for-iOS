//
//  SPSDKSearchHeader.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/22.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKSearchHeader.h"

@interface SPSDKSearchHeader ()

@property (weak, nonatomic) IBOutlet UILabel *historyLabel;

@end

@implementation SPSDKSearchHeader

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.historyLabel.textColor = SPSDKTextColor;
}

- (IBAction)onDeleteAction:(id)sender
{
    if (self.deleteHandler)
    {
        self.deleteHandler();
    }
}

@end
