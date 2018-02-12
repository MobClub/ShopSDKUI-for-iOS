//
//  NSString+SPSDKCommon.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SPSDKCommon)

- (BOOL)isMobilePhoneOrtelePhone;

- (BOOL)isNotBlank;

+ (BOOL)isNullOrEmpty:(NSString *)string;

+ (NSString *)refundStatusStringWithStatus:(SPSDKRefundStatus)status;

+ (NSString *)progressStringWithStatus:(SPSDKRefundStatus)status;

/**
 将中文转换为拼音

 @param aString 中文
 @return 拼音
 */
+ (NSString *)getPinYinString:(NSString *)aString;

/**
 判断字符串是否是纯数字

 @return BOOL
 */
- (BOOL)isNumber;

@end
