//
//  SPSDKAddressCell.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/5.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPSDKAddressCell : UITableViewCell

@property (nonatomic, strong) SPSDKShippingAddress *model;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageV;

@end
