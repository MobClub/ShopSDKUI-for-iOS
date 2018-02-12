//
//  SPSDKSearchTagView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/22.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseView.h"

@interface SPSDKSearchTagView : SPSDKBaseView

- (CGFloat)calculateHeightWithTitles:(NSArray<NSString *> *)titles;

@property (nonatomic, copy) void (^clickTagHandler) (NSInteger index, NSString *key);

@end
