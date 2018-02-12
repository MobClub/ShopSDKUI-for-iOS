//
//  SPSDKLogisticsCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKLogisticsCell.h"
#import "TTTAttributedLabel.h"

@interface SPSDKLogisticsCell () <TTTAttributedLabelDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *line1;
@property (weak, nonatomic) IBOutlet UILabel *line2;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation SPSDKLogisticsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.line1.backgroundColor = SPSDKLineColor;
    self.line2.backgroundColor = SPSDKLineColor;
    self.detailLabel.delegate = self;
}

- (void)setDetailText:(NSString *)text
{
    self.detailLabel.linkAttributes = @{NSForegroundColorAttributeName:[UIColor blueColor]};
    
    //设置段落，文字样式
    NSMutableParagraphStyle *paragraphstyle = [[NSMutableParagraphStyle alloc] init];
    paragraphstyle.lineSpacing = 6.0;
    NSDictionary *paragraphDic = @{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:paragraphstyle};
    NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:text attributes:paragraphDic];
    
    [tempStr addAttribute:NSForegroundColorAttributeName value:_hiddenLine ? SPSDKMainColor : SPSDKTextColor range:NSMakeRange(0, text.length)];
    
    self.detailLabel.text = tempStr;
    
    NSRange stringRange = NSMakeRange(0, tempStr.length);
    //正则匹配
    NSError *error;
    NSRegularExpression *regexps = [NSRegularExpression regularExpressionWithPattern:@"\\d{3,4}[- ]?\\d{7,8}" options:0 error:&error];
    if (!error && regexps != nil)
    {
        [regexps enumerateMatchesInString:[tempStr string] options:0 range:stringRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            
            //添加链接
            NSString *actionString = [NSString stringWithFormat:@"%@",[self.detailLabel.text substringWithRange:result.range]];
            
            if ([actionString isMobilePhoneOrtelePhone] || [[actionString substringToIndex:3] isEqualToString:@"400"])
            {
                [self.detailLabel addLinkToPhoneNumber:actionString withRange:result.range];
            }
        }];
    }
}

- (void)setHiddenLine:(BOOL)hiddenLine
{
    _hiddenLine = hiddenLine;
    
    self.line1.hidden = hiddenLine;
    self.imageV.image = hiddenLine ? [UIImage imageNamed:@"zy"] : [UIImage imageNamed:@"hy"];
    
    self.detailLabel.textColor = hiddenLine ? SPSDKMainColor : SPSDKTextColor;
    self.dateLabel.textColor = hiddenLine ? SPSDKMainColor : SPSDKTextColor;
}

- (void)setModel:(SPSDKTransportDesc *)model
{
    _model = model;
    
    [self setDetailText:model.status];
    self.dateLabel.text = model.time;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    NSString *phoneStr = [NSString stringWithFormat:@"tel://%@", phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
