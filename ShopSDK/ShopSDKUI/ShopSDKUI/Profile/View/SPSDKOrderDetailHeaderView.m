//
//  SPSDKOrderDetailHeaderView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKOrderDetailHeaderView.h"

@interface SPSDKOrderDetailHeaderView ()

@property (weak, nonatomic) IBOutlet UIImageView *stateImageV;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *remainLabel;

@end

@implementation SPSDKOrderDetailHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setOrder:(SPSDKOrder *)order
{
    _order = order;
    
    switch (_order.status)
    {
        case SPSDKOrderCanceled:
        {
            self.stateImageV.image = [UIImage imageNamed:@"jyqx"];
            self.stateLabel.text = @"已取消";
            self.remainLabel.text = nil;
            break;
        }
        case SPSDKOrderUnpaid:
        {
            self.stateImageV.image = [UIImage imageNamed:@"wait"];
            self.stateLabel.text = @"等待付款";
            self.remainLabel.text = [NSString stringWithFormat:@"剩余：%@ 自动取消订单", [NSDate dateWithRemainTimeStamp:_order.expiration]];
            break;
        }
        case SPSDKOrderUnDelivery:
        {
            self.stateImageV.image = [UIImage imageNamed:@"wait"];
            self.stateLabel.text = @"已付款，等待发货";
            self.remainLabel.text = nil;
            break;
        }
        case SPSDKOrderUnReceive:
        {
            self.stateImageV.image = [UIImage imageNamed:@"jywc"];
            self.stateLabel.text = @"已发货";
            self.remainLabel.text = [NSString stringWithFormat:@"剩余：%@ 自动确认收货", [NSDate dateWithRemainTimeStamp:_order.expiration]];
            break;
        }
        case SPSDKOrderFinished:
        {
            self.stateImageV.image = [UIImage imageNamed:@"jywc"];
            self.stateLabel.text = @"交易完成";
            self.remainLabel.text = nil;
            break;
        }
        default:
            break;
    }
}

@end
