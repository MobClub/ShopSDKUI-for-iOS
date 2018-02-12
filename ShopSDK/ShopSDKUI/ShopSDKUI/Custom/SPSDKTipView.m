//
//  SPSDKTipView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/20.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKTipView.h"

@interface SPSDKTipView ()

@property (weak, nonatomic) IBOutlet UIImageView *tipImageV;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *reloadBtn;
@property (nonatomic, copy) void (^reloadButtonBlock)(id sender);

@end

@implementation SPSDKTipView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.reloadBtn setTitleColor:SPSDKMainColor forState:UIControlStateNormal];
    self.reloadBtn.layer.cornerRadius = 2.f;
    self.reloadBtn.layer.masksToBounds = YES;
    self.reloadBtn.layer.borderColor = SPSDKMainColor.CGColor;
    self.reloadBtn.layer.borderWidth = 1.f;
    
    self.tipLabel.textColor = SPSDKTextColor;
}

- (void)tipViewWithTipMsg:(NSString *)tipMsg
                  hasData:(BOOL)hasData
                   hasBtn:(BOOL)hasBtn
              noDataImage:(UIImage *)noDataImage
        reloadButtonBlock:(void (^)(id))block
{
    if (hasData)
    {
        [self removeFromSuperview];
        return;
    }
    
    self.alpha = 1.0;
    
    _tipImageV.image = noDataImage;
    _tipLabel.text = tipMsg;
    _reloadButtonBlock = block;
    _reloadBtn.hidden = !hasBtn;
}

- (IBAction)onReloadAction:(id)sender
{
    self.hidden = YES;
    [self removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_reloadButtonBlock)
        {
            _reloadButtonBlock(sender);
        }
    });
}

@end
