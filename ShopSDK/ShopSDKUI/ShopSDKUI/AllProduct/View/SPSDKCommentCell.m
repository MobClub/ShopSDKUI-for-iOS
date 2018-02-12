//
//  SPSDKCommentCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/12.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKCommentCell.h"
#import "SPSDKStarView.h"

@interface SPSDKCommentCell ()

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet SPSDKStarView *starView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageV1;
@property (weak, nonatomic) IBOutlet UIImageView *imageV2;
@property (weak, nonatomic) IBOutlet UIImageView *imageV3;
@property (weak, nonatomic) IBOutlet UIImageView *imageV4;
@property (weak, nonatomic) IBOutlet UILabel *line;

@end

@implementation SPSDKCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.line.backgroundColor = SPSDKLineColor;
    self.typeLabel.textColor = SPSDKTextColor;
    
    self.imageV1.clipsToBounds = YES;
    self.imageV2.clipsToBounds = YES;
    self.imageV3.clipsToBounds = YES;
    self.imageV4.clipsToBounds = YES;
}

- (void)setModel:(SPSDKProductComment *)model
{
    _model = model;
    
    if (model.anonymity)
    {
        if (model.buyerName.length == 1)
        {
            self.userNameLabel.text = [NSString stringWithFormat:@"%c***", [model.buyerName characterAtIndex:0]];
        }
        else if (model.buyerName.length > 1)
        {
            self.userNameLabel.text = [NSString stringWithFormat:@"%c***%c", [model.buyerName characterAtIndex:0], [model.buyerName characterAtIndex:model.buyerName.length - 1]];
        }
        else
        {
            self.userNameLabel.text = model.buyerName;
        }
    }
    else
    {
        self.userNameLabel.text = model.buyerName;
    }
    self.contentLabel.text = model.comment;
    self.starView.scorePercent = model.commentStars / 5.f;

    self.imageV1.image = nil;
    self.imageV2.image = nil;
    self.imageV3.image = nil;
    self.imageV4.image = nil;
    
    [model.commentImgs enumerateObjectsUsingBlock:^(SPSDKImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0)
        {
            [self.imageV1 sd_setImageWithURL:[NSURL URLWithString:image.src] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];
        }
        else if (idx == 1)
        {
            [self.imageV2 sd_setImageWithURL:[NSURL URLWithString:image.src] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];
        }
        else if (idx == 2)
        {
            [self.imageV3 sd_setImageWithURL:[NSURL URLWithString:image.src] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];
        }
        else
        {
            [self.imageV4 sd_setImageWithURL:[NSURL URLWithString:image.src] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];
        }
        
    }];
    
    self.typeLabel.text = model.propertyDescribe;
}

@end
