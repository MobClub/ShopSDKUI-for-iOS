//
//  SPSDKConfirmOrderViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/5.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKConfirmOrderViewController.h"
#import "SPSDKShopCartCell.h"
#import "SPSDKShopBarView.h"
#import "SPSDKAddressCell.h"
#import "SPSDKConfirmCell.h"
#import "SPSDKAddressViewController.h"
#import "SPSDKCouponViewController.h"
#import "SPSDKAddAddressCell.h"
#import "SPSDKPayView.h"
#import "SPSDKPaySuccessViewController.h"
#import "SPSDKUIPayConfig.h"
#import <MOBFoundation/MOBFApplication.h>
#import "SPSDKSelectCouponRootViewController.h"

static NSString *const SPSDKShopCartCellId = @"SPSDKShopCartCell";
static NSString *const SPSDKAddressCellId = @"SPSDKAddressCell";
static NSString *const SPSDKConfirmCellId = @"SPSDKConfirmCell";
static NSString *const SPSDKAddAddressCellId = @"SPSDKAddAddressCell";

@interface SPSDKConfirmOrderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet SPSDKGroupTableView *tableView;
@property (weak, nonatomic) IBOutlet SPSDKShopBarView *barView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, assign) float totalPrice;
@property (nonatomic, strong) SPSDKPreOrder *preOrder;
@property (nonatomic, copy) NSArray *couponList;
@property (nonatomic, strong) SPSDKPayView *payView;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) BOOL enableCoupon;
@property (nonatomic, assign) BOOL needReload;
@property (nonatomic, strong) SPSDKOrder *customPayOrder;
@property (nonatomic, assign) BOOL checkTimeOut;
@property (nonatomic, assign) BOOL hasResult;
@property (nonatomic, strong) NSTimer *timer;
/**
 预订单后台返回的地址
 */
@property (nonatomic, strong) SPSDKShippingAddress *preAddress;

/**
 用户自己选择的地址
 */
@property (nonatomic, strong) SPSDKShippingAddress *selectAddress;

@end

@implementation SPSDKConfirmOrderViewController

- (instancetype)initWithSelectProducts:(NSArray <SPSDKTradingCommodity *> *)selectProducts totalPrice:(float)totalPrice
{
    self = [super init];
    if (self)
    {
        _dataSource = selectProducts;
        _totalPrice = totalPrice;
    }
    return self;
}

- (NSArray *)couponList
{
    if (!_couponList)
    {
        _couponList = [NSArray array];
    }
    return _couponList;
}

- (SPSDKPayView *)payView
{
    if (!_payView)
    {
        _payView = [[SPSDKPayView alloc] init];
    }
    return _payView;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_needReload)
    {
        _needReload = NO;
        [self requestData];
    }
}

- (void)refreshAddress
{
    _needReload = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bottomConstraint.constant = SPSDKiPhoneX ? 34.f : 0.f;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshAddress)
                                                 name:SPSDKRefreshAddressNotif
                                               object:nil];
    
    _enableCoupon = YES;
    
    __weak typeof(self) weakSelf = self;

    self.payView.cancelHandler = ^(SPSDKOrder *order) {
        [weakSelf.navigationController popViewControllerAnimated:NO];
        if (weakSelf.payResultHandler)
        {
            weakSelf.payResultHandler(order, NO);
        }
    };
    
    self.payView.payHandler = ^(SPSDKOrder *order, SPSDKPayType payType, float price) {
        [weakSelf payWithOrder:order payType:payType];
    };
    
    self.title = @"确认订单";
    
    self.barView.hiddenSelectBtn = YES;
    self.barView.btnTitle = @"提交订单";
    self.barView.hidden = YES;
    
    self.barView.payHandler = ^{
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        SPSDKConfirmCell *cell = (SPSDKConfirmCell *)[strongSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:strongSelf.preOrder.orderCommodityList.count inSection:1]];
        
        if (strongSelf.preOrder.status == SPSDKPreOrderStatusNomal)
        {
            [MBProgressHUD showHUDAddedTo:strongSelf.view animated:YES];
            
            [ShopSDK createOrderWithPreOrder:strongSelf.preOrder
                                 buyerRemark:cell.textField.text
                                      result:^(SPSDKOrder *order, NSError *error) {
                                          [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                          if (!error)
                                          {
                                              if (order.freeOfCharge)
                                              {
                                                  [strongSelf payWithOrder:order payType:0];
                                              }
                                              else
                                              {
                                                  if ([SPSDKUIPayConfig defaultConfig].payMode == 0)
                                                  {
                                                      strongSelf.payView.order = order;
                                                      [strongSelf.payView show];
                                                  }
                                                  else
                                                  {
                                                      self.customPayOrder = order;
                                                      [strongSelf startCustomPay];
                                                  }
                                                  
                                              }
                                          }
                                          else
                                          {
                                              [MBProgressHUD showTitle:error.message];
                                          }
                                      }];

        }
        else if (_preOrder.status == SPSDKPreOrderAddressError)
        {
            [MBProgressHUD showTitle:@"地址错误"];
        }
        else
        {
            [MBProgressHUD showTitle:@"存在问题商品"];
        }
    };
    
    [self.tableView registerNib:[SPSDKAddressCell loadNib] forCellReuseIdentifier:SPSDKAddressCellId];
    self.tableView.estimatedRowHeight = 80.f;
    
    [self requestData];
}

- (void)handlerPayResult:(SPSDKPayResult)payResult order:(SPSDKOrder *)order
{
    BOOL res = NO;
    switch (payResult) {
        case SPSDKPayResultSuccess:
        {
            res = YES;
            [MBProgressHUD showTitle:@"订单支付成功"];
        }
            break;
            
        case SPSDKPayResultFail:
        {
            res = NO;
            [MBProgressHUD showTitle:@"订单支付失败"];
        }
            break;
            
        case SPSDKPayResultCancel:
        {
            res = NO;
            [MBProgressHUD showTitle:@"订单取消支付"];
        }
            break;
            
        case SPSDKPayResultPaying:
        {
            res = NO;
            [MBProgressHUD showTitle:@"订单仍在支付中"];
        }
            break;
        default:
            break;
    }
    
    [self.navigationController popViewControllerAnimated:NO];
    if (self.payResultHandler)
    {
        self.payResultHandler(order, res);
    }
}

- (void)payWithOrder:(SPSDKOrder *)order payType:(NSInteger)payType
{
    if (order.freeOfCharge)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
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
    [self handlerPayResult:SPSDKPayResultFail order:self.customPayOrder];
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
                                                                       weakSelf.hasResult = YES;
                                                                       [weakSelf cleanTimer];
                                                                       [weakSelf handlerPayResult:payResult order:weakSelf.customPayOrder];
                                                                       [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                                   }
                                                                   
                                                               }
                                                               else
                                                               {
                                                                   weakSelf.hasResult = YES;
                                                                   [weakSelf cleanTimer];
                                                                   [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                                                                   [MBProgressHUD showTitle:error.message];
                                                                   [weakSelf handlerPayResult:SPSDKPayResultFail order:weakSelf.customPayOrder];
                                                                   
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
                [weakSelf handlerPayResult:SPSDKPayResultFail order:weakSelf.customPayOrder];
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
                                               [self handlerPayResult:payResult order:order];
                                           }
                                           else
                                           {
                                               [MBProgressHUD showTitle:error.message];
                                           }
                                           [self.payView hide];
                                       }];
}

- (void)requestData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ShopSDK preOrderWithAddress:_selectAddress
                   commodityList:_dataSource
                      couponList:_couponList
                    enableCoupon:_enableCoupon
                          result:^(SPSDKPreOrder *preOrder, NSError *error) {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              if (!error)
                              {
                                  if (_barView.hidden)
                                  {
                                      _barView.hidden = NO;
                                  }
                                  _count = 4;
                                  _preOrder = preOrder;
                                  _preAddress = preOrder.shippingAddrInfo;
                                  _couponList = preOrder.couponsList;
                                  
                                  self.barView.totalPrice = preOrder.paidMoney / 100.f;
                                  [self.tableView reloadData];
                                  
                                  if (preOrder.status == SPSDKPreOrderAddressError || preOrder.status == SPSDKPreOrderCommodityError)
                                  {
                                      if (preOrder.status == SPSDKPreOrderAddressError)
                                      {
                                          [MBProgressHUD showTitle:@"请添加收货地址"];
                                      }
                                      else
                                      {
                                          [MBProgressHUD showTitle:@"预订单存在异常商品"];
                                      }
                                      self.barView.payBtnEnable = NO;
                                  }
                                  else
                                  {
                                      self.barView.payBtnEnable = YES;
                                  }
                              }
                              else
                              {
                                  [MBProgressHUD showTitle:error.message];
                              }
                          }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else if (section == 1)
    {
        return _preOrder.orderCommodityList.count + 1;
    }
    else if (section == 2)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (_preAddress.shippingAddrId)
        {
            SPSDKAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKAddressCellId forIndexPath:indexPath];
            cell.model = _preAddress;
            return cell;
        }
        else
        {
            SPSDKAddAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKAddAddressCellId];
            if (!cell)
            {
                cell = [SPSDKAddAddressCell loadInstanceFromNib];
            }
            return cell;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row != _preOrder.orderCommodityList.count)
        {
            SPSDKShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKShopCartCellId];
            if (!cell)
            {
                cell = [SPSDKShopCartCell loadInstanceFromNib];
            }
            cell.hiddenSelectBtn = YES;
            cell.isEditing = NO;
            cell.model = _preOrder.orderCommodityList[indexPath.row];
            return cell;
        }
        else
        {
            SPSDKConfirmCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKConfirmCellId];
            if (!cell)
            {
                cell = [SPSDKConfirmCell loadInstanceFromNib];
            }
            cell.hasTextField = YES;
            cell.title = @"买家留言：";
            return cell;
        }
    }
    else if (indexPath.section == 2)
    {
        SPSDKConfirmCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKConfirmCellId];
        if (!cell)
        {
            cell = [SPSDKConfirmCell loadInstanceFromNib];
        }
        cell.hiddenArrow = NO;
        cell.title = @"使用优惠券";
        if (!_preOrder.totalCoupon)
        {
            cell.detailTitle = @"暂无可用的优惠券";
            cell.detailLabel.textColor = SPSDKTextColor;
        }
        else
        {
            cell.detailLabel.textColor = SPSDKMainColor;
            cell.detailTitle = [NSString stringWithFormat:@"-%.2f", _preOrder.totalCoupon / 100.f];
        }
        return cell;
    }
    else
    {
        SPSDKConfirmCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKConfirmCellId];
        if (!cell)
        {
            cell = [SPSDKConfirmCell loadInstanceFromNib];
        }
        cell.hiddenArrow = YES;
        
        if (indexPath.row == 0)
        {
            cell.title = @"运费";
            cell.detailTitle = _preOrder.totalFreight < 0 ? nil : [NSString stringWithFormat:@"￥%.2f", _preOrder.totalFreight / 100.f];
        }
        else
        {
            cell.title = @"商品金额";
            cell.detailTitle = [NSString stringWithFormat:@"￥%.2f", _preOrder.totalMoney / 100.f];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (_preAddress.shippingAddrId)
        {
            return UITableViewAutomaticDimension;
        }
        else
        {
            return 44.f;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == _preOrder.orderCommodityList.count)
        {
            return 42;
        }
        else
        {
            return 115;
        }
    }
    else
    {
        return 42;
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
    if (indexPath.section == 0)
    {
        SPSDKAddressViewController *address = [[SPSDKAddressViewController alloc] init];
        address.selectAddressHandler = ^(SPSDKShippingAddress *address) {
            self.selectAddress = address;
            self.preAddress = address;
            [tableView reloadData];
            [self requestData];
        };
        [self.navigationController pushViewController:address animated:YES];
    }
    else if (indexPath.section == 2)
    {
        SPSDKSelectCouponRootViewController *coupon = [[SPSDKSelectCouponRootViewController alloc] init];
        coupon.commodityList = _preOrder.orderCommodityList;
        coupon.coupon = _couponList.firstObject;
        coupon.selectCouponHandler = ^(SPSDKCoupon *model) {
            
            if (model)
            {
                self.couponList = @[model];
                _enableCoupon = YES;
            }
            else
            {
                _enableCoupon = NO;
            }
            
            [self requestData];
        };
        [self.navigationController pushViewController:coupon animated:YES];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"Confirm dealloc");
}

@end
