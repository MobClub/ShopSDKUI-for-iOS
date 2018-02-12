//
//  SPSDKAppraiseCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/26.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPSDKAppraiseModel;

@interface SPSDKAppraiseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (nonatomic, assign) NSInteger section;

@property (nonatomic, strong) SPSDKAppraiseModel *model;

@property (nonatomic, copy) void (^addPhotoHandler) (NSInteger section);
@property (nonatomic, copy) void (^deletePhotoHandler) (NSInteger index, NSInteger section);
@property (nonatomic, copy) void (^selectStarHandler) (NSInteger star, NSInteger section);
@property (nonatomic, copy) void (^anonymousHandler) (BOOL anonymous, NSInteger section);
@property (nonatomic, copy) void (^textViewHandler) (NSString *text, NSInteger section);

@end
