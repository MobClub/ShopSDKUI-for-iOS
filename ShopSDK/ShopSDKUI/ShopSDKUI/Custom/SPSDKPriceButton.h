//
//  SPSDKPriceButton.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/7.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SPSDKPriceType) {
    
    SPSDKPriceTypeNormal = 0, // 正常
    SPSDKPriceTypeAsc,        // 升序
    SPSDKPriceTypeDesc,       // 降序
    
};

@interface SPSDKPriceButton : UIButton

@property (nonatomic, assign) SPSDKPriceType type;

@end
