//
//  SPSDKFilterView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/8.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ShopSDK/ShopSDK.h>
@interface SPSDKFilterView : UIView

@property (nonatomic, copy) void (^sureHandler)(NSUInteger max,
                                                NSUInteger min,
                                                SPSDKTransportStrategy *stragtegy,
                                                NSArray <SPSDKProductLabel *> *labels);

@property (nonatomic, copy) void (^resetHandler)(void);

- (void)show;

- (void)removeSelfFromSupView;

@end
