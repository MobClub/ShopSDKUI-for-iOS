//
//  SPSDKRefundPhotoFooterView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/20.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKRefundPhotoFooterView : UIView

@property (nonatomic, strong) NSArray *photos;

@property (nonatomic, copy) void (^addPhotoHandler) (void);
@property (nonatomic, copy) void (^deletePhotoHandler) (NSInteger index);

@end
