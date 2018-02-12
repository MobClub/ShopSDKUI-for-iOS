//
//  SPSDKPickerView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/25.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKPickerView.h"
#import <ShopSDK/SPSDKArea.h>

static CGFloat const SPSDKPickerHeight = 217.f;

@interface SPSDKPickerView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *controllerToolBar;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, assign) NSInteger pickerHeight;
@property (nonatomic, assign) SPSDKPickerType type;
@property (nonatomic, strong) NSArray <SPSDKArea *> *dataSource;
@property (nonatomic, assign) NSInteger selectRow1;
@property (nonatomic, assign) NSInteger selectRow2;
@property (nonatomic, assign) NSInteger selectRow3;
@property (nonatomic, assign) NSInteger selectRow;
@property (nonatomic, copy) NSArray *provinces;
@property (nonatomic, copy) NSArray *citys;
@property (nonatomic, copy) NSArray *districts;

@end

@implementation SPSDKPickerView

- (instancetype)initWithPickerType:(SPSDKPickerType)type
{
    if (self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)])
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        self.userInteractionEnabled = YES;
        [self addSubview:self.maskView];
        _pickerHeight = SPSDKPickerHeight;
        _type = type;
        
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    _selectRow1 = 0;
    _selectRow2 = 0;
    _selectRow3 = 0;
    
    self.bottomView = [[UIView alloc] init];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.showsSelectionIndicator = YES;
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.bottomView addSubview:self.pickerView];
    
    self.controllerToolBar = [[UIView alloc] init];
    self.controllerToolBar.backgroundColor = [UIColor colorForHex:0xf7f7f7];
    [self.bottomView addSubview:_controllerToolBar];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:SPSDKMainColor forState:UIControlStateNormal];
    [self.controllerToolBar addSubview:self.sureBtn];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.cancelBtn addTarget:self action:@selector(canceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.controllerToolBar addSubview:_cancelBtn];

    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor clearColor];
    [window addSubview:self];
}

- (void)setAddress:(NSArray *)address
{
    _address = address;
    
    self.provinces = [address mutableCopy];
    
    SPSDKArea *province = self.provinces.firstObject;
    self.citys = province.children;
    
    SPSDKArea *city = self.citys.firstObject;
    self.districts = city.children;
    
    [self layoutSelfSubviews];
    [self.pickerView setNeedsLayout];
    
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
}

- (void)setTitles:(NSArray *)titles
{
    _titles = titles;
    
    [self layoutSelfSubviews];
    [self.pickerView setNeedsLayout];
    
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
}

- (void)setSelectValue:(NSString *)selectValue
{
    _selectValue = selectValue;
    
    __block NSInteger defaultSelectRow = 0;
    [self.titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([selectValue isEqualToString:title])
        {
            defaultSelectRow = idx;
            *stop = YES;
        }
    }];
    
    _selectRow = defaultSelectRow;
    [self.pickerView selectRow:defaultSelectRow inComponent:0 animated:NO];
}

- (void)selectProvinceId:(UInt64)provinceId
                  cityId:(UInt64)cityId
              districtId:(UInt64)districtId
{
    [self.provinces enumerateObjectsUsingBlock:^(SPSDKArea * _Nonnull province, NSUInteger idx, BOOL * _Nonnull stop) {
        if (province.areaId == provinceId)
        {
            _selectRow1 = idx;
            *stop = YES;
        }
    }];
    
    SPSDKArea *province = self.provinces[_selectRow1];
    self.citys = province.children;
    [self.citys enumerateObjectsUsingBlock:^(SPSDKArea * _Nonnull city, NSUInteger idx, BOOL * _Nonnull stop) {
        if (city.areaId == cityId)
        {
            _selectRow2 = idx;
            *stop = YES;
        }
    }];
    
    SPSDKArea *city = self.citys[_selectRow2];
    self.districts = city.children;
    [self.districts enumerateObjectsUsingBlock:^(SPSDKArea * _Nonnull district, NSUInteger idx, BOOL * _Nonnull stop) {
        if (district.areaId == districtId)
        {
            _selectRow3 = idx;
            *stop = YES;
        }
    }];

    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:_selectRow1 inComponent:0 animated:NO];
    [self.pickerView selectRow:_selectRow2 inComponent:1 animated:NO];
    [self.pickerView selectRow:_selectRow3 inComponent:2 animated:NO];
}

- (void)layoutSelfSubviews
{
    self.bottomView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, self.pickerHeight);
    
    self.pickerView.frame = CGRectMake(0, 40, ScreenWidth, self.pickerHeight - 40);
    
    self.controllerToolBar.frame = CGRectMake(0, 0, ScreenWidth, 40);
    
    self.sureBtn.frame = CGRectMake(ScreenWidth - 70, 5, 70, 30);
    
    self.cancelBtn.frame = CGRectMake(0, 5, 70, 30);
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (_type == SPSDKPickerTypeAddress)
    {
        return 3;
    }
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_type == SPSDKPickerTypeAddress)
    {
        if (component == 0)
        {
            return self.provinces.count;
        }
        else if (component == 1)
        {
            return self.citys.count;
        }
        else
        {
            return self.districts.count;
        }
    }
    return self.titles.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_type == SPSDKPickerTypeAddress)
    {
        if (component == 0)
        {
            SPSDKArea *area = self.provinces[row];
            return area.name;
        }
        else if (component == 1)
        {
            SPSDKArea *city = self.citys[row];
            return city.name;
        }
        else
        {
            SPSDKArea *district = self.districts[row];
            return district.name;
        }
    }
    return self.titles[row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35.f;
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_type == SPSDKPickerTypeAddress)
    {
        switch (component)
        {
            case 0:
            {
                SPSDKArea *province = self.provinces[row];
                self.citys = province.children;
                [_pickerView selectRow:0 inComponent:1 animated:NO];
                [_pickerView reloadComponent:1];
                
                SPSDKArea *city = self.citys.firstObject;
                self.districts = city.children;
                [_pickerView selectRow:0 inComponent:2 animated:NO];
                [_pickerView reloadComponent:2];
            }
                break;
                
            case 1:
            {
                SPSDKArea *city = self.citys[row];
                self.districts = city.children;
                
                [_pickerView selectRow:0 inComponent:2 animated:NO];
                [_pickerView reloadComponent:2];
            }
                break;
                
            default:
                break;
        }
        
        _selectRow1 = [pickerView selectedRowInComponent:0];
        _selectRow2 = [pickerView selectedRowInComponent:1];
        _selectRow3 = [pickerView selectedRowInComponent:2];
    }
    else
    {
        _selectRow = row;
    }
    
    [self.pickerView reloadAllComponents];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *pickerLabel = (UILabel *)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.backgroundColor = [UIColor clearColor];
        pickerLabel.font = [UIFont systemFontOfSize:16.0];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark - Action

- (void)sureBtnClicked:(UIButton *)button
{
    if (_type == SPSDKPickerTypeAddress)
    {
        SPSDKArea *province = self.provinces[_selectRow1];
        
        SPSDKArea *city = self.citys[_selectRow2];
        
        SPSDKArea *district = self.districts[_selectRow3];
        
        if (self.addressSelectHandler)
        {
            self.addressSelectHandler(province, city, district);
        }
    }
    else
    {
        if (self.valueDidSelectHandler)
        {
            self.valueDidSelectHandler(self.titles[_selectRow]);
        }
    }
    
    [self removeSelfFromSupView];
}

- (void)canceBtnClicked:(UIButton *)button
{
    [self removeSelfFromSupView];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self removeSelfFromSupView];
}

#pragma mark - 显示弹层相关

- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    CGRect frame = self.bottomView.frame;
    frame.origin.y -= self.pickerHeight;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = frame;
    }];
}

- (void)removeSelfFromSupView
{
    CGRect selfFrame = self.bottomView.frame;
    selfFrame.origin.y += self.pickerHeight;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = selfFrame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
