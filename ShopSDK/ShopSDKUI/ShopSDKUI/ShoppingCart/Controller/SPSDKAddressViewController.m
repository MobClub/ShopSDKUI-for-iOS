//
//  SPSDKAddressViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/6.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKAddressViewController.h"
#import "SPSDKEditAddressCell.h"
#import "SPSDKAddAddressViewController.h"
#import "SPSDKEditAddressFooterView.h"

static NSString *const SPSDKEditAddressCellId = @"SPSDKEditAddressCell";

@interface SPSDKAddressViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet SPSDKGroupTableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barHeight;
@property (nonatomic, assign) BOOL isManage;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation SPSDKAddressViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (instancetype)initWithManage:(BOOL)isManage
{
    self = [super init];
    if (self)
    {
        _isManage = isManage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bottomConstraint.constant = SPSDKiPhoneX ? 34.f : 0.f;
    
    [self.tableView registerNib:[SPSDKEditAddressCell loadNib] forCellReuseIdentifier:SPSDKEditAddressCellId];
    
    if (_isManage)
    {
        self.title = @"管理地址";
    }
    else
    {
        self.title = @"选择收货地址";
        [self createNavigatioItem:SPSDKNavItemTypeTitle name:@"管理" isLeft:NO];
    }
   
    self.tableView.estimatedRowHeight = 100.f;
    [self.addressBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateNormal];
    [self.addressBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateHighlighted];
    
    [self refresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshAddress)
                                                 name:SPSDKRefreshAddressNotif
                                               object:nil];
}

- (void)refreshAddress
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)refresh
{
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [ShopSDK getShippingAddress:^(NSArray<SPSDKShippingAddress *> *addressList, NSError *error) {
            
            if (!error)
            {
                weakSelf.dataSource = [addressList mutableCopy];
                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header endRefreshing];
            }
            else
            {
                [MBProgressHUD showTitle:error.message];
                [weakSelf.tableView.mj_header endRefreshing];
            }
            
        }];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKEditAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKEditAddressCellId forIndexPath:indexPath];
    cell.hiddenLine = !_isManage;
    if (_isManage)
    {
        cell.hiddenDefault = YES;
    }
    cell.model = self.dataSource[indexPath.section];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return CGFLOAT_MIN;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!_isManage)
    {
        return nil;
    }
    SPSDKEditAddressFooterView *footerView = [SPSDKEditAddressFooterView loadInstanceFromNib];
    footerView.section = section;
    SPSDKShippingAddress *model = self.dataSource[section];
    footerView.isDefault = model.defaultAddr;
    footerView.actionHandler = ^(NSInteger index, NSInteger section) {
        if (index == 0)
        {
            SPSDKShippingAddress *model = self.dataSource[section];
            model.defaultAddr = YES;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ShopSDK modifyShippingAddressWithId:model.shippingAddrId
                                         address:model
                                          result:^(SPSDKShippingAddress *address, NSError *error) {
                                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                                              if (error)
                                              {
                                                  [MBProgressHUD showTitle:error.message];
                                                  model.defaultAddr = NO;
                                              }
                                              else
                                              {
                                                  [[NSNotificationCenter defaultCenter] postNotificationName:SPSDKRefreshAddressNotif object:nil];
                                              }
                                              [tableView reloadData];
                                          }];
        }
        else if (index == 1)
        {
            SPSDKAddAddressViewController *addVC = [[SPSDKAddAddressViewController alloc] initWithType:SPSDKAddressTypeEdit];
            SPSDKShippingAddress *model = self.dataSource[section];
            addVC.model = model;
            [self.navigationController pushViewController:addVC animated:YES];
        }
        else
        {
            SPSDKShippingAddress *model = self.dataSource[section];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [ShopSDK deleteShippingAddress:model result:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (!error)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:SPSDKRefreshAddressNotif object:nil];
                    [MBProgressHUD showTitle:@"删除成功"];
                    [self.dataSource removeObjectAtIndex:section];
                    [tableView reloadData];
                }
                else
                {
                    [MBProgressHUD showTitle:error.message];
                }
            }];
        }
    };
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_isManage)
    {
        if (self.selectAddressHandler)
        {
            SPSDKShippingAddress *model = self.dataSource[indexPath.section];
            self.selectAddressHandler(model);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (!_isManage)
    {
        return CGFLOAT_MIN;
    }
    return 36.f;
}

#pragma mark - Action

- (IBAction)_onAddressAction:(id)sender
{
    SPSDKAddAddressViewController *address = [[SPSDKAddAddressViewController alloc] initWithType:SPSDKAddressTypeAdd];
    [self.navigationController pushViewController:address animated:YES];
}

- (void)onRightBtnAction:(UIButton *)sender
{
    SPSDKAddressViewController *addressVC = [[SPSDKAddressViewController alloc] initWithManage:YES];
    [self.navigationController pushViewController:addressVC animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
