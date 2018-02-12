//
//  SPSDKPaySuccessViewController.m
//  ShopSDKUI
//
//  Created by youzu on 2017/11/17.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKPaySuccessViewController.h"
#import "SPSDKOrderDetailViewController.h"

@interface SPSDKPaySuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *paySuccessLabel;
@property (weak, nonatomic) IBOutlet UIButton *backHomeBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookOrderBtn;
@property (nonatomic, strong) SPSDKOrder *order;
@property (nonatomic, assign) BOOL isOrderDetail;

@end

@implementation SPSDKPaySuccessViewController

- (instancetype)initWithOrder:(SPSDKOrder *)order isOrderDetail:(BOOL)isOrderDetail
{
    self = [super init];
    if (self)
    {
        _order = order;
        _isOrderDetail = isOrderDetail;
    }
    return self;
}

- (IBAction)onBackHomeAction:(id)sender
{
    self.navigationController.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)onLookOrderAction:(id)sender
{
    if (_isOrderDetail)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        SPSDKOrderDetailViewController *orderVC = [[SPSDKOrderDetailViewController alloc] initWithOrder:_order];
        [self.navigationController pushViewController:orderVC animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"支付成功";
    
    self.paySuccessLabel.textColor = SPSDKMainColor;
    
    [self.backHomeBtn setTitleColor:SPSDKMainColor forState:UIControlStateNormal];
    self.backHomeBtn.layer.cornerRadius = 2.f;
    self.backHomeBtn.layer.masksToBounds = YES;
    self.backHomeBtn.layer.borderColor = SPSDKMainColor.CGColor;
    self.backHomeBtn.layer.borderWidth = 1.f;
    
    [self.lookOrderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.lookOrderBtn.layer.cornerRadius = 2.f;
    self.lookOrderBtn.layer.masksToBounds = YES;
    [self.lookOrderBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(130, 35)] forState:UIControlStateNormal];
    [self.lookOrderBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(130, 35)] forState:UIControlStateHighlighted];
}

@end
