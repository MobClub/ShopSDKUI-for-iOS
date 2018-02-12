//
//  SPSDKBaseView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/5.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKBaseView : UIView

@property (nonatomic, strong) UIView *containerView;

- (void)loadNibName:(NSString *)name;

@end
