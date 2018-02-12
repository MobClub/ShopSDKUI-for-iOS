//
//  SPSDKTableViewCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/21.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKTableViewCell : UITableViewCell

@property (nonatomic, assign) BOOL hiddenLine;

- (void)setLineLeftPadding:(CGFloat)leftPadding rightPadding:(CGFloat)rightPadding;

@end
