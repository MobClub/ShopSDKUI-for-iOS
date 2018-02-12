//
//  AppDelegate.m
//  ShopSDKUIDemo
//
//  Created by 陈剑东 on 2017/11/6.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "AppDelegate.h"
#import "SPSDKTabBarViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <ShopSDK/ShopSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "WXApi.h"

#import <MOBFoundation/MOBFoundation.h>

#import "MBProgressHUD.h"

@interface AppDelegate () <WXApiDelegate>

@property (nonatomic, strong) SPSDKOrder *customPayOrder;

@property (nonatomic) BOOL checkTimeOut;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //ShareSDK 第三方登录所需
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeWechat)]
                             onImport:^(SSDKPlatformType platformType) {

                                 switch (platformType)
                                 {
                                     case SSDKPlatformTypeWechat:
                                         [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                                         break;
                                     default:
                                         break;
                                 }

                             }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {

                          switch (platformType)
                          {
                              case SSDKPlatformTypeWechat:
                                  [appInfo SSDKSetupWeChatByAppId:@"wx6c033dfc1026e3cb"
                                                        appSecret:@"7bdc1d0777b3344f353d9acc54e75713"];
                                  break;
                              default:
                                  break;
                          }

                      }];

    [self addMainWindow];

    return YES;
}


- (void)addMainWindow
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    SPSDKTabBarViewController *tabVC = [[SPSDKTabBarViewController alloc] init];
    [tabVC setPayMode:SPSDKPayModeMobPay];
    
    
    //如果需要使用自有支付(例如自己集成的微信支付等),需添加特定监听
//    [tabVC setPayMode:SPSDKPayModeCustom];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(customPay:)
//                                                 name:SPSDKUINeedCustomPayNotification
//                                               object:nil];
    
    
    self.window.rootViewController = tabVC;

    [self.window makeKeyAndVisible];
}


/**
 自定义支付代码示例演示

 @param notif 订单通知
 */
- (void)customPay:(NSNotification *)notif
{

    SPSDKOrder *order = (SPSDKOrder *)notif.object;
    self.customPayOrder = order;
    NSUInteger totalFee = order.paidMoney;
    
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"好的"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                  
                                                     //如果是免单的直接通知支付成功
                                                     if (order.freeOfCharge)
                                                     {
                                                         [[NSNotificationCenter defaultCenter] postNotificationName:SPSDKUICustomPayResultNotification
                                                                                                             object:@{@"payResult":@(SPSDKClientPayStatusSuccess)}];
                                                     }
                                                     else
                                                     {
                                                         [self startWechatPrePayWithOrder:order result:^(NSDictionary *data, NSError *error) {
                                                             
                                                             if (!error)
                                                             {
                                                                 PayReq *req = [[PayReq alloc] init];
                                                                 
                                                                 req.partnerId = data[@"partnerid"];//商户id
                                                                 req.prepayId = data[@"prepayid"];//预支付id
                                                                 req.nonceStr = data[@"noncestr"];//随机串
                                                                 UInt32 timeStamp = (UInt32)([data[@"timestamp"] integerValue]);
                                                                 req.timeStamp = timeStamp;//时间戳
                                                                 req.package = data[@"package"];//
                                                                 req.sign = data[@"sign"];//签名
                                                                 NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[data objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
                                                                 [WXApi sendReq:req];
                                                                 
                                                             }
                                                             else
                                                             {
                                                                 [[NSNotificationCenter defaultCenter] postNotificationName:SPSDKUICustomPayResultNotification
                                                                                                                     object:@{@"payResult":@(SPSDKClientPayStatusFail)}];
                                                             }
                                
                                                         }];
                                                     }
       
                                                 }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       
                                                       [[NSNotificationCenter defaultCenter] postNotificationName:SPSDKUICustomPayResultNotification
                                                                                                           object:@{@"payResult":@(SPSDKClientPayStatusCancel)}];
                                                   }];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"即将拉起支付"
                                                                   message:[NSString stringWithFormat:@"确认支付:%.2f元", totalFee / 100.f]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:sure];
    [alert addAction:cancel];
    
    UIViewController *rootVc = [UIApplication sharedApplication].keyWindow.rootViewController;
    [rootVc presentViewController:alert animated:YES completion:nil];
    
}

/**
 模拟开发者自有支付系统接口获取微信支付的必要参数

 @param order 订单
 @param result 回调
 */
- (void)startWechatPrePayWithOrder:(SPSDKOrder *)order result:(void (^)(NSDictionary *data, NSError *error))result
{
    NSString *body = [NSString stringWithFormat:@"自行定制商品描述"];
    NSString *outTradeNo = [NSString stringWithFormat:@"%llu",order.orderId];
    NSUInteger totalFee = order.paidMoney;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"body"] = body;
    params[@"outTradeNo"] = outTradeNo;
    params[@"totalFee"] = @(totalFee);
    params[@"spbillCreateIp"] = [MOBFDevice ipAddress:MOBFIPVersion4];
    params[@"tradeType"] = @"APP";
    
    MOBFHttpService *service = [[MOBFHttpService alloc] initWithURLString:@"http://demopay.shop.mob.com/pay/wx/unifiedorder"];
    service.method = kMOBFHttpMethodPost;
    [service addHeaders:@{@"Content-Type":@"application/json"}];
    [service setBody:[MOBFJson jsonDataFromObject:params]];
    [service sendRequestOnResult:^(NSHTTPURLResponse *response, NSData *responseData) {
        
        NSDictionary *res = [MOBFJson objectFromJSONData:responseData];
        
        if ([res[@"success"] boolValue])
        {
            if (result)
            {
                result(res[@"data"], nil);
            }
        }
        else
        {
            if (result)
            {
                result(nil, [NSError errorWithDomain:@"WXPAY" code:100 userInfo:nil]);
            }
        }
        
        
    } onFault:^(NSError *error) {
        
        if (result)
        {
            result(nil, error);
        }
        
    } onUploadProgress:nil];
    
}

- (void)onReq:(BaseReq *)req
{
}

/**
 微信支付的回调

 @param resp 回调结果
 */
- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        if (resp.errCode == 0)
        {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SPSDKUICustomPayResultNotification
                                                                object:@{@"payResult":@(SPSDKClientPayStatusSuccess)}];
            
        }
    }
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [WXApi handleOpenURL:url delegate:self];
}


@end
