//
//  SPSDKProfileHeaderView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/12.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKProfileHeaderView : UIView

@property (nonatomic, copy) void (^actionHandler) (NSInteger index);
@property (nonatomic, strong) NSArray <SPSDKStatisticInfo *> *countList;
@property (nonatomic, copy) void (^tapHandler) (void);
@property (nonatomic, copy) NSString *name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgTopConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;

@end
