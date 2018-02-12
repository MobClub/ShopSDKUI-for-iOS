//
//  SPSDKShoppingCartViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/4.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKShoppingCartViewController.h"
#import "SPSDKShopCartCell.h"
#import "SPSDKShopBarView.h"
#import "SPSDKConfirmOrderViewController.h"
#import "SPSDKChooseView.h"
#import "SPSDKProductViewController.h"
#import "SPSDKTradingCommodity+SPSDKExtension.h"
#import "SPSDKOrderDetailViewController.h"
#import <UMSSDK/UMSSDK.h>
#import "SPSDKLoginManager.h"
#import "SPSDKPaySuccessViewController.h"

static NSString *const SPSDKShopCartCellId = @"SPSDKShopCartCell";

@interface SPSDKShoppingCartViewController () <UITableViewDataSource,
                                               UITableViewDelegate,
                                               SPSDKShopCartCellDelegate,
                                               UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet SPSDKTableView *tableView;
@property (weak, nonatomic) IBOutlet SPSDKShopBarView *barView;
@property (nonatomic, strong) NSMutableArray <SPSDKTradingCommodity *> *dataSource;
@property (nonatomic, assign) BOOL isEditing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barConstraint;
@property (nonatomic, assign) float totalPrice;
@property (nonatomic, strong) NSMutableArray <SPSDKTradingCommodity *> *selectProducts;
@property (nonatomic, strong) NSMutableArray *modifyDatas;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation SPSDKShoppingCartViewController

@synthesize dataSource = _dataSource;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _hasTabBar = YES;
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

- (NSMutableArray *)modifyDatas
{
    if (!_modifyDatas)
    {
        _modifyDatas = [NSMutableArray array];
    }
    return _modifyDatas;
}

- (NSMutableArray *)selectProducts
{
    if (!_selectProducts)
    {
        _selectProducts = [NSMutableArray array];
    }
    return _selectProducts;
}

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    
    if (self.dataSource.count == 0)
    {
        self.barConstraint.constant = 0.f;
    }
    else
    {
        self.barConstraint.constant = 45.f;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"购物车";
    
    if (!_hasTabBar)
    {
        self.bottomConstraint.constant = SPSDKiPhoneX ? 34.f : 0.f;
    }
    
    [self createNavigatioItem:SPSDKNavItemTypeTitle name:@"管理" isLeft:NO];
    [self.rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    
    __weak typeof(self) weakSelf = self;
    self.barView.payHandler = ^{
        
        if (!weakSelf.isEditing)
        {
            if (weakSelf.selectProducts.count)
            {
                if (![UMSSDK currentUser])
                {
                    [[SPSDKLoginManager sharedInstance] loginAtViewController:weakSelf handler:nil];
                    return ;
                }
                
                SPSDKConfirmOrderViewController *confirmOrder = [[SPSDKConfirmOrderViewController alloc] initWithSelectProducts:weakSelf.selectProducts totalPrice:weakSelf.totalPrice];
                confirmOrder.payResultHandler = ^(SPSDKOrder *order, BOOL isSuccess) {
                    
                    if (!_hasTabBar)
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:SPSDKRefreshShoppingCartNotif object:nil];
                    }
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.tableView.mj_header beginRefreshing];
                    });
                    if (!isSuccess)
                    {
                        SPSDKOrderDetailViewController *orderDetailVC = [[SPSDKOrderDetailViewController alloc] initWithOrder:order];
                        [weakSelf.navigationController pushViewController:orderDetailVC animated:YES];
                    }
                    else
                    {
                        [weakSelf pushPaySuccessVCWithOrder:order];
                    }
                };
                [weakSelf.navigationController pushViewController:confirmOrder animated:YES];
            }
            else
            {
                [MBProgressHUD showTitle:@"您还没有选择宝贝哦"];
            }
        }
        else
        {
            if (weakSelf.selectProducts.count)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"确认将这%@个宝贝删除？", @(weakSelf.selectProducts.count)] message:nil delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
            else
            {
                [MBProgressHUD showTitle:@"您还没有选择宝贝哦"];
            }
        }
    };
    
    self.barView.selectAllHandler = ^(BOOL isAll) {
        
        [weakSelf doSelectAll:isAll];
        
    };
    
    [self refresh];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShopCart) name:SPSDKRefreshShoppingCartNotif object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShopCart) name:SPSDKLogoutNotif object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateShopCart) name:SPSDKLoginNotif object:nil];
}

- (void)pushPaySuccessVCWithOrder:(SPSDKOrder *)order
{
    SPSDKPaySuccessViewController *paySuccessVC = [[SPSDKPaySuccessViewController alloc] initWithOrder:order isOrderDetail:NO];
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}

- (void)configureTipView
{
    if (self.dataSource.count == 0)
    {
        self.barConstraint.constant = 0.f;
    }
    [self.view configureTipViewWithTipMessage:@"购物车还没有商品哦\n快去添加吧"
                                      hasData:self.dataSource.count
                                  noDataImage:[UIImage imageNamed:@"empty_shopcart"]];
}

- (void)updateShopCart
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)refresh
{
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestDataWithMB:NO];
    }];

    [self.tableView.mj_header beginRefreshing];
}

- (void)requestDataWithMB:(BOOL)hasMB
{
    if (hasMB)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    [ShopSDK getShoppingCartItems:^(NSArray<SPSDKTradingCommodity<SPSDKShoppingCartCommodity> *> *shoppingCartCommodityList, NSError *error) {
        
        if (hasMB)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
        if (!error)
        {
            for (SPSDKTradingCommodity *tradingCommodity in shoppingCartCommodityList)
            {
                tradingCommodity.selected = YES;
            }
            self.dataSource = [NSMutableArray arrayWithArray:shoppingCartCommodityList];
            [self calculateTotalPrice];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        else
        {
            [MBProgressHUD showTitle:error.message];
            [self.tableView.mj_header endRefreshing];
        }
        
        [self.view configureTipViewWithTipMessage:@"购物车还没有商品哦\n快去添加吧"
                                          hasData:self.dataSource.count
                                      noDataImage:[UIImage imageNamed:@"empty_shopcart"]];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [ShopSDK deleteFromShoppingCart:self.selectProducts result:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!error)
            {
                self.isEditing = NO;
                self.rightBtn.selected = NO;
                [self.dataSource removeObjectsInArray:self.selectProducts];
                [self.selectProducts removeAllObjects];
                [self.tableView reloadData];
                
                [self configureTipView];
            }
            else
            {
                [MBProgressHUD showTitle:error.message];
            }
        }];
    }
}

- (void)doSelectAll:(BOOL)isAll
{
    if (isAll)
    { //全不选
        for (SPSDKTradingCommodity *model in self.dataSource)
        {
            model.selected = NO;
        }
    }
    else
    { //全选
        for (SPSDKTradingCommodity *model in self.dataSource)
        {
            model.selected = YES;
        }
    }
    [self calculateTotalPrice];
    self.barView.isAll = [self currentIsAll];
    [self.tableView reloadData];
}

#pragma mark - 判断当前是否全选

- (BOOL)currentIsAll
{
    if (self.dataSource.count == 0)
    {
        return NO;
    }
    
    for (SPSDKTradingCommodity *model in self.dataSource)
    {
        if (model.commodity.status == SPSDKCommodityStatusNomal)
        {
            if (!model.selected)
            {
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - 计算价格

- (void)calculateTotalPrice
{
    float totalPrice = 0;
    
    for (SPSDKTradingCommodity *model in self.dataSource)
    {
        if (model.selected && model.commodity.status == SPSDKCommodityStatusNomal)
        {
            totalPrice += model.count * model.commodity.currentCost / 100.f;
        }
    }
    self.barView.isAll = [self currentIsAll];
    self.barView.totalPrice = totalPrice;
    
    if (self.selectProducts.count)
    {
        [self.selectProducts removeAllObjects];
    }
    for (SPSDKTradingCommodity *model in self.dataSource)
    {
        if (model.selected && model.commodity.status == SPSDKCommodityStatusNomal)
        {
            [self.selectProducts addObject:model];
        }
    }
    
    self.totalPrice = totalPrice;
}

#pragma mark - Action

- (void)onRightBtnAction:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    sender.selected = !sender.selected;
    
    _isEditing = sender.selected;
    
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.barView.hidden = !self.dataSource.count;
    self.rightBtn.hidden = !self.dataSource.count;
    self.barView.btnTitle = _isEditing ? @"删除" : @"去结算";
    self.barView.hiddenPrice = _isEditing;
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKShopCartCellId];
    if (!cell)
    {
        cell = [SPSDKShopCartCell loadInstanceFromNib];
    }
    [cell setLineLeftPadding:132 rightPadding:0];
    cell.indexPath = indexPath;
    cell.isEditing = _isEditing;
    cell.delegate = self;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        SPSDKTradingCommodity *model = self.dataSource[indexPath.row];
        [ShopSDK deleteFromShoppingCart:@[model] result:^(NSError *error) {
            if (error)
            {
                [MBProgressHUD showTitle:error.message];
            }
        }];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self calculateTotalPrice];
        self.barView.isAll = [self currentIsAll];
        [self configureTipView];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEditing)
    {
        return;
    }
    SPSDKTradingCommodity *tradingCommodity = self.dataSource[indexPath.row];
    SPSDKProductViewController *product = [[SPSDKProductViewController alloc] initWithProduct:tradingCommodity.product];
    [self.navigationController pushViewController:product animated:YES];
}

#pragma mark - SPSDKShopCartCellDelegate

- (void)cellForChooseIndexPath:(NSIndexPath *)indexPath
{
    SPSDKTradingCommodity *tradingCommodity = self.dataSource[indexPath.row];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ShopSDK getProductDetailWithProduct:tradingCommodity.product result:^(SPSDKProduct *product, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error)
        {
            SPSDKChooseView *chooseView = [[SPSDKChooseView alloc] initWithCountViewHidden:YES];
            chooseView.tradingCommodity = tradingCommodity;
            chooseView.model = product;
            __weak SPSDKChooseView *weakChooseView = chooseView;
            chooseView.refreshHandler = ^(NSError *addError, NSError *deleteError) {
                [self requestDataWithMB:YES];
                [weakChooseView hiddenAnimation];
            };
            [chooseView show];
        }
        else
        {
            [MBProgressHUD showTitle:error.message];
        }
    }];
}

- (void)cellForChangeNum:(NSInteger)num indexPath:(NSIndexPath *)indexPath
{
    SPSDKTradingCommodity *model = self.dataSource[indexPath.row];
    if (model.count == num)
    {
        return;
    }
    NSInteger orginalCount = model.count;
    model.count = num;
    [self calculateTotalPrice];
    [self.tableView reloadData];
    [ShopSDK modifyShoppingCartItemAmount:@[model] result:^(NSError *error) {
       
        if (error)
        {   // 修改失败再还原
            model.count = orginalCount;
            [self calculateTotalPrice];
            [self.tableView reloadData];
            [MBProgressHUD showTitle:error.message];
        }
    }];
}

- (void)cellForSelected:(BOOL)selected indexPath:(NSIndexPath *)indexPath
{
    SPSDKTradingCommodity *model = self.dataSource[indexPath.row];
    model.selected = selected;
    [self calculateTotalPrice];
    [self.tableView reloadData];
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
