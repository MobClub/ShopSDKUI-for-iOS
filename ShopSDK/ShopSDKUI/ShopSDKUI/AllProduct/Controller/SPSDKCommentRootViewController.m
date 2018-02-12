//
//  SPSDKCommentRootViewController.m
//  ShopSDKUI
//
//  Created by youzu on 2017/11/24.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKCommentRootViewController.h"
#import "SPSDKCommentPageController.h"

@interface SPSDKCommentRootViewController ()

@property (nonatomic, weak) SPSDKCommentPageController *pageVC;

@end

@implementation SPSDKCommentRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"评论";
    
    SPSDKCommentPageController *commentVC = [[SPSDKCommentPageController alloc] init];
    commentVC.product = _product;
    commentVC.countByStars = _countByStars;
    commentVC.picCommentCount = _picCommentCount;
    commentVC.commentCounts = _commentCounts;
    [self addChildViewController:commentVC];
    commentVC.view.frame = self.view.bounds;
    [self.view addSubview:commentVC.view];
    self.pageVC = commentVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
