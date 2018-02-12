//
//  SPSDKOrderDetailHeaderView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKOrderDetailHeaderView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgTopConstraint;
@property (nonatomic, strong) SPSDKOrder *order;

@end
