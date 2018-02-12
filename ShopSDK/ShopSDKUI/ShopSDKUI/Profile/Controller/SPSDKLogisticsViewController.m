//
//  SPSDKLogisticsViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKLogisticsViewController.h"
#import "SPSDKLogisticsCell.h"
#import "SPSDKLogisticsHeaderView.h"

static NSString *const SPSDKLogisticsCellId = @"SPSDKLogisticsCell";

@interface SPSDKLogisticsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet SPSDKGroupTableView *tableView;
@property (nonatomic, strong) SPSDKTransport *transport;
@property (nonatomic, strong) SPSDKTransport *inputTransport;
@property (nonatomic, weak) SPSDKLogisticsHeaderView *headerView;
@property (nonatomic, assign) SPSDKLogisticsType type;

@end

@implementation SPSDKLogisticsViewController

- (instancetype)initWithTransport:(SPSDKTransport *)transport type:(SPSDKLogisticsType)type
{
    self = [super init];
    if (self)
    {
        _inputTransport = transport;
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = _type == SPSDKLogisticsTypeProduct ? @"查看物流" : @"售后详情";
    
    SPSDKLogisticsHeaderView *headerView = [SPSDKLogisticsHeaderView loadInstanceFromNib];
    headerView.autoresizingMask = UIViewAutoresizingNone;
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    self.headerView.hidden = YES;

    [self.tableView registerNib:[SPSDKLogisticsCell loadNib] forCellReuseIdentifier:SPSDKLogisticsCellId];
    self.tableView.estimatedRowHeight = 80.f;
    
    [self requestData];
}

- (void)requestData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ShopSDK queryExpressWithTransport:_inputTransport result:^(SPSDKTransport *transport, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error)
        {
            _transport = transport;
            [self.tableView reloadData];
            self.headerView.hidden = NO;
            if (_type == SPSDKLogisticsTypeProduct)
            {
                self.headerView.descriptionLabel.text = @"物流详情";
                self.headerView.transportNameLabel.text = [NSString stringWithFormat:@"承运方：%@", _transport.expressCompanyName];
                self.headerView.transportOrderLabel.text = [NSString stringWithFormat:@"运单号：%@", _transport.expressNo];
            }
            else
            {
                self.headerView.descriptionLabel.text = @"售后详情";
                self.headerView.transportNameLabel.text = [NSString stringWithFormat:@"运单号：%@", _transport.expressNo];
                self.headerView.transportOrderLabel.text = [NSString stringWithFormat:@"申请时间：%@", [NSDate dateWithTimeStamp:_transport.expressCreateAt]];
            }
        }
        else
        {
            [MBProgressHUD showTitle:error.message];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _transport.expressDescribe.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKLogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKLogisticsCellId forIndexPath:indexPath];
    cell.hiddenLine = indexPath.row == 0;
    cell.model = _transport.expressDescribe[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

@end
