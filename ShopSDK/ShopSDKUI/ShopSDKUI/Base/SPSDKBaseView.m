//
//  SPSDKBaseView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/5.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseView.h"

@implementation SPSDKBaseView

- (void)loadNibName:(NSString *)name
{
    self.containerView = [[UINib nibWithNibName:name bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    self.containerView.frame = self.bounds;
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.containerView];
}

@end
