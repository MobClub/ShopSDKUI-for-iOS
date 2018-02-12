//
//  SPSDKAddAddressViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/6.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKAddAddressViewController.h"
#import "SPSDKAddressInfoCell.h"
#import "SPSDKDetailAddressCell.h"
#import "SPSDKPickerView.h"
#import "SPSDKTextView.h"

static NSString *const SPSDKAddressInfoCellId = @"SPSDKAddressInfoCell";
static NSString *const SPSDKDetailAddressCellId = @"SPSDKDetailAddressCell";

@interface SPSDKAddAddressViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) SPSDKAddressType type;
@property (weak, nonatomic) IBOutlet SPSDKTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) SPSDKPickerView *pickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic, copy) NSString *address;
@property (nonatomic, strong) NSMutableArray *addressDatas;

@end

@implementation SPSDKAddAddressViewController

- (NSMutableArray *)addressDatas
{
    if (!_addressDatas)
    {
        _addressDatas = [NSMutableArray array];
    }
    return _addressDatas;
}

- (NSArray *)titles
{
    if (!_titles)
    {
        _titles = @[@"收货人", @"联系电话", @"所在区域", @"详细地址", @"设为默认"];
    }
    return _titles;
}

- (SPSDKPickerView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [[SPSDKPickerView alloc] initWithPickerType:SPSDKPickerTypeAddress];
    }
    return _pickerView;
}

- (instancetype)initWithType:(SPSDKAddressType)type
{
    self = [super init];
    if (self)
    {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.bottomConstraint.constant = SPSDKiPhoneX ? 34.f : 0.f;
    
    if (_type == SPSDKAddressTypeEdit)
    {
        _address = [NSString stringWithFormat:@"%@%@%@", _model.province.name, _model.city.name, _model.district.name];
        self.title = @"修改地址";
    }
    else
    {
        _model = [[SPSDKShippingAddress alloc] init];
        self.title = @"新增地址";
    }
    
    [self.submitBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateNormal];
    [self.submitBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateHighlighted];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_type == SPSDKAddressTypeEdit)
    {
        return self.titles.count - 1;
    }
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
        SPSDKDetailAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKDetailAddressCellId];
        if (!cell)
        {
            cell = [SPSDKDetailAddressCell loadInstanceFromNib];
        }
        cell.title = self.titles[indexPath.row];
        
        if (_type == SPSDKAddressTypeEdit)
        {
            cell.textView.text = _model.street;
        }
        
        return cell;
    }
    else
    {
        SPSDKAddressInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKAddressInfoCellId];
        if (!cell)
        {
            cell = [SPSDKAddressInfoCell loadInstanceFromNib];
        }
        if (indexPath.row == 2)
        {
            cell.hiddenArrow = NO;
            cell.placeHolder = @"请选择";
            
            if (_type == SPSDKAddressTypeEdit)
            {
                cell.text = _address;
            }
        }
        else
        {
            cell.hiddenArrow = YES;
        }
        
        if (indexPath.row == 1)
        {
            if (_type == SPSDKAddressTypeEdit)
            {
                cell.text = _model.telephone;
            }
            
            cell.keyboadType = UIKeyboardTypeNumberPad;
        }
        else
        {
            cell.keyboadType = UIKeyboardTypeDefault;
        }
        
        if (indexPath.row == 4)
        {
            cell.hasSwitch = YES;
            cell.hiddenLine = YES;
            
            if (_type == SPSDKAddressTypeEdit)
            {
                cell.switchBtn.selected = _model.defaultAddr;
            }
        }
        else
        {
            cell.hiddenLine = NO;
            cell.hasSwitch = NO;
        }
        
        if (indexPath.row == 0)
        {
            if (_type == SPSDKAddressTypeEdit)
            {
                cell.text = _model.realName;
            }
        }
        
        cell.title = self.titles[indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegatesh

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        [self.view endEditing:YES];
        
        if (!self.addressDatas.count)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ShopSDK getArea:^(NSArray<SPSDKArea *> *areaList, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (!error)
                {
                    self.addressDatas = [areaList mutableCopy];
                    [self showPickerViewAtIndexPath:indexPath];
                }
                else
                {
                    [MBProgressHUD showTitle:error.message];
                }
                
            }];
        }
        else
        {
            [self showPickerViewAtIndexPath:indexPath];
        }
    }
}

- (void)showPickerViewAtIndexPath:(NSIndexPath *)indexPath
{
    self.pickerView.address = self.addressDatas;
    if (_address)
    {
        [self.pickerView selectProvinceId:_model.province.areaId cityId:_model.city.areaId districtId:_model.district.areaId];
    }
    [self.pickerView show];
    __weak typeof(self) weakSelf = self;
    self.pickerView.addressSelectHandler = ^(SPSDKArea *province, SPSDKArea *city, SPSDKArea *district) {
        weakSelf.address = [NSString stringWithFormat:@"%@%@%@",province.name, city.name, district.name];
        weakSelf.model.province = province;
        weakSelf.model.city = city;
        weakSelf.model.district = district;
        SPSDKAddressInfoCell *cell = (SPSDKAddressInfoCell *)[weakSelf.tableView cellForRowAtIndexPath:indexPath];
        cell.text = weakSelf.address;
        [weakSelf.tableView reloadData];
    };
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
        return 70;
    }
    
    if (indexPath.row == 4)
    {
        return 42;
    }
    
    return 48;
}

#pragma mark - Action

- (IBAction)_onSubmitAction:(id)sender
{
    SPSDKAddressInfoCell *cell = (SPSDKAddressInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *realName = cell.textField.text;
    
    SPSDKAddressInfoCell *cell1 = (SPSDKAddressInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSString *phoneNum = cell1.textField.text;
    
    SPSDKDetailAddressCell *cell3 = (SPSDKDetailAddressCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    NSString *street = cell3.textView.text;
    
    SPSDKAddressInfoCell *cell4 = (SPSDKAddressInfoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    BOOL isDefault = cell4.switchBtn.selected;
    
    if (realName.length < 2)
    {
        [MBProgressHUD showTitle:@"收货人姓名至少两个字符"];
        return;
    }
    
    if (phoneNum.length < 1)
    {
        [MBProgressHUD showTitle:@"请填写联系电话"];
        return;
    }
    
    if (_address.length < 1)
    {
        [MBProgressHUD showTitle:@"请选择所在地区"];
        return;
    }
    
    if (street.length < 1)
    {
        [MBProgressHUD showTitle:@"请填写详细地址"];
        return;
    }

    _model.realName = realName;
    _model.telephone = phoneNum;
    _model.street = street;
    _model.defaultAddr = isDefault;

    if (_type == SPSDKAddressTypeAdd)
    {
        [ShopSDK createShippingAddress:_model result:^(SPSDKShippingAddress *address, NSError *error) {
            if (!error)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:SPSDKRefreshAddressNotif object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showTitle:@"添加成功"];
            }
            else
            {
                [MBProgressHUD showTitle:error.message];
            }
        }];
    }
    else
    {
       [ShopSDK modifyShippingAddressWithId:_model.shippingAddrId
                                    address:_model
                                     result:^(SPSDKShippingAddress *address, NSError *error) {
                                         if (!error)
                                         {
                                             [[NSNotificationCenter defaultCenter] postNotificationName:SPSDKRefreshAddressNotif object:nil];
                                             [self.navigationController popViewControllerAnimated:YES];
                                             [MBProgressHUD showTitle:@"修改成功"];
                                         }
                                         else
                                         {
                                             [MBProgressHUD showTitle:error.message];
                                         }
                                    }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
