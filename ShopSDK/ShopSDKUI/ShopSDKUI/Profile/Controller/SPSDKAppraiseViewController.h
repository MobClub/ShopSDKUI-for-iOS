//
//  SPSDKAppraiseViewController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/13.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKAppraiseViewController : UIViewController

- (instancetype)initWithOrder:(SPSDKOrder *)order;

@property (nonatomic, assign) NSInteger indexSection;

@property (nonatomic, copy) void (^appraiseHandler) (NSInteger section);

@end
