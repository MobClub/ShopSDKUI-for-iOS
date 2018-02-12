//
//  SPSDKCountView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/5.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseView.h"

@interface SPSDKCountView : SPSDKBaseView

@property (nonatomic, copy) void (^resultHandler) (NSInteger number);

/**
 输入框中的值
 */
@property (nonatomic, assign ) NSInteger currentNumber;

/**
 最小值, default is 1
 */
@property (nonatomic, assign ) IBInspectable NSInteger minValue;

/** 
 最大值 
 */
@property (nonatomic, assign ) NSInteger maxValue;

/**
 超出库存回调
 */
@property (nonatomic, copy) void (^outRangeHandler) (NSInteger number);

@end
