//
//  SPSDKTableView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/7.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKTableView.h"
#import <MOBFoundation/MOBFDevice.h>
#import <objc/message.h>

@implementation SPSDKTableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self configure];
    }
    return self;
}

- (void)configure
{
    self.tableFooterView = [UIView new];
    self.backgroundColor = [UIColor colorForHex:0xf7f7f7];
    
    if (SPSDKiOS11)
    {
        // self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//2
        SEL setSEL = NSSelectorFromString(@"setContentInsetAdjustmentBehavior:");
        void (*setContentInsetAdjustmentBehavior)(id, SEL, NSInteger) = (void (*)(id, SEL, NSInteger))objc_msgSend;
        setContentInsetAdjustmentBehavior(self, setSEL, 2);
        
    }
    
}

@end
