//
//  SPSDKPayModel.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/17.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPSDKPayModel : NSObject

@property (nonatomic, copy) NSString *payPlatform;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) SPSDKPayType payType;

@end
