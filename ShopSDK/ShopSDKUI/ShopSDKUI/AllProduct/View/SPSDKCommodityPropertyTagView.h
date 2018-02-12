//
//  AGOCommentTagView.h
//  AppGo
//
//  Created by LeeJay on 2017/4/5.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPSDKCommodityProperty;

@interface SPSDKCommodityPropertyTagView : UIView

@property (nonatomic, strong) NSMutableArray *tags;

@property (nonatomic, copy) void (^didSelectTag) (NSInteger selectedIndex, SPSDKCommodityProperty *p, UILabel *label);

- (CGFloat)calculateHeightWithTags:(NSArray <SPSDKCommodityProperty *> *)tags;

@end
