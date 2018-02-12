//
//  SPSDKFillLogisticsViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/17.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKFillLogisticsViewController.h"
#import "SPSDKFillLogisticsCell.h"
#import "SPSDKFillLogisticsHeader.h"
#import "SPSDKCourierCompanyViewController.h"

static NSString *const SPSDKFillLogisticsCellId = @"SPSDKFillLogisticsCell";

@interface SPSDKFillLogisticsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet SPSDKGroupTableView *tableView;
@property (nonatomic, strong) SPSDKTransportCompany *company;
@property (nonatomic, assign) BOOL isAdd;
@property (nonatomic, assign) UInt64 transportId;
@property (nonatomic, strong) SPSDKTradingCommodity *orderCommodity;

@end

@implementation SPSDKFillLogisticsViewController

- (instancetype)initWithOrderCommodity:(SPSDKTradingCommodity *)orderCommodity isAdd:(BOOL)isAdd
{
    self = [super init];
    if (self)
    {
        _orderCommodity = orderCommodity;
        _isAdd = isAdd;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"填写快递单号";
    
    [self.submitBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateNormal];
    [self.submitBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateHighlighted];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKFillLogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKFillLogisticsCellId];
    if (!cell)
    {
        cell = [SPSDKFillLogisticsCell loadInstanceFromNib];
    }
    cell.hiddenLine = indexPath.row == 1;
    if (indexPath.row == 0)
    {
        cell.textField.enabled = NO;
        cell.arrowImageV.hidden = NO;
        cell.textField.placeholder = @"请选择快递公司";
        if (_company.abbreviation)
        {
            cell.textField.text = _company.abbreviation;
        }
        cell.title.text = @"承运方";
    }
    else
    {
        cell.textField.enabled = YES;
        cell.arrowImageV.hidden = YES;
        cell.textField.placeholder = @"请输入快递单号";
        cell.title.text = @"快递单号";
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 42.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SPSDKFillLogisticsHeader *header = [SPSDKFillLogisticsHeader loadInstanceFromNib];
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        SPSDKCourierCompanyViewController *companyVC = [[SPSDKCourierCompanyViewController alloc] initWithCompany:_company];
        companyVC.selectHandler = ^(SPSDKTransportCompany *company) {
            _company = company;
            [tableView reloadData];
        };
        [self.navigationController pushViewController:companyVC animated:YES];
    }
}

- (IBAction)onSubmitAction:(id)sender
{
    SPSDKFillLogisticsCell *cell = (SPSDKFillLogisticsCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (![cell.textField.text isNumber])
    {
        [MBProgressHUD showTitle:@"请输入合法的订单号"];
        return;
    }
    _transportId = [cell.textField.text integerValue];
    
    SPSDKTransport *transport = [[SPSDKTransport alloc] initWithTransportId:_transportId];
    
    SPSDKRefundAddressType type = _isAdd ? SPSDKRefundAddressTypeAdd : SPSDKRefundAddressTypeModify;
    [ShopSDK fillInExpressInfoWithOrderCommodity:_orderCommodity
                                   operationType:type
                                       transport:transport
                                  expressCompany:_company
                                          result:^(NSError *error) {
                                              if (!error)
                                              {
                                                  [MBProgressHUD showTitle:_isAdd ? @"添加成功" : @"修改成功"];
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  if (self.completHandler)
                                                  {
                                                      self.completHandler();
                                                  }
                                              }
                                              else
                                              {
                                                  [MBProgressHUD showTitle:error.message];
                                              }
                                          }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
