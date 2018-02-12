//
//  SPSDKGroupTableView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/11.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKGroupTableView.h"
#import <MOBFoundation/MOBFDevice.h>
#import <objc/message.h>

@implementation SPSDKGroupTableView

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
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGFLOAT_MIN)];
    self.backgroundColor = [UIColor colorForHex:0xf7f7f7];
    
    if (SPSDKiOS11)
    {
        // self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//2
        
        SEL setSEL = NSSelectorFromString(@"setContentInsetAdjustmentBehavior:");
        void (*setContentInsetAdjustmentBehavior)(id, SEL, NSInteger) = (void (*)(id, SEL, NSInteger))objc_msgSend;
        setContentInsetAdjustmentBehavior(self, setSEL, 2);
        
    }
}

@end
