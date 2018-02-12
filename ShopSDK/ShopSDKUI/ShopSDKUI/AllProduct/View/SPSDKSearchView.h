//
//  SPSDKSearchView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/7.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKBaseView.h"

@interface SPSDKSearchView : SPSDKBaseView

@property (nonatomic, assign) BOOL needClick;
@property (nonatomic, copy) void (^clickHandler) (void);
@property (nonatomic, copy) void (^searchHandler) (NSString *key);
@property (nonatomic, assign) BOOL hiddenClear;
@property (nonatomic, assign) BOOL textFieldEnable;
@property (nonatomic, copy) NSString *searchKey;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
