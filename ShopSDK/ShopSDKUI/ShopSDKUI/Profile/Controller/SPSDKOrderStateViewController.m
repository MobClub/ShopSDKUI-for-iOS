//
//  SPSDKOrderStateViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKOrderStateViewController.h"
#import "SPSDKOrderCell.h"
#import "SPSDKOrderStateView.h"
#import "SPSDKOrderDetailViewController.h"
#import "SPSDKLogisticsViewController.h"
#import "SPSDKAppraiseViewController.h"
#import "SPSDKPayView.h"
#import "SPSDKOrder+SPSDKExtension.h"
#import "SPSDKPaySuccessViewController.h"
#import "SPSDKUIPayConfig.h"


static NSString *const SPSDKOrderCellId = @"SPSDKOrderCell";

@interface SPSDKOrderStateViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet SPSDKGroupTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) SPSDKOrderStatus state;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, strong) SPSDKPayView *payView;
@property (nonatomic, strong) SPSDKOrder *customPayOrder;
@property (nonatomic) NSInteger customPaySection;
@property (nonatomic, assign) BOOL checkTimeOut;
@property (nonatomic, assign) BOOL hasResult;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation SPSDKOrderStateViewController

- (SPSDKPayView *)payView
{
    if (!_payView)
    {
        _payView = [[SPSDKPayView alloc] init];
    }
    return _payView;
}

- (instancetype)initWithState:(SPSDKOrderStatus)state keyword:(NSString *)keyword
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self)
    {
        _state = state;
        _keyword = keyword;
    }
    return self;
}

- (void)beginRefreshing
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self refresh];
    
    if (self.isSearch)
    {
        self.title = @"搜索结果";
        [self beginRefreshing];
    }
}

- (void)refresh
{
    __weak typeof(self) weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.pageIndex = 1;
        
        [ShopSDK getOrdersWithKeyWord:weakSelf.keyword
                           OrderStaus:weakSelf.state
                             pageSize:SPSDKPageSize
                            pageIndex:weakSelf.pageIndex
                               result:^(NSUInteger pageIndex, NSUInteger count, NSArray<SPSDKOrder *> *orderList, NSError *error) {
                                   
                                   if (!error)
                                   {
                                       for (SPSDKOrder *order in orderList)
                                       {
                                           order.orderStatus = order.status;
                                           order.hasComment = order.commentCount;
                                       }
                                       
                                       weakSelf.dataSource = [NSMutableArray arrayWithArray:orderList];
                                       [weakSelf.tableView reloadData];
                                       [weakSelf.tableView.mj_header endRefreshing];
                                       [weakSelf.tableView.mj_footer resetNoMoreData];
                                   }
                                   else
                                   {
                                       [MBProgressHUD showTitle:error.message];
                                       [weakSelf.tableView.mj_header endRefreshing];
                                   }
                                   
                                   [weakSelf.view configureTipViewWithTipMessage:@"还没有相关订单哦~"
                                                                         hasData:weakSelf.dataSource.count
                                                                     noDataImage:[UIImage imageNamed:@"empty_order"]];
                               }];
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageIndex ++;
        
        [ShopSDK getOrdersWithKeyWord:weakSelf.keyword
                           OrderStaus:weakSelf.state
                             pageSize:SPSDKPageSize
                            pageIndex:weakSelf.pageIndex
                               result:^(NSUInteger pageIndex, NSUInteger count, NSArray<SPSDKOrder *> *orderList, NSError *error) {
                                   
                                   if (!error)
                                   {
                                       for (SPSDKOrder *order in orderList)
                                       {
                                           order.orderStatus = order.status;
                                           order.hasComment = order.commentCount;
                                       }
                                       
                                       [weakSelf.dataSource addObjectsFromArray:orderList];
                                       [weakSelf.tableView reloadData];
                                       [weakSelf.tableView.mj_footer endRefreshing];
                                       if (orderList.count == 0)
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

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.tableView.mj_footer.hidden = self.dataSource.count == 0 ? 1 : 0;
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SPSDKOrder *order = self.dataSource[section];
    return order.orderCommodityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKOrderCellId];
    if (!cell)
    {
        cell = [SPSDKOrderCell loadInstanceFromNib];
    }
    SPSDKOrder *order = self.dataSource[indexPath.section];
    cell.model = order.orderCommodityList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.f;
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
    return 74.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    SPSDKOrderStateView *footerView = [SPSDKOrderStateView loadInstanceFromNib];
    SPSDKOrder *order = self.dataSource[section];
    footerView.section = section;
    footerView.model = order;
    footerView.actionHandler = ^(NSInteger section, NSInteger btnIndex, SPSDKOrderStatus status) {
        [self handlerButtonIndex:btnIndex status:status section:section];
    };
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKOrder *order = self.dataSource[indexPath.section];
    SPSDKOrderDetailViewController *orderDetailVC = [[SPSDKOrderDetailViewController alloc] initWithOrder:order];
    orderDetailVC.indexPath = indexPath;
    orderDetailVC.modifyHandler = ^(NSInteger section, SPSDKModifyOrderStatus status) {
        [self handlerDataWithStatus:status section:section];
    };
    orderDetailVC.appraiseHandler = ^(NSInteger section) {
        SPSDKOrder *order = self.dataSource[section];
        order.hasComment = YES;
        [self.tableView reloadData];
    };
    orderDetailVC.payHandler = ^(NSInteger section) {
        [self paySuccessWithSection:section];
    };
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

- (void)handlerButtonIndex:(NSInteger)btnIndex status:(SPSDKOrderStatus)status section:(NSInteger)section
{
    SPSDKOrder *order = self.dataSource[section];
    switch (status)
    {
        case SPSDKOrderUnReceive: // 已发货
        {
            if (btnIndex == 1) // 确认收货
            {
                [self modifyOrderStatus:SPSDKModifyOrderStatusReceived order:order section:section];
            }
            else if (btnIndex == 2) // 查看物流
            {
                SPSDKLogisticsViewController *logisticsVC = [[SPSDKLogisticsViewController alloc] initWithTransport:order.transport type:SPSDKLogisticsTypeProduct];
                [self.navigationController pushViewController:logisticsVC animated:YES];
            }
        }
            break;
            
        case SPSDKOrderUnpaid: // 待付款
        {
            if (btnIndex == 1)
            { // 付款
                if (order.freeOfCharge)
                {
                    [self payOrder:order payType:0 section:section];
                }
                else
                {
                    
                    if ([SPSDKUIPayConfig defaultConfig].payMode == 0)
                    {
                        self.payView.order = order;
                        [self.payView show];
                        __weak typeof(self) weakSelf = self;
                        self.payView.payHandler = ^(SPSDKOrder *order, SPSDKPayType payType, float price) {
                            [weakSelf payOrder:order payType:payType section:section];
                        };

                    }
                    else
                    {
                        self.customPayOrder = order;
                        self.customPaySection = section;
                        [self startCustomPay];
                    }

                }
            }
            else
            { // 取消订单
                [self modifyOrderStatus:SPSDKModifyOrderStatusCancel order:order section:section];
            }
        }
            break;
            
        case SPSDKOrderFinished: // 已完成
        {
            if (btnIndex == 1) // 删除订单
            {
                [self modifyOrderStatus:SPSDKModifyOrderStatusDelete order:order section:section];
            }
            else if (btnIndex == 2) // 查看物流
            {
                SPSDKLogisticsViewController *logisticsVC = [[SPSDKLogisticsViewController alloc] initWithTransport:order.transport type:SPSDKLogisticsTypeProduct];
                [self.navigationController pushViewController:logisticsVC animated:YES];
            }
            else // 评价
            {
                SPSDKAppraiseViewController *appraiseVC = [[SPSDKAppraiseViewController alloc] initWithOrder:order];
                appraiseVC.indexSection = section;
                appraiseVC.appraiseHandler = ^(NSInteger section) {
                    SPSDKOrder *order = self.dataSource[section];
                    order.hasComment = YES;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:appraiseVC animated:YES];
            }
        }
            break;
           
        case SPSDKOrderCanceled: // 已取消
        {
            if (btnIndex == 1) // 删除订单
            {
                [self modifyOrderStatus:SPSDKModifyOrderStatusDelete order:order section:section];
            }
        }
            
        default:
            break;
    }
}

- (void)modifyOrderStatus:(SPSDKModifyOrderStatus)status order:(SPSDKOrder *)order section:(NSInteger)section
{
    NSString *successMsg;
    switch (status) {
        case SPSDKModifyOrderStatusCancel:
            {
                successMsg = @"取消订单成功";
            }
            break;
            
        case SPSDKModifyOrderStatusDelete:
        {
            successMsg = @"删除订单成功";
        }
            break;
            
        case SPSDKModifyOrderStatusReceived:
        {
            successMsg = @"确认收货成功";
        }
            break;
            
        default:
            break;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ShopSDK modifyOrderStatus:status order:order result:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error)
        {
            [MBProgressHUD showTitle:successMsg];
            [self handlerDataWithStatus:status section:section];
        }
        else
        {
            [MBProgressHUD showTitle:error.message];
        }
    }];
}

/**
 取消订单
 删除订单
 确认收货
 */
- (void)handlerDataWithStatus:(SPSDKModifyOrderStatus)status section:(NSInteger)section
{
    if (status == SPSDKModifyOrderStatusCancel)
    { // 取消订单
        if (_state == SPSDKOrderStatusAll)
        {// 全部订单列表：请求新的状态然后替换
            SPSDKOrder *order = self.dataSource[section];
            order.orderStatus = SPSDKOrderCanceled;
            [self.tableView reloadData];
        }
        else
        {// 待付款列表：remove
            [self.dataSource removeObjectAtIndex:section];
            [self.tableView reloadData];
            if (!self.dataSource.count)
            {
                [self.tableView.mj_header beginRefreshing];
            }
        }
    }
    else if (status == SPSDKModifyOrderStatusDelete)
    { // 删除订单
        [self.dataSource removeObjectAtIndex:section];
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationMiddle];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            if (!self.dataSource.count)
            {
                [self.tableView.mj_header beginRefreshing];
            }
        });
    }
    else
    { // 确认收货
        if (_state == SPSDKOrderStatusAll)
        {// 全部订单列表：变成完成订单
            SPSDKOrder *order = self.dataSource[section];
            order.orderStatus = SPSDKOrderFinished;
            [self.tableView reloadData];
        }
        else
        {// 待收货列表：remove
            [self.dataSource removeObjectAtIndex:section];
            [self.tableView reloadData];
            if (!self.dataSource.count)
            {
                [self.tableView.mj_header beginRefreshing];
            }
        }
    }
}

/**
 支付订单
 */
- (void)payOrder:(SPSDKOrder *)order payType:(SPSDKPayType)payType section:(NSInteger)section
{
    if (order.freeOfCharge)
    {
        [self payResultWithOrder:order clientPayStatus:SPSDKClientPayStatusSuccess section:section];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [ShopSDK payWithOrder:order payType:payType result:^(SPSDKClientPayStatus clientPayStatus, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self payResultWithOrder:order clientPayStatus:clientPayStatus section:section];
            
        }];
    }
}

/**
 进行自定义支付
 */
- (void)startCustomPay
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SPSDKUINeedCustomPayNotification" object:self.customPayOrder];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleCustomPayNotification:) name:@"SPSDKUICustomPayResultNotification"
                                               object:nil];
}

- (void)cleanTimer
{
    if ([self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)queryCustomPayResultTimeOut
{
    self.checkTimeOut = YES;
    self.hasResult = YES;
    //超时直接视为支付失败
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self handlerPayResult:SPSDKPayResultFail];
}

- (void)queryCustomPayResult:(SPSDKClientPayStatus)result
{
    self.hasResult = NO;
    self.checkTimeOut = NO;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10
                                                  target:self
                                                selector:@selector(queryCustomPayResultTimeOut)
                                                userInfo:nil
                                                 repeats:NO];
    
    dispatch_queue_t que = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(que, ^{
        
        for (int i = 0; i < 5; i++)
        {
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            if (weakSelf.hasResult)
            {
                dispatch_semaphore_signal(sema);
                break;
            }
            
            
            if (!weakSelf.checkTimeOut)
            {
                //每次距离上次查询延时2s。
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [ShopSDK queryOrderTradingResultWithOrder:weakSelf.customPayOrder
                                                      payMode:SPSDKPayModeCustom
                                              clientPayStatus:result
                                                       result:^(SPSDKPayResult payResult, NSError *error) {
                                                           
                                                           
                                                           
                                                           if (!weakSelf.checkTimeOut)
                                                           {
                                                               if (!error)
                                                               {
                                                                   
                                                                   if (payResult != SPSDKPayResultPaying)
                                                                   {
                                                                       //一旦有结果立刻停止计时
                                                                       [weakSelf cleanTimer];
                                                                       [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                                       [weakSelf handlerPayResult:payResult];
                                                                       weakSelf.hasResult = YES;
                                                                   }
                                                                   
                                                                   if (payResult == SPSDKPayResultSuccess)
                                                                   {
                                                                       [weakSelf pushPaySuccessVCWithOrder:weakSelf.customPayOrder];
                                                                       [weakSelf paySuccessWithSection:weakSelf.customPaySection];
                                                                   }
                                                                   
                                                               }
                                                               else
                                                               {
                                                                   [weakSelf cleanTimer];
                                                                   [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                                   [weakSelf handlerPayResult:SPSDKPayResultFail];
                                                                   weakSelf.hasResult = YES;
                                                                   [MBProgressHUD showTitle:error.message];
                                                               }
                                                               
                                                           }
                                                           
                                                           dispatch_semaphore_signal(sema);
                                                           
                                                       }];
                    
                });
                
            }
            else
            {
                dispatch_semaphore_signal(sema);
            }
            
        }
        
    });
    
    dispatch_async(que, ^{
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        if (!weakSelf.hasResult)
        {
            [weakSelf cleanTimer];
            weakSelf.checkTimeOut = YES;
            weakSelf.hasResult = YES;
            //超次数直接视为支付失败，MBProgress必须在主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [weakSelf handlerPayResult:SPSDKPayResultFail];
            });
        }
        
        dispatch_semaphore_signal(sema);
    });
    
}

- (void)handleCustomPayNotification:(NSNotification *)notif
{

    SPSDKClientPayStatus result = [notif.object[@"clientPayResult"] unsignedIntegerValue];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"SPSDKUICustomPayResultNotification"
                                                  object:nil];
    
    [self queryCustomPayResult:result];
}

- (void)payResultWithOrder:(SPSDKOrder *)order clientPayStatus:(SPSDKClientPayStatus)clientPayStatus section:(NSInteger)section
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ShopSDK queryOrderTradingResultWithOrder:order
                                      payMode:SPSDKPayModeMobPay
                              clientPayStatus:clientPayStatus
                                       result:^(SPSDKPayResult payResult, NSError *error) {
                                           
                                           [MBProgressHUD hideHUDForView:self.view animated:YES];
                                           if (!error)
                                           {
                                               [self handlerPayResult:payResult];
                                               if (payResult == SPSDKPayResultSuccess)
                                               {
                                                   [self pushPaySuccessVCWithOrder:order];
                                                   [self paySuccessWithSection:section];
                                               }
                                           }
                                           else
                                           {
                                               [MBProgressHUD showTitle:error.message];
                                           }
                                           [self.payView hide];
                                       }];
}

- (void)handlerPayResult:(SPSDKPayResult)payResult
{
    switch (payResult) {
        case SPSDKPayResultSuccess:
            {
                [MBProgressHUD showTitle:@"订单支付成功"];
            }
            break;
            
        case SPSDKPayResultFail:
        {
            [MBProgressHUD showTitle:@"订单支付失败"];
        }
            break;
            
        case SPSDKPayResultCancel:
        {
            [MBProgressHUD showTitle:@"订单取消支付"];
        }
            break;
        case SPSDKPayResultPaying:
        {
            [MBProgressHUD showTitle:@"订单仍在支付中"];
        }
            break;
        default:
            break;
    }
}

/**
 支付成功
 */
- (void)paySuccessWithSection:(NSInteger)section
{
    if (_state == SPSDKOrderStatusAll)
    {// 全部订单列表：变成待发货
        SPSDKOrder *order = self.dataSource[section];
        order.orderStatus = SPSDKOrderUnDelivery;
        [self.tableView reloadData];
    }
    else
    {// 待收货列表：remove
        [self.dataSource removeObjectAtIndex:section];
        [self.tableView reloadData];
        if (!self.dataSource.count)
        {
            [self.tableView.mj_header beginRefreshing];
        }
    }
}

- (void)pushPaySuccessVCWithOrder:(SPSDKOrder *)order
{
    SPSDKPaySuccessViewController *paySuccessVC = [[SPSDKPaySuccessViewController alloc] initWithOrder:order isOrderDetail:NO];
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}

@end
