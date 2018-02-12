//
//  SPSDKSearchView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/7.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKSearchView.h"

@interface SPSDKSearchView () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@end

@implementation SPSDKSearchView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _needClick = YES;
    self.backgroundColor = [UIColor colorForHex:0xFFFFFF alpha:0.2];
    self.textField.textColor = [UIColor whiteColor];
    self.textField.delegate = self;
    [self.textField setPlaceholderTextColor:[UIColor colorForHex:0xF4BAAE] font:[UIFont systemFontOfSize:14]];
    [self.textField.subviews.firstObject removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onValueChange)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];

}

- (void)setTextFieldEnable:(BOOL)textFieldEnable
{
    _textFieldEnable = textFieldEnable;
    
    self.textField.enabled = textFieldEnable;
}

- (void)setSearchKey:(NSString *)searchKey
{
    self.textField.text = searchKey;
    
    if (_hiddenClear)
    {
        self.clearBtn.hidden = YES;
    }
    else
    {
        self.clearBtn.hidden = !self.textField.text.length;
    }
}

- (NSString *)searchKey
{
    return self.textField.text;
}

- (void)setHiddenClear:(BOOL)hiddenClear
{
    _hiddenClear = hiddenClear;
    
    if (_hiddenClear)
    {
        self.clearBtn.hidden = YES;
    }
    else
    {
        self.clearBtn.hidden = !self.textField.text.length;
    }
}

- (IBAction)onClearAction:(id)sender
{
    self.textField.text = nil;
    self.clearBtn.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.searchHandler)
    {
        self.searchHandler(textField.text);
    }
    return YES;
}

- (void)onValueChange
{
    if (!_hiddenClear)
    {
        self.clearBtn.hidden = !self.textField.text.length;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_needClick)
    {
        if (self.clickHandler)
        {
            self.clickHandler();
        }
    }
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(ScreenWidth - 90.f, 29.f);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
