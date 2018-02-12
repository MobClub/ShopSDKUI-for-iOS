//
//  SPSDKFilterContentView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/11.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKFilterContentView : UIView

@property (nonatomic, copy) void (^sureHandler)(NSUInteger max,
                                                NSUInteger min,
                                                SPSDKTransportStrategy *stragtegy,
                                                NSArray <SPSDKProductLabel *> *labels);

@property (nonatomic, copy) void (^resetHandler)(void);

@end
