//
//  SPSDKRefundTableModel.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/18.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKRefundTableModel.h"

@implementation SPSDKRefundTableModel

- (instancetype)initWithTitle:(NSString *)title
                  detailTitle:(NSString *)detailTitle
                    imageUrls:(NSArray <SPSDKImage *> *)images
{
    self = [super init];
    if (self)
    {
        _title = title;
        _detailTitle = detailTitle;
        _images = images;
    }
    return self;
}

@end
