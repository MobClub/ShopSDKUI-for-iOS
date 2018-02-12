//
//  NSDate+SPSDKCommon.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/28.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SPSDKCommon)

/**
 格式化时间字符串 yyyy-MM-dd HH:mm:ss

 @param timeStamp 时间戳
 @return 时间
 */
+ (NSString *)dateWithTimeStamp:(NSInteger)timeStamp;

/**
 格式化时间字符串 yyyy.MM.dd
 
 @param timeStamp 时间戳
 @return 时间
 */
+ (NSString *)dateYMDWithTimeStamp:(NSInteger)timeStamp;

/**
 格式化时间字符串

 @param timeStamp 时间戳
 @param format 格式化
 @return 时间
 */
+ (NSString *)dateWithTimeStamp:(NSInteger)timeStamp format:(NSString *)format;

/**
 获取当前时间戳

 @return 时间戳（毫秒）
 */
+ (long long)currentTimeStamp;

/**
 剩余时间 5天3小时24分钟

 @param finishTimeStamp 结束时间戳
 @return 时间字符串
 */
+ (NSString *)dateWithFinishTimeStamp:(NSInteger)finishTimeStamp;

+ (NSString *)dateWithRemainTimeStamp:(NSInteger)remainTimeStamp;

@end
