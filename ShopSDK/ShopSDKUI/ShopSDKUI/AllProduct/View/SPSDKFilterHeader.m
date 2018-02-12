//
//  SPSDKFilterHeader.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/26.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKFilterHeader.h"

@interface SPSDKFilterHeader ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SPSDKFilterHeader

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;
}

@end
