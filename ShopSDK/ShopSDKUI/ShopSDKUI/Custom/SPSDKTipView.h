//
//  SPSDKTipView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/20.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKTipView : UIView

- (void)tipViewWithTipMsg:(NSString *)tipMsg
                  hasData:(BOOL)hasData
                   hasBtn:(BOOL)hasBtn
              noDataImage:(UIImage *)noDataImage
        reloadButtonBlock:(void (^)(id))block;

@end
