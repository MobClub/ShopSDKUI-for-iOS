//
//  UIView+SPSDKTipView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/20.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "UIView+SPSDKTipView.h"
#import "SPSDKTipView.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, strong) SPSDKTipView *tipView;

@end

@implementation UIView (SPSDKTipView)

- (void)setTipView:(SPSDKTipView *)tipView
{
    objc_setAssociatedObject(self,
                             @selector(tipView),
                             tipView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SPSDKTipView *)tipView
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)configureTipViewWithTipMessage:(NSString *)tipString
                               hasData:(BOOL)hasData
                           noDataImage:(UIImage *)noDataImage
{
    [self configureTipViewWithTipMessage:tipString
                                 hasData:hasData
                                  hasBtn:NO
                             noDataImage:noDataImage
                           containerView:nil
                       reloadButtonBlock:nil];
}

- (void)configureTipViewWithTipMessage:(NSString *)tipString
                               hasData:(BOOL)hasData
                           noDataImage:(UIImage *)noDataImage
                         reloadHandler:(void (^)(id))handler
{
    [self configureTipViewWithTipMessage:tipString
                                 hasData:hasData
                                  hasBtn:YES
                             noDataImage:noDataImage
                           containerView:nil
                       reloadButtonBlock:handler];
}

- (void)configureTipViewWithTipMessage:(NSString *)tipString
                               hasData:(BOOL)hasData
                                hasBtn:(BOOL)hasBtn
                           noDataImage:(UIImage *)noDataImage
                         containerView:(UIView *)containerView
                     reloadButtonBlock:(void (^)(id))block
{
    if (hasData)
    {
        if (self.tipView)
        {
            self.tipView.hidden = YES;
            [self.tipView removeFromSuperview];
        }
    }
    else
    {
        if (!self.tipView)
        {
            self.tipView = [SPSDKTipView loadInstanceFromNib];
        }
        self.tipView.hidden = NO;
        
        if (!containerView)
        {
            self.tipView.frame = CGRectMake(0, 0, self.tipViewContainer.width, self.tipViewContainer.height);
            [self.tipViewContainer addSubview:self.tipView];
        }
        else
        {
            self.tipView.frame = containerView.bounds;
            [containerView addSubview:self.tipView];
        }
        
        [self.tipView tipViewWithTipMsg:tipString
                                hasData:hasData
                                 hasBtn:hasBtn
                            noDataImage:noDataImage
                      reloadButtonBlock:block];
    }
}

- (UIView *)tipViewContainer
{
    UIView *tipViewContainer = self;
    for (UIView *aView in [self subviews])
    {
        if ([aView isKindOfClass:[UIScrollView class]])
        {
            tipViewContainer = aView;
        }
    }
    return tipViewContainer;
}

@end
