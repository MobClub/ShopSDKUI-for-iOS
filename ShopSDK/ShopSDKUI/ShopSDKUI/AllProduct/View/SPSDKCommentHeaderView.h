//
//  SPSDKCommentHeaderView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/12.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKCommentHeaderView : UIView

@property (nonatomic, copy) void (^didSelectHandler) (void);
@property (nonatomic, copy) NSString *praiseRate;
@property (nonatomic, assign) NSInteger commentCounts;
@property (nonatomic, assign) BOOL isImage;
@property (nonatomic, copy) NSString *title;

@end
