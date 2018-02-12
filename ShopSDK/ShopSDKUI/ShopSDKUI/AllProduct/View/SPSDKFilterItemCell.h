//
//  SPSDKFilterItemCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/26.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKFilterItemCell : UICollectionViewCell

@property (nonatomic, copy) NSString *title;

- (void)setSelected:(BOOL)selected isMultiple:(BOOL)mul;


@end
