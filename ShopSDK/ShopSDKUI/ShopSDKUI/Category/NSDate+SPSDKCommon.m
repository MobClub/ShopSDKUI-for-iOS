//
//  NSDate+SPSDKCommon.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/28.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "NSDate+SPSDKCommon.h"

@implementation NSDate (SPSDKCommon)

+ (NSString *)dateWithTimeStamp:(NSInteger)timeStamp
{
    return [self dateWithTimeStamp:timeStamp format:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSString *)dateYMDWithTimeStamp:(NSInteger)timeStamp
{
    return [self dateWithTimeStamp:timeStamp format:@"yyyy.MM.dd"];
}

+ (NSString *)dateWithTimeStamp:(NSInteger)timeStamp format:(NSString *)format
{
    NSString *timeStampString = [NSString stringWithFormat:@"%zd", timeStamp];
    NSDate *date = nil;
    if (timeStampString.length == 13)
    {
        date = [NSDate dateWithTimeIntervalSince1970:timeStamp / 1000];
    }
    else
    {
        date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

+ (long long)currentTimeStamp
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
    long long theTime = [[NSNumber numberWithDouble:timeStamp] longLongValue];
    return theTime;
}

+ (NSString *)dateWithFinishTimeStamp:(NSInteger)finishTimeStamp
{
    NSTimeInterval timeInterval = [self currentTimeStamp];
    NSTimeInterval timeout = finishTimeStamp - timeInterval;
    if (timeout <= 0)
    {
        timeout = 0;
    }
    return [self dateWithRemainTimeStamp:timeout / 1000];
}

+ (NSString *)dateWithRemainTimeStamp:(NSInteger)remainTimeStamp
{
    int days = (int)(remainTimeStamp / (3600 * 24));
    int hours = (int)((remainTimeStamp - days * 24 * 3600) / 3600);
    int minutes = (int)(remainTimeStamp - days * 24 * 3600 - hours * 3600) / 60;
    int seconds = (int)(remainTimeStamp - days * 24 * 3600 - hours * 3600 - 60 * minutes);
    if (days)
    {
        return [NSString stringWithFormat:@"%zd天%zd小时%zd分钟", days, hours, minutes];
    }
    else if (!days && hours && minutes)
    {
        return [NSString stringWithFormat:@"%zd小时%zd分钟", hours, minutes];
    }
    else if (!days && !hours && minutes)
    {
        return [NSString stringWithFormat:@"%zd分钟", minutes];
    }
    else if (!days && !hours && !minutes && seconds)
    {
        return [NSString stringWithFormat:@"%zd秒", seconds];
    }
    else
    {
        return @"已结束";
    }
}

@end
