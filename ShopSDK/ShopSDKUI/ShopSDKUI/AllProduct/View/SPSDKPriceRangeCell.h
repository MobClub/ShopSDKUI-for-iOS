//
//  SPSDKPriceRangeCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/26.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKPriceRangeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *leftTextField;
@property (weak, nonatomic) IBOutlet UITextField *rightTextField;

@property (nonatomic, copy) void (^textFieldHandler) (NSString *text, BOOL isLeft);

@end
