//
//  SPSDKAboutUsViewController.m
//  ShopSDKUI
//
//  Created by youzu on 2017/11/14.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKAboutUsViewController.h"
#import "SPSDKAboutUsHeaderView.h"
#import "SPSDKVersionView.h"

@interface SPSDKAboutUsViewController ()

@property (weak, nonatomic) IBOutlet SPSDKAboutUsHeaderView *headerView;
@property (weak, nonatomic) IBOutlet SPSDKVersionView *versionView;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyDetailLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation SPSDKAboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bottomConstraint.constant = SPSDKiPhoneX ? 42.f : 8.f;
    
    self.companyLabel.textColor = [UIColor colorForHex:0xC2C2C2];
    self.companyDetailLabel.textColor = [UIColor colorForHex:0xC2C2C2];
    
    self.title = @"关于我们";
    
    self.versionView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    self.headerView.clickHandler = ^(BOOL isSelected) {
        weakSelf.versionView.hidden = !isSelected;
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
