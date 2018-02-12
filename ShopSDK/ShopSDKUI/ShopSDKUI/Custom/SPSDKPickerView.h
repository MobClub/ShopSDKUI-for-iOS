//
//  SPSDKPickerView.h
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/25.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SPSDKPickerType) {
    
    SPSDKPickerTypeAddress = 0,
    SPSDKPickerTypeOther,
    
};

@interface SPSDKPickerView : UIView

/**
 构造方法，必须带上指定 type，默认 Address

 @param type  类型
 @return  pickerView
 */
- (instancetype)initWithPickerType:(SPSDKPickerType)type;

/**
 选择地址传入的数组
 */
@property (nonatomic, copy) NSArray *address;

/**
 选择其他传入的数组
 */
@property (nonatomic, copy) NSArray *titles;

/**
 选中

 @param provinceId  省
 @param cityId 市
 @param districtId 区
 */
- (void)selectProvinceId:(UInt64)provinceId
                  cityId:(UInt64)cityId
              districtId:(UInt64)districtId;

/**
 选中值
 */
@property (nonatomic, strong) NSString *selectValue;

/**
 选择地址的确定回调
 */
@property (nonatomic, copy) void (^addressSelectHandler) (SPSDKArea *province, SPSDKArea *city, SPSDKArea *district);

@property (nonatomic, copy) void (^valueDidSelectHandler) (NSString *title);

/**
 显示
 */
- (void)show;

@end
