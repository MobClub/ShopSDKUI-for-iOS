//
//  SPSDKChooseView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/11.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKChooseView.h"
#import "SPSDKChooseContentView.h"

@interface SPSDKChooseView ()

@property (strong, nonatomic) SPSDKChooseContentView *contentView;

@property (nonatomic) BOOL countViewHidden;

@end

@implementation SPSDKChooseView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        [self configureUI];
    }
    return self;
}

- (instancetype)initWithCountViewHidden:(BOOL)hidden
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.countViewHidden = hidden;
        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    self.contentView = [SPSDKChooseContentView loadInstanceFromNib];
    self.contentView.countViewHidden = self.countViewHidden;
    [self addSubview:self.contentView];
    self.contentView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, SPSDKChooseContentHeight);
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] init]];
    __weak typeof(self) weakSelf = self;
    self.contentView.closeHandler = ^{
        [weakSelf removeSelfFromSupView];
    };
    
    self.contentView.sureHandler = ^(SPSDKCommodity *commodity, NSInteger count){
        
        SPSDKLog(@"选择的商品:%llu,数量:%zd",commodity.commodityId, count);
        
        SPSDKTradingCommodity *tradingCommodity = [[SPSDKTradingCommodity alloc] initWithCommodity:commodity count:count];
        
        if (!weakSelf.isBuyNow)
        {
            if (!weakSelf.countViewHidden)
            {
                [weakSelf addShopCartWithTradingCommodity:tradingCommodity];
                if (weakSelf.sureHandler)
                {
                    weakSelf.sureHandler(commodity, count);
                }
                [weakSelf removeSelfFromSupView];
            }
            else
            {
                if (weakSelf.tradingCommodity.commodity.commodityId != commodity.commodityId)
                {
                    SPSDKTradingCommodity *newTradingCommodity = [[SPSDKTradingCommodity alloc] initWithCommodity:commodity count:weakSelf.tradingCommodity.count];
                    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
                    dispatch_group_t group = dispatch_group_create();
                    dispatch_group_enter(group);
                    __block NSError *addError, *deleteError;
                    [ShopSDK deleteFromShoppingCart:@[weakSelf.tradingCommodity] result:^(NSError *error) {
                        if (error)
                        {
                            [MBProgressHUD showTitle:error.message];
                        }
                        addError = error;
                        dispatch_group_leave(group);
                    }];
                    dispatch_group_enter(group);
                    [ShopSDK addIntoShoppingCartWithCommodity:newTradingCommodity result:^(NSError *error) {
                        if (error)
                        {
                            [MBProgressHUD showTitle:error.message];
                        }
                        deleteError = error;
                        dispatch_group_leave(group);
                    }];
                    
                    dispatch_group_notify(group, queue, ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                            if (weakSelf.refreshHandler)
                            {
                                weakSelf.refreshHandler(addError, deleteError);
                            }
                        });
                    });
                }
                else
                {
                    [weakSelf removeSelfFromSupView];
                }
            }
        }
        else
        {
            if (weakSelf.sureHandler)
            {
                weakSelf.sureHandler(commodity, count);
            }
            [weakSelf removeSelfFromSupView];
        }
    };
}

- (void)addShopCartWithTradingCommodity:(SPSDKTradingCommodity *)tradingCommodity
{
    [ShopSDK addIntoShoppingCartWithCommodity:tradingCommodity result:^(NSError *error) {
        if (!error)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:SPSDKRefreshShoppingCartNotif object:nil];
            [MBProgressHUD showTitle:@"添加成功"];
        }
        else
        {
            [MBProgressHUD showTitle:error.message];
        }
    }];
}

- (void)setModel:(SPSDKProduct *)model
{
    _model = model;
    
    self.contentView.model = model;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeSelfFromSupView];
}

- (void)hiddenAnimation
{
    [self removeSelfFromSupView];
}

- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, ScreenHeight - SPSDKChooseContentHeight, ScreenWidth, SPSDKChooseContentHeight);
    }];
}

- (void)removeSelfFromSupView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, SPSDKChooseContentHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
