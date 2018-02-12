//
//  SPSDKAddPhotoCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/13.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKAddPhotoCell.h"

@implementation SPSDKAddPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.deleteBtn.enlargeRadius = 20.f;
    
    self.imageV.contentMode = UIViewContentModeScaleAspectFill;
    self.imageV.layer.masksToBounds = YES;
}

@end
