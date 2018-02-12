//
//  SPSDKShopBarView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/4.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseView.h"

@interface SPSDKShopBarView : SPSDKBaseView

@property (nonatomic, copy) void (^payHandler) (void);
@property (nonatomic, copy) void (^selectAllHandler) (BOOL isAll);
@property (nonatomic, assign) BOOL hiddenSelectBtn;
@property (nonatomic, copy) NSString *btnTitle;
@property (nonatomic, assign) BOOL hiddenPrice;
@property (nonatomic, assign) BOOL payBtnEnable;

/**
 总价格
 */
@property (nonatomic, assign) float totalPrice;

@property (nonatomic, assign) BOOL isAll;

@end
