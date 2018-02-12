//
//  SPSDKOrderDetailViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKOrderDetailViewController.h"
#import "SPSDKOrderDetailCell.h"
#import "SPSDKAddressCell.h"
#import "SPSDKOrderDetailHeaderView.h"
#import "SPSDKOrderDetailFooterView.h"
#import "SPSDKLogisticsViewController.h"
#import "SPSDKAppraiseViewController.h"
#import "SPSDKApplyRefundViewController.h"
#import "SPSDKPayView.h"
#import "SPSDKTradingCommodity+SPSDKExtension.h"
#import "SPSDKRefundDetailViewController.h"
#import "SPSDKProductViewController.h"
#import "SPSDKPaySuccessViewController.h"
#import "SPSDKUIPayConfig.h"

static NSString *const SPSDKOrderDetailCellId = @"SPSDKOrderDetailCell";
static NSString *const SPSDKAddressCellId = @"SPSDKAddressCell";

@interface SPSDKOrderDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet SPSDKGroupTableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) SPSDKOrderDetailHeaderView *headerView;
@property (nonatomic, weak) SPSDKOrderDetailFooterView *footerView;
@property (nonatomic, assign) UInt64 orderId;
@property (nonatomic, strong) SPSDKOrder *order;
@property (nonatomic, strong) SPSDKOrder *detailOrder;
@property (nonatomic, strong) SPSDKPayView *payView;
@property (nonatomic, strong) SPSDKOrder *customPayOrder;
@property (nonatomic, assign) BOOL checkTimeOut;
@property (nonatomic, assign) BOOL hasResult;
@property (nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation SPSDKOrderDetailViewController

- (SPSDKPayView *)payView
{
    if (!_payView)
    {
        _payView = [[SPSDKPayView alloc] init];
    }
    return _payView;
}

- (instancetype)initWithOrder:(SPSDKOrder *)order
{
    self = [super init];
    if (self)
    {
        _order = order;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bottomConstraint.constant = SPSDKiPhoneX ? 34.f : 0.f;
    
    self.title = @"订单详情";
    
    [self configureUI];

    [self requestData];
}

- (void)requestData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ShopSDK getOrderDetailWithOrder:_order result:^(SPSDKOrder *order, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error)
        {
            for (SPSDKTradingCommodity *tradingCommodity in order.orderCommodityList)
            {
                tradingCommodity.commodityStatus = tradingCommodity.commodity.status;
            }
            self.barView.hidden = NO;
            self.footerView.hidden = NO;
            self.headerView.hidden = NO;
            _detailOrder = order;
            _priceLabel.attributedText = [self priceStringWithTotalPrice:order.paidMoney];
            _footerView.model = order;
            [self.tableView reloadData];
            self.headerView.order = order;
            [self configureBtn];
        }
        else
        {
            [MBProgressHUD showTitle:error.message];
        }
    }];
}

- (NSAttributedString *)priceStringWithTotalPrice:(NSInteger)totalPrice
{
    NSString *priceStr = [NSString stringWithFormat:@"实付款：￥%.2f", totalPrice / 100.f];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attributedStr addAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] } range:NSMakeRange(0, 4)];
    [attributedStr addAttributes:@{ NSForegroundColorAttributeName : SPSDKMainColor } range:NSMakeRange(4, priceStr.length - 4)];
    return [attributedStr copy];
}

- (void)configureUI
{
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGFLOAT_MIN)];

    self.btn1.layer.cornerRadius = 2.f;
    self.btn1.layer.masksToBounds = YES;
    self.btn1.layer.borderWidth = 1.f;
    
    self.btn2.layer.cornerRadius = 2.f;
    self.btn2.layer.masksToBounds = YES;
    self.btn2.layer.borderWidth = 1.f;
    
    self.btn3.layer.cornerRadius = 2.f;
    self.btn3.layer.masksToBounds = YES;
    self.btn3.layer.borderWidth = 1.f;
    self.btn3.hidden = YES;
    
    [self.tableView registerNib:[SPSDKAddressCell loadNib] forCellReuseIdentifier:SPSDKAddressCellId];
    self.tableView.estimatedRowHeight = 100.f;
    
    self.barView.hidden = YES;
    
    SPSDKOrderDetailHeaderView *headerView = [SPSDKOrderDetailHeaderView loadInstanceFromNib];
    headerView.autoresizingMask = UIViewAutoresizingNone;
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    self.headerView.hidden = YES;
    
    SPSDKOrderDetailFooterView *footerView = [SPSDKOrderDetailFooterView loadInstanceFromNib];
    footerView.autoresizingMask = UIViewAutoresizingNone;
    self.tableView.tableFooterView = footerView;
    self.footerView = footerView;
    self.footerView.hidden = YES;
}

- (void)configureBtn
{
    switch (_detailOrder.status)
    {
        case SPSDKOrderCanceled:
        {
            self.btn3.hidden = YES;
            self.btn2.hidden = YES;
            self.btn1.hidden = NO;
            [self setButton:self.btn1 title:@"删除订单" color:SPSDKTextColor];
            break;
        }
        case SPSDKOrderUnpaid:
        {
            self.btn3.hidden = YES;
            self.btn2.hidden = NO;
            self.btn1.hidden = NO;
            [self setButton:self.btn1 title:@"付款" color:SPSDKMainColor];
            [self setButton:self.btn2 title:@"取消订单" color:SPSDKTextColor];
            break;
        }
        case SPSDKOrderUnDelivery:
        {
            self.btn3.hidden = YES;
            self.btn2.hidden = YES;
            self.btn1.hidden = YES;
            break;
        }
        case SPSDKOrderUnReceive:
        {
            self.btn3.hidden = YES;
            self.btn2.hidden = NO;
            self.btn1.hidden = NO;
            [self setButton:self.btn1 title:@"确认收货" color:SPSDKMainColor];
            [self setButton:self.btn2 title:@"查看物流" color:SPSDKTextColor];
            break;
        }
        case SPSDKOrderFinished:
        {
            if (_detailOrder.commentCount)
            {
                self.btn3.hidden = YES;
            }
            else
            {
                self.btn3.hidden = NO;
                [self setButton:self.btn3 title:@"评价" color:SPSDKTextColor];
            }
            self.btn2.hidden = NO;
            self.btn1.hidden = NO;
            [self setButton:self.btn1 title:@"删除订单" color:SPSDKTextColor];
            [self setButton:self.btn2 title:@"查看物流" color:SPSDKTextColor];
            break;
        }
        default:
            break;
    }
}

- (void)setButton:(UIButton *)btn title:(NSString *)title color:(UIColor *)color
{
    [btn setTitle:title forState:UIControlStateNormal];
    btn.layer.borderColor = color.CGColor;
    [btn setTitleColor:color forState:UIControlStateNormal];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY < 0)
    {
        self.headerView.bgTopConstraint.constant = offsetY;
        [self.headerView layoutIfNeeded];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_detailOrder.orderCommodityList.count == 0)
    {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    return _detailOrder.orderCommodityList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        SPSDKAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKAddressCellId forIndexPath:indexPath];
        cell.model = _detailOrder.shippingAddrInfo;
        cell.arrowImageV.hidden = YES;
        return cell;
    }
    else
    {
        SPSDKOrderDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKOrderDetailCellId];
        if (!cell)
        {
            cell = [SPSDKOrderDetailCell loadInstanceFromNib];
        }
        cell.indexPath = indexPath;
        cell.isLast = indexPath.row == 1;
        cell.model = _detailOrder.orderCommodityList[indexPath.row];
        cell.status = _detailOrder.status;
        cell.refundHandler = ^(SPSDKTradingCommodity *model, NSIndexPath *index) {
            if (model.commodityStatus == SPSDKCommodityStatusNomal)
            {
                SPSDKApplyRefundViewController *applyVC = [[SPSDKApplyRefundViewController alloc] initWithOrderCommodity:_detailOrder.orderCommodityList[indexPath.row] isModify:NO];
                applyVC.indexPath = index;
                applyVC.refundHandler = ^(NSIndexPath *indexPath) {
                    SPSDKTradingCommodity *commodity = _detailOrder.orderCommodityList[indexPath.row];
                    commodity.commodityStatus = SPSDKCommodityStatusRefunding;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:applyVC animated:YES];
            }
            else
            {
                SPSDKRefundDetailViewController *refundDetailVC = [[SPSDKRefundDetailViewController alloc] initWithOrderCommodity:model];
                [self.navigationController pushViewController:refundDetailVC animated:YES];
            }
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return UITableViewAutomaticDimension;
    }
    else
    {
        return 115.f;
    }
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
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        SPSDKTradingCommodity *tradingCommodity = _detailOrder.orderCommodityList[indexPath.row];
        SPSDKProductViewController *productVC = [[SPSDKProductViewController alloc] initWithProduct:tradingCommodity.product];
        [self.navigationController pushViewController:productVC animated:YES];
    }
}

- (IBAction)onAction:(UIButton *)sender
{
    NSInteger btnIndex = sender.tag;
    switch (_detailOrder.status)
    {
        case SPSDKOrderUnReceive: // 已发货
        {
            if (btnIndex == 1) // 确认收货
            {
                [self modifyOrderStatus:SPSDKModifyOrderStatusReceived];
            }
            else if (btnIndex == 2) // 查看物流
            {
                SPSDKLogisticsViewController *logisticsVC = [[SPSDKLogisticsViewController alloc] initWithTransport:_detailOrder.transport type:SPSDKLogisticsTypeProduct];
                [self.navigationController pushViewController:logisticsVC animated:YES];
            }
        }
            break;
            
        case SPSDKOrderUnpaid: // 待付款
        {
            if (btnIndex == 1)
            { // 付款
                if (_detailOrder.freeOfCharge)
                {
                    [self payOrder:_detailOrder payType:0];
                }
                else
                {
                    if ([SPSDKUIPayConfig defaultConfig].payMode == 0)
                    {
                        self.payView.order = _detailOrder;
                        [self.payView show];
                        __weak typeof(self) weakSelf = self;
                        self.payView.payHandler = ^(SPSDKOrder *order, SPSDKPayType payType, float price) {
                            [weakSelf payOrder:order payType:payType];
                        };
                    }
                    else
                    {
                        self.customPayOrder = _detailOrder;
                        [self startCustomPay];
                    }
                    
                }
            }
            else
            { // 取消订单
                [self modifyOrderStatus:SPSDKModifyOrderStatusCancel];
            }
        }
            break;
            
        case SPSDKOrderFinished: // 已完成
        {
            if (btnIndex == 1) // 删除订单
            {
                [self modifyOrderStatus:SPSDKModifyOrderStatusDelete];
            }
            else if (btnIndex == 2) // 查看物流
            {
                SPSDKLogisticsViewController *logisticsVC = [[SPSDKLogisticsViewController alloc] initWithTransport:_detailOrder.transport type:SPSDKLogisticsTypeProduct];
                [self.navigationController pushViewController:logisticsVC animated:YES];
            }
            else // 评价
            {
                SPSDKAppraiseViewController *appraiseVC = [[SPSDKAppraiseViewController alloc] initWithOrder:_detailOrder];
                appraiseVC.indexSection = _indexPath.section;
                appraiseVC.appraiseHandler = ^(NSInteger section) {
                    self.btn3.hidden = YES;
                    if (self.appraiseHandler)
                    {
                        self.appraiseHandler(_indexPath.section);
                    }
                };
                [self.navigationController pushViewController:appraiseVC animated:YES];
            }
        }
            break;
            
        case SPSDKOrderCanceled: // 已取消
        {
            if (btnIndex == 1) // 删除订单
            {
                [self modifyOrderStatus:SPSDKModifyOrderStatusDelete];
            }
        }
            
        default:
            break;
    }
}

- (void)modifyOrderStatus:(SPSDKModifyOrderStatus)status
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
    [ShopSDK modifyOrderStatus:status order:_detailOrder result:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error)
        {
            [MBProgressHUD showTitle:successMsg];
            if (status == SPSDKModifyOrderStatusDelete)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self requestData];
            }
            
            if (self.modifyHandler)
            {
                self.modifyHandler(_indexPath.section, status);
            }
        }
        else
        {
            [MBProgressHUD showTitle:error.message];
        }
    }];
}

- (void)payOrder:(SPSDKOrder *)order payType:(SPSDKPayType)payType
{
    if (order.freeOfCharge)
    {
        [self payResultWithOrder:order clientPayStatus:SPSDKClientPayStatusSuccess];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [ShopSDK payWithOrder:order payType:payType result:^(SPSDKClientPayStatus clientPayStatus, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self payResultWithOrder:order clientPayStatus:clientPayStatus];
            
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //超时直接视为支付失败
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
                                                                       [weakSelf requestData];
                                                                       [weakSelf pushPaySuccessVCWithOrder:weakSelf.customPayOrder];
                                                                       if (weakSelf.payHandler)
                                                                       {
                                                                           weakSelf.payHandler(_indexPath.section);
                                                                       }
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

- (void)payResultWithOrder:(SPSDKOrder *)order clientPayStatus:(SPSDKClientPayStatus)clientPayStatus
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
                                                   [self requestData];
                                                   [self pushPaySuccessVCWithOrder:order];
                                                   if (self.payHandler)
                                                   {
                                                       self.payHandler(_indexPath.section);
                                                   }
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
            
        default:
            break;
    }
}

- (void)pushPaySuccessVCWithOrder:(SPSDKOrder *)order
{
    SPSDKPaySuccessViewController *paySuccessVC = [[SPSDKPaySuccessViewController alloc] initWithOrder:order isOrderDetail:YES];
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}

@end
