//
//  SPSDKDetailAddressCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/6.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPSDKTextView;

@interface SPSDKDetailAddressCell : UITableViewCell

@property (nonatomic, copy) NSString *title;
@property (weak, nonatomic) IBOutlet SPSDKTextView *textView;

@end
