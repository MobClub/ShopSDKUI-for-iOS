//
//  SPSDKPriceButton.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/7.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKPriceButton.h"

@implementation SPSDKPriceButton

- (void)setType:(SPSDKPriceType)type
{
    _type = type;
    
    if (type == SPSDKPriceTypeNormal)
    {
        [self setTitleColor:[UIColor colorForHex:0x666666] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"price_normal"] forState:UIControlStateNormal];
    }
    else if (type == SPSDKPriceTypeAsc)
    {
        [self setImage:[UIImage imageNamed:@"price_asc"] forState:UIControlStateNormal];
        [self setTitleColor:SPSDKMainColor forState:UIControlStateNormal];
    }
    else
    {
        [self setImage:[UIImage imageNamed:@"price_desc"] forState:UIControlStateNormal];
        [self setTitleColor:SPSDKMainColor forState:UIControlStateNormal];
    }
}

@end
