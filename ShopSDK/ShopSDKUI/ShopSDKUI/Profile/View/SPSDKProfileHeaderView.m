//
//  SPSDKProfileHeaderView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/12.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKProfileHeaderView.h"
#import "SPSDKBadgeView.h"

@interface SPSDKProfileHeaderView ()

@property (weak, nonatomic) IBOutlet SPSDKBadgeView *view1;
@property (weak, nonatomic) IBOutlet SPSDKBadgeView *view2;
@property (weak, nonatomic) IBOutlet SPSDKBadgeView *view3;
@property (weak, nonatomic) IBOutlet SPSDKBadgeView *view4;
@property (weak, nonatomic) IBOutlet SPSDKBadgeView *view5;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UIView *nameContentView;

@end

@implementation SPSDKProfileHeaderView

- (void)setName:(NSString *)name
{
    _name = name;
    
    self.nameLabel.text = name;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorForHex:0xf7f7f7];
    self.imageV.image = [UIImage imageNamed:@"profile_bg"];
    
    self.iconImageV.layer.cornerRadius = 67.0 / 2;
    self.iconImageV.layer.masksToBounds = YES;
    self.iconImageV.userInteractionEnabled = YES;
    [self.iconImageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImageV)]];
    [self.nameContentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapImageV)]];
    
    __weak typeof(self) weakSelf = self;
    
    self.view1.clickHandler = ^{
        if (weakSelf.actionHandler)
        {
            weakSelf.actionHandler(0);
        }
    };
    
    self.view2.clickHandler = ^{
        if (weakSelf.actionHandler)
        {
            weakSelf.actionHandler(1);
        }
    };
    
    self.view3.clickHandler = ^{
        if (weakSelf.actionHandler)
        {
            weakSelf.actionHandler(2);
        }
    };
    
    self.view4.clickHandler = ^{
        if (weakSelf.actionHandler)
        {
            weakSelf.actionHandler(3);
        }
    };
    
    self.view5.clickHandler = ^{
        if (weakSelf.actionHandler)
        {
            weakSelf.actionHandler(4);
        }
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadge) name:SPSDKLogoutNotif object:nil];
}

- (void)updateBadge
{
    self.view1.count = 0;
    self.view2.count = 0;
    self.view3.count = 0;
}

- (void)onTapImageV
{
    if (self.tapHandler)
    {
        self.tapHandler();
    }
}

- (void)setCountList:(NSArray<SPSDKStatisticInfo *> *)countList
{
    _countList = countList;
    
    self.view1.count = 0;
    self.view2.count = 0;
    self.view3.count = 0;
    
    for (SPSDKStatisticInfo *info in countList)
    {
        switch (info.status)
        {
            case SPSDKOrderUnpaid:
            {
                self.view1.count = info.count;
            }
                break;
                
            case SPSDKOrderUnDelivery:
            {
                self.view2.count = info.count;
            }
                break;
            
            case SPSDKOrderUnReceive:
            {
                self.view3.count = info.count;
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
