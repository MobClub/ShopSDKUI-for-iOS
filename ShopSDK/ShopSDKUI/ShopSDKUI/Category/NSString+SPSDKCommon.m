//
//  NSString+SPSDKCommon.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "NSString+SPSDKCommon.h"

@implementation NSString (SPSDKCommon)

- (BOOL)isMobilePhoneOrtelePhone
{
    if (self == nil || self.length == 0)
    {
        return NO;
    }
    
    NSString *MOBILE = @"^((13)|(14)|(15)|(17)|(18))\\d{9}$";
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString *PHS = @"^((0\\d{2,3}-?)\\d{7,8}(-\\d{2,5})?)$";
    NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:self] == YES)
        || ([regextestcm evaluateWithObject:self] == YES)
        || ([regextestct evaluateWithObject:self] == YES)
        || ([regextestcu evaluateWithObject:self] == YES)
        || ([regextestPHS evaluateWithObject:self]==YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (BOOL)isNotBlank
{
    NSCharacterSet *blank = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    for (NSInteger i = 0; i < self.length; ++i)
    {
        unichar c = [self characterAtIndex:i];
        if (![blank characterIsMember:c])
        {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)isNullOrEmpty:(NSString *)string
{
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    string = [NSString stringWithFormat:@"%@", string];
    return string == nil
    || string == (id)[NSNull null]
    || [string isEqualToString:@""]
    || string.length == 0
    || [string isEqualToString:@"(null)"]
    || [string isEqualToString:@"null"]
    || [string isEqualToString:@"<null>"]
    || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0;
}

+ (NSString *)refundStatusStringWithStatus:(SPSDKRefundStatus)status
{
    NSString *refundStatusString = nil;
    switch (status)
    {
        case SPSDKRefundStatusApplying:
            refundStatusString = @"买家申请退款，待商家处理";
            break;
        case SPSDKRefundStatusAgree:
            refundStatusString = @"请买家退回商品并提供运单号";
            break;
        case SPSDKRefundStatusSellerRejected:
            refundStatusString = @"商家拒绝退款";
            break;
        case SPSDKRefundStatusTransporting:
            refundStatusString = @"买家提供退货物流，待商家处理";
            break;
        case SPSDKRefundStatusSuccess:
            refundStatusString = @"退款成功";
            break;
        case SPSDKRefundStatusRefundClosed:
            refundStatusString = @"退款流程关闭";
            break;
        case SPSDKRefundStatusRefunding:
            refundStatusString = @"退款打款中";
            break;
        default:
            break;
    }
    return refundStatusString;
}

+ (NSString *)progressStringWithStatus:(SPSDKRefundStatus)status
{
    // 发起申请、商家同意退货退款、商品寄送中、商家驳回、退款成功、退款流程关闭
    NSString *progressString = nil;
    switch (status)
    {
        case SPSDKRefundStatusApplying:
            progressString = @"发起申请";
            break;
        case SPSDKRefundStatusAgree:
            progressString = @"商家同意退货退款";
            break;
        case SPSDKRefundStatusSellerRejected:
            progressString = @"商家驳回";
            break;
        case SPSDKRefundStatusTransporting:
            progressString = @"商品寄送中";
            break;
        case SPSDKRefundStatusSuccess:
            progressString = @"退款成功";
            break;
        case SPSDKRefundStatusRefundClosed:
            progressString = @"退款流程关闭";
            break;
        case SPSDKRefundStatusRefunding:
            progressString = @"退款打款中";
            break;
        default:
            break;
    }
    return progressString;
}

+ (NSString *)getPinYinString:(NSString *)aString
{
    NSMutableString *mutableString = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    return [self polyphoneStringHandle:aString pinyinString:pinyinString];
}

+ (NSString *)polyphoneStringHandle:(NSString *)aString pinyinString:(NSString *)pinyinString
{
    if ([aString hasPrefix:@"长"]) { return @"chang";}
    if ([aString hasPrefix:@"沈"]) { return @"shen"; }
    if ([aString hasPrefix:@"厦"]) { return @"xia";  }
    if ([aString hasPrefix:@"地"]) { return @"di";   }
    if ([aString hasPrefix:@"重"]) { return @"chong";}
    return pinyinString;
}

- (BOOL)isNumber
{
    NSScanner *scan = [NSScanner scannerWithString:self];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

@end
