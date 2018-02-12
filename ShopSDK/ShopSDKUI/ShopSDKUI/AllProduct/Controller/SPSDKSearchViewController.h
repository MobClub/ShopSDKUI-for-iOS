//
//  SPSDKSearchViewController.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/22.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseViewController.h"

typedef NS_ENUM(NSInteger, SPSDKSearchType) {
    SPSDKSearchTypeProduct = 0,
    SPSDKSearchTypeOrder,
    SPSDKSearchTypeRefund,
};

@interface SPSDKSearchViewController : SPSDKBaseViewController

- (instancetype)initWithSearchType:(SPSDKSearchType)type;

@property (nonatomic, copy) NSString *searchKey;
@property (nonatomic, copy) void (^searchHandler) (NSString *key);
@property (nonatomic, copy) void (^clickTagHandler) (NSInteger index, NSString *key);
@property (nonatomic, copy) void (^cancelHandler) (NSString *key);

@end
