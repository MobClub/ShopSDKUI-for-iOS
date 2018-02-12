//
//  SPSDKNavigationBar.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/11.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKNavigationBar.h"

@interface SPSDKNavigationBar ()

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end

@implementation SPSDKNavigationBar

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setBackgroundAlpha:(CGFloat)backgroundAlpha
{
    _backgroundAlpha = backgroundAlpha;
    if (_backgroundView)
    {
        _backgroundView.alpha = backgroundAlpha;
    }
}

- (IBAction)_onBackAction:(id)sender
{
    if (_backHandler)
    {
        _backHandler();
    }
    else
    {
        UIViewController *VC = [self viewController];
        if (VC && VC.navigationController)
        {
            [VC.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (UIViewController *)viewController
{
    for (UIView *next = [self superview]; next; next =
         next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

@end
