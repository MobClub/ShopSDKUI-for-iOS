//
//  SPSDKCommentPageController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKCommentPageController.h"
#import "SPSDKCommentViewController.h"

static CGFloat const SPSDKItemHeight = 46.f;

@interface SPSDKCommentPageController ()

@end

@implementation SPSDKCommentPageController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    UIView *line = [UIView new];
    line.frame = CGRectMake(0, SPSDKItemHeight - 0.5, ScreenWidth, 0.5);
    line.backgroundColor = SPSDKLineColor;
    [self.view addSubview:line];
}

- (void)initialize
{
    self.scrollEnable = NO;
    self.titleSizeSelected = 14.f;
    self.titleSizeNormal = 14.f;
    self.progressWidth = 80.f;
    self.progressHeight = 3.f;
    self.progressColor = SPSDKMainColor;
    self.titleColorNormal = [UIColor colorForHex:0x666666];
    self.titleColorSelected = SPSDKMainColor;
    self.menuViewContentMargin = 0;
    self.progressViewBottomSpace = 0;
    self.menuItemWidth = ScreenWidth / 5;
    self.menuViewStyle = WMMenuViewStyleLine;
    self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController
{
    return 5;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index
{
    switch (index)
    {
        case 0: return [NSString stringWithFormat:@"全部\n(%@)", @(_commentCounts)];
        case 1: return [NSString stringWithFormat:@"好评\n(%zd)", [self.countByStars[@"5"] integerValue]];
        case 2: return [NSString stringWithFormat:@"中评\n(%zd)", [self.countByStars[@"4"] integerValue] +  [self.countByStars[@"3"] integerValue] + [self.countByStars[@"2"] integerValue]];
        case 3: return [NSString stringWithFormat:@"差评\n(%zd)", [self.countByStars[@"1"] integerValue]];
        case 4: return [NSString stringWithFormat:@"有图\n(%@)", @(_picCommentCount)];
    }
    return @"";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index
{
    SPSDKCommentViewController *commentVC = [[SPSDKCommentViewController alloc] init];
    commentVC.product = _product;
    switch (index) {
        case 0:
        {
            commentVC.commentLevel = SPSDKCommentLevelNone;
            commentVC.pictureFilter = SPSDKPictureFilterNone;
        }
        break;
          
        case 1:
        {
            commentVC.commentLevel = SPSDKCommentLevelPositive;
            commentVC.pictureFilter = SPSDKPictureFilterNone;
        }
            break;
            
        case 2:
        {
            commentVC.commentLevel = SPSDKCommentLevelMedium;
            commentVC.pictureFilter = SPSDKPictureFilterNone;
        }
            break;
            
        case 3:
        {
            commentVC.commentLevel = SPSDKCommentLevelNegative;
            commentVC.pictureFilter = SPSDKPictureFilterNone;
        }
            break;
            
        case 4:
        {
            commentVC.commentLevel = SPSDKCommentLevelNone;
            commentVC.pictureFilter = SPSDKPictureFilterHasPicture;
        }
            break;
        default:
            break;
    }
    return commentVC;
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index
{
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView
{
    return CGRectMake(0, 0, self.view.frame.size.width, SPSDKItemHeight);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView
{
    return CGRectMake(0, SPSDKItemHeight, self.view.frame.size.width, self.view.frame.size.height - SPSDKItemHeight);
}

@end
