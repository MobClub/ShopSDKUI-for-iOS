//
//  UITextField+SPSDKCommon.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/8.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "UITextField+SPSDKCommon.h"

@implementation UITextField (SPSDKCommon)

- (void)setPlaceholderTextColor:(UIColor *)textColor font:(UIFont *)font
{
    if (!self.placeholder && self.placeholder.length <= 0)
    {
        return;
    }
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:self.placeholder];
    [placeholder addAttribute:NSForegroundColorAttributeName
                        value:textColor
                        range:NSMakeRange(0, self.placeholder.length)];
    
    [placeholder addAttribute:NSFontAttributeName
                        value:font
                        range:NSMakeRange(0, self.placeholder.length)];
    self.attributedPlaceholder = placeholder;
}

@end
