//
//  ShopSDKMacro.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/4.
//  Copyright © 2017年 Mob. All rights reserved.
//

#ifndef ShopSDKMacro_h
#define ShopSDKMacro_h

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

#ifdef DEBUG
#define SPSDKLog( s, ... ) NSLog( @"<%@ --- line: %d> %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define SPSDKLog( s, ... )
#endif

#define SPSDKMainColor [UIColor colorForHex:0xf6573b]
#define SPSDKTextColor [UIColor colorForHex:0x999999]
#define SPSDKGrayColor [UIColor colorForHex:0xf7f7f7]
#define SPSDKLineColor [UIColor colorForHex:0xEBE8E3]

#define SPSDKPageSize 10

#define SPSDKFilterContentWidth (280 / 375.0) * ScreenWidth
#define SPSDKChooseContentHeight (515 / 667.0) * ScreenHeight

#define SPSDKiOS11 [[UIDevice currentDevice].systemVersion floatValue] >= 11.0

#define SPSDKiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define SPSDKRefreshShoppingCartNotif @"RefreshShoppingCartNotif"
#define SPSDKRefreshAddressNotif @"RefreshAddressNotif"
#define SPSDKLoginNotif @"LoginNotif"
#define SPSDKLogoutNotif @"LogoutNotif"

#endif /* ShopSDKMacro_h */
