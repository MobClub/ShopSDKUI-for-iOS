//
//  SPSDKRefundViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/20.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKRefundViewController.h"
#import "SPSDKOrderDetailCell.h"
#import "SPSDKRefundFooterView.h"
#import "SPSDKRefundDetailViewController.h"
#import "SPSDKSearchViewController.h"

static NSString *const SPSDKOrderDetailCellId = @"SPSDKOrderDetailCell";

@interface SPSDKRefundViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet SPSDKGroupTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, assign) BOOL hasSearch;

@end

@implementation SPSDKRefundViewController

- (instancetype)initWithKeyword:(NSString *)keyword hasSearch:(BOOL)hasSearch
{
    self = [super init];
    if (self)
    {
        _keyword = keyword;
        _hasSearch = hasSearch;
    }
    return self;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"退款售后";
    
    if (_hasSearch)
    {
        [self createNavigatioItem:SPSDKNavItemTypeImage name:@"search" isLeft:NO];
    }
    
    [self refresh];
}

- (void)refresh
{
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.pageIndex = 1;
        
        [ShopSDK getRefundsWithKeyWord:weakSelf.keyword
                              pageSize:SPSDKPageSize
                             pageIndex:weakSelf.pageIndex
                                result:^(NSUInteger pageIndex, NSUInteger countNum, NSArray<SPSDKRefundCommodity *> *commodityList, NSError *error) {
                                    
                                    if (!error)
                                    {
                                        weakSelf.dataSource = [NSMutableArray arrayWithArray:commodityList];
                                        [weakSelf.tableView reloadData];
                                        [weakSelf.tableView.mj_header endRefreshing];
                                        [weakSelf.tableView.mj_footer resetNoMoreData];
                                    }
                                    else
                                    {
                                        [MBProgressHUD showTitle:error.message];
                                        [weakSelf.tableView.mj_header endRefreshing];
                                    }
                                }];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageIndex ++;
        
        [ShopSDK getRefundsWithKeyWord:weakSelf.keyword
                              pageSize:SPSDKPageSize
                             pageIndex:weakSelf.pageIndex
                                result:^(NSUInteger pageIndex, NSUInteger countNum, NSArray<SPSDKRefundCommodity *> *commodityList, NSError *error) {
                                    
                                    if (!error)
                                    {
                                        [weakSelf.dataSource addObjectsFromArray:commodityList];
                                        [weakSelf.tableView reloadData];
                                        [weakSelf.tableView.mj_footer endRefreshing];
                                        if (!commodityList.count)
                                        {
                                            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                        }
                                    }
                                    else
                                    {
                                        [MBProgressHUD showTitle:error.message];
                                        [weakSelf.tableView.mj_footer endRefreshing];
                                    }
                                }];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.tableView.mj_footer.hidden = self.dataSource.count == 0;
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKOrderDetailCellId];
    if (!cell)
    {
        cell = [SPSDKOrderDetailCell loadInstanceFromNib];
    }
    cell.refundModel = self.dataSource[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    SPSDKRefundFooterView *footerView = [SPSDKRefundFooterView loadInstanceFromNib];
    footerView.model = self.dataSource[section];
    footerView.section = section;
    footerView.detailHandler = ^(NSInteger section) {
        SPSDKRefundCommodity *refundModel = self.dataSource[section];
        SPSDKRefundDetailViewController *refundVC = [[SPSDKRefundDetailViewController alloc] initWithOrderCommodity:refundModel.orderCommodity];
        [self.navigationController pushViewController:refundVC animated:YES];
    };
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return CGFLOAT_MIN;
    }
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return  39.5f;
}

- (void)onRightBtnAction:(UIButton *)sender
{
    SPSDKSearchViewController *searchVC = [[SPSDKSearchViewController alloc] initWithSearchType:SPSDKSearchTypeRefund];
    searchVC.searchHandler = ^(NSString *key) {
        SPSDKRefundViewController *refundVC = [[SPSDKRefundViewController alloc] initWithKeyword:key hasSearch:YES];
        [self.navigationController pushViewController:refundVC animated:NO];
    };
    searchVC.clickTagHandler = ^(NSInteger index, NSString *key) {
        SPSDKRefundViewController *refundVC = [[SPSDKRefundViewController alloc] initWithKeyword:key hasSearch:YES];
        [self.navigationController pushViewController:refundVC animated:NO];
    };
    SPSDKNavigationController *nav = [[SPSDKNavigationController alloc] initWithRootViewController:searchVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
