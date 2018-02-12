//
//  SPSDKProductImageCell.h
//  ShopSDKUI
//
//  Created by youzu on 2017/10/25.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKProductImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (nonatomic, copy) NSDictionary *dict;

@end
