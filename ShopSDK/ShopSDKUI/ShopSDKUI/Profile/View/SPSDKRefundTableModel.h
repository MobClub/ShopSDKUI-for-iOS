//
//  SPSDKRefundTableModel.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/18.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPSDKRefundTableModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detailTitle;
@property (nonatomic, copy) NSArray <SPSDKImage *> *images;

- (instancetype)initWithTitle:(NSString *)title
                  detailTitle:(NSString *)detailTitle
                    imageUrls:(NSArray <SPSDKImage *> *)imageUrls;
@end
