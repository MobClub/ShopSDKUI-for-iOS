//
//  SPSDKCountView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/5.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKCountView.h"

@interface SPSDKCountView() <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *subBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;

@end

@implementation SPSDKCountView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self loadNibName:@"SPSDKCountView"];
        
        _minValue = 1;
        _maxValue = NSIntegerMax;
        _numTextField.delegate = self;
        _numTextField.backgroundColor = [UIColor colorForHex:0xf7f7f7];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self loadNibName:@"SPSDKCountView"];
        
        _minValue = 1;
        _maxValue = NSIntegerMax;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.numTextField.delegate = self;
    self.numTextField.backgroundColor = [UIColor colorForHex:0xf7f7f7];
}

- (void)setMaxValue:(NSInteger)maxValue
{
    _maxValue = maxValue;
    
//    [self checkTextFieldNumberWithUpdate];
//    [self buttonClickCallBack];
}

- (IBAction)increase:(id)sender
{
    NSInteger number = _numTextField.text.integerValue + 1;
    
    if (number <= _maxValue)
    {
        _numTextField.text = [NSString stringWithFormat:@"%zd", number];
        
        [self buttonClickCallBack];
    }
    else
    {
        [MBProgressHUD showTitle:@"亲，该宝贝不能购买更多哦"];
    }
}

- (void)buttonClickCallBack
{
    if (self.resultHandler)
    {
        self.resultHandler(_numTextField.text.integerValue);
    }
}

- (IBAction)decrease:(id)sender
{
    [self checkTextFieldNumberWithUpdate];
    
    NSInteger number = [_numTextField.text integerValue] - 1;
    
    if (number >= _minValue)
    {
        _numTextField.text = [NSString stringWithFormat:@"%zd", number];
        [self buttonClickCallBack];
    }
    else
    {
        [MBProgressHUD showTitle:@"亲，宝贝不能再减少了哦"];
    }
}

- (void)checkTextFieldNumberWithUpdate
{
    NSString *minValueString = [NSString stringWithFormat:@"%zd", _minValue];
    NSString *maxValueString = [NSString stringWithFormat:@"%zd", _maxValue];
    
    if ([_numTextField.text isNotBlank] == NO || _numTextField.text.integerValue < _minValue)
    {
        _numTextField.text = minValueString;
    }
    _numTextField.text.integerValue > _maxValue ? _numTextField.text = maxValueString : nil;
}

- (NSInteger)currentNumber
{
    return _numTextField.text.integerValue;
}

- (void)setCurrentNumber:(NSInteger)currentNumber
{
    _numTextField.text = [NSString stringWithFormat:@"%zd", currentNumber];
    
    if (_numTextField.text.integerValue > _maxValue)
    {
        [MBProgressHUD showTitle:@"商品数量超出库存~"];
        [self checkTextFieldNumberWithUpdate];
        if (self.outRangeHandler)
        {
            self.outRangeHandler(_numTextField.text.integerValue);
        }
    }
    else
    {
        [self checkTextFieldNumberWithUpdate];
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_numTextField.text.integerValue > _maxValue)
    {
        [MBProgressHUD showTitle:@"数量超出范围~"];
    }
    [self checkTextFieldNumberWithUpdate];
    [self buttonClickCallBack];
}

@end
