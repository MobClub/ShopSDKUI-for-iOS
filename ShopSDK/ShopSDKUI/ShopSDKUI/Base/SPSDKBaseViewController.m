//
//  SPSDKBaseViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/1.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseViewController.h"

@interface SPSDKBaseViewController ()

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation SPSDKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)createNavigatioItem:(SPSDKNavItemType)type name:(NSString *)name isLeft:(BOOL)isLeft
{
    if (isLeft)
    {
        switch (type)
        {
            case SPSDKNavItemTypeImage:
            {
                self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.leftBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
                [self.leftBtn addTarget:self action:@selector(onLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                break;
            }
                
            case SPSDKNavItemTypeTitle:
            {
                self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.leftBtn setTitle:name forState:UIControlStateNormal];
                [self.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [self.leftBtn addTarget:self action:@selector(onLeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case SPSDKNavItemTypeNone:
                self.leftBtn = nil;
                break;
                
            default:
                break;
        }
        
        [self.leftBtn sizeToFit];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.leftBtn];
    }
    else
    {
        switch (type)
        {
            case SPSDKNavItemTypeImage:
            {
                self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.rightBtn setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
                [self.rightBtn addTarget:self action:@selector(onRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                break;
            }
                
            case SPSDKNavItemTypeTitle:
            {
                self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [self.rightBtn setTitle:name forState:UIControlStateNormal];
                [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [self.rightBtn addTarget:self action:@selector(onRightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            case SPSDKNavItemTypeNone:
                self.rightBtn = nil;
                break;
                
            default:
                break;
        }
        
        [self.rightBtn sizeToFit];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    }
}

- (void)onLeftBtnAction:(UIButton *)sender
{

}

- (void)onRightBtnAction:(UIButton *)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
