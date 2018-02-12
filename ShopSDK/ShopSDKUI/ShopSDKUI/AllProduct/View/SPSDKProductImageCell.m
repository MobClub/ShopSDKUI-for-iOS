//
//  SPSDKProductImageCell.m
//  ShopSDKUI
//
//  Created by youzu on 2017/10/25.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKProductImageCell.h"

@implementation SPSDKProductImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    
    NSDictionary *imageUrl =  dict[@"imgUrl"];
    NSString *url = nil;
    if ([imageUrl isKindOfClass:[NSDictionary class]])
    {
        url = imageUrl[@"src"];
    }
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];
}

@end
