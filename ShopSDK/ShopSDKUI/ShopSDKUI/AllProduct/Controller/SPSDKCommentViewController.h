//
//  SPSDKCommentViewController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseViewController.h"

@interface SPSDKCommentViewController : SPSDKBaseViewController

@property (nonatomic, strong) SPSDKProduct *product;
@property (nonatomic, assign) SPSDKCommentLevel commentLevel;
@property (nonatomic, assign) SPSDKPictureFilter pictureFilter;

@end
