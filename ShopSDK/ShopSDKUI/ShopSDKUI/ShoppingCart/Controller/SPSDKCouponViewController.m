//
//  SPSDKCouponViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/7.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKCouponViewController.h"
#import "SPSDKCouponCell.h"
#import "SPSDKCoupon+SPSDKExtension.h"
#import "SPSDKAllProductViewController.h"

static NSString *const SPSDKCouponCellId = @"SPSDKCouponCell";
static NSString *const SPSDKCouponRefreshNotif = @"CouponRefreshNotif";

@interface SPSDKCouponViewController ()

@property (weak, nonatomic) IBOutlet SPSDKTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) SPSDKCouponPageType type;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barHeight;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger count;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation SPSDKCouponViewController

- (instancetype)initWithType:(SPSDKCouponPageType)type
{
    self = [super init];
    if (self)
    {
        _type = type;
    }
    return self;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (_type == SPSDKCouponPageTypeSelectUse)
    {
        if (_count)
        {
            self.sureBtn.hidden = NO;
            self.barHeight.constant = 45.f;
        }
        else
        {
            self.sureBtn.hidden = YES;
            self.barHeight.constant = 0.f;
        }
    }
    else
    {
        self.sureBtn.hidden = YES;
        self.barHeight.constant = 0.f;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    self.bottomConstraint.constant = SPSDKiPhoneX ? 34.f : 0.f;
    
    if (_type == SPSDKCouponPageTypeGet)
    {
        self.title = @"领券中心";
    }
    else
    {
        [self.sureBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateNormal];
        [self.sureBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateHighlighted];
        if (_type == SPSDKCouponPageTypePersonal)
        {
            self.title = @"我的优惠券";
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(updateRefresh)
                                                         name:SPSDKCouponRefreshNotif
                                                       object:nil];
        }
        else
        {
            self.title = @"选择优惠券";
        }
    }
    
    [self refresh];
}

- (void)updateRefresh
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)refresh
{
    if (_type != SPSDKCouponPageTypeSelectUse && _type != SPSDKCouponPageTypeSelectUnuse) // 没有分页
    {
        __weak typeof(self) weakSelf = self;
        
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            weakSelf.pageIndex = 1;
            
            [weakSelf requesDataWithRefresh:YES];
            
        }];
        
        [self.tableView.mj_header beginRefreshing];
        
        self.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
            
            weakSelf.pageIndex ++;
            
            [weakSelf requesDataWithRefresh:NO];
            
        }];
    }
    else
    {
        [self configureRefreshDataWithCouponList:self.couponList error:nil];
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [ShopSDK getUsableCouponWithCommodityList:self.commodityList result:^(NSArray<SPSDKCoupon *> *couponList, NSError *error) {
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//            if (_coupon)
//            {
//                for (SPSDKCoupon *coupon in couponList)
//                {
//                    if (coupon.couponId == _coupon.couponId)
//                    {
//                        coupon.selected = YES;
//                    }
//                }
//            }
//
            _count = self.couponList.count;

            if (_count)
            {
                self.sureBtn.hidden = NO;
                self.barHeight.constant = 45.f;
            }
            else
            {
                self.sureBtn.hidden = YES;
                self.barHeight.constant = 0.f;
            }
//            [self configureRefreshDataWithCouponList:couponList error:error];
//        }];
    }
}

- (void)requesDataWithRefresh:(BOOL)isRefesh
{
    if (_type == SPSDKCouponPageTypeSelectUse || _type == SPSDKCouponPageTypeSelectUnuse)
    {
//        [ShopSDK getUsableCouponWithCommodityList:self.commodityList result:^(NSArray<SPSDKCoupon *> *couponList, NSError *error) {
//
//            if (_coupon)
//            {
//                for (SPSDKCoupon *coupon in couponList)
//                {
//                    if (coupon.couponId == _coupon.couponId)
//                    {
//                        coupon.selected = YES;
//                    }
//                }
//            }
//
//            _count = couponList.count;
//
//            if (_count)
//            {
//                self.sureBtn.hidden = NO;
//                self.barHeight.constant = 45.f;
//            }
//            else
//            {
//                self.sureBtn.hidden = YES;
//                self.barHeight.constant = 0.f;
//            }
//            [self configureRefreshDataWithCouponList:couponList error:error];
//        }];
    }
    else if (_type == SPSDKCouponPageTypePersonal)
    {
        [ShopSDK getCouponsWithStatus:_status
                             pageSize:SPSDKPageSize
                            pageIndex:_pageIndex
                               result:^(NSUInteger pageIndex, NSUInteger countNum, NSArray<SPSDKCoupon *> *couponList, NSError *error) {
                                   if (isRefesh)
                                   {
                                       [self configureRefreshDataWithCouponList:couponList error:error];
                                   }
                                   else
                                   {
                                       [self configureLoadMoreDataWithCouponList:couponList error:error];
                                   }
                               }];
    }
    else
    {
        [ShopSDK getReceivableCouponsWithPageSize:SPSDKPageSize
                                        pageIndex:_pageIndex
                                           result:^(NSUInteger pageIndex, NSUInteger countNum, NSArray<SPSDKCoupon *> *couponList, NSError *error) {
                                               if (isRefesh)
                                               {
//                                                   for (SPSDKCoupon *coupon in couponList)
//                                                   {
//                                                       NSLog(@"%lld", coupon.couponId);
//                                                   }
                                                   
                                                   [self configureRefreshDataWithCouponList:couponList error:error];
                                               }
                                               else
                                               {
                                                   [self configureLoadMoreDataWithCouponList:couponList error:error];
                                               }
                                           }];
    }
}

- (void)configureLoadMoreDataWithCouponList:(NSArray<SPSDKCoupon *> *)couponList error:(NSError *)error
{
    if (!error)
    {
        [self.dataSource addObjectsFromArray:couponList];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        if (!couponList.count)
        {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }
    else
    {
        [MBProgressHUD showTitle:error.message];
        [self.tableView.mj_footer endRefreshing];
    }
}

- (void)configureRefreshDataWithCouponList:(NSArray<SPSDKCoupon *> *)couponList error:(NSError *)error
{
    if (!error)
    {
        self.dataSource = [NSMutableArray arrayWithArray:couponList];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (_type != SPSDKCouponPageTypeSelectUse && _type != SPSDKCouponPageTypeSelectUnuse)
        {
            [self.tableView.mj_footer resetNoMoreData];
        }
    }
    else
    {
        [MBProgressHUD showTitle:error.message];
        [self.tableView.mj_header endRefreshing];
    }
    
    [self.view configureTipViewWithTipMessage:@"暂时还没有优惠券哦"
                                      hasData:self.dataSource.count
                                  noDataImage:[UIImage imageNamed:@"empty_coupons"]];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_type != SPSDKCouponPageTypeSelectUse)
    {
        self.tableView.mj_footer.hidden = self.dataSource.count == 0;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKCouponCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKCouponCellId];
    if (!cell)
    {
        cell = [SPSDKCouponCell loadInstanceFromNib];
    }
    cell.useNowBtn.hidden = (_status != SPSDKCouponStatusUnused);
    cell.spaceConstraint.constant = (_status == SPSDKCouponStatusUnused) ? 28 : 22;
    cell.indexPath = indexPath;
    cell.type = _type;
    cell.model = self.dataSource[indexPath.row];
    cell.selectHandler = ^(NSIndexPath *indexPath) {

        [self.dataSource enumerateObjectsUsingBlock:^(SPSDKCoupon *model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == indexPath.row)
            {
                // 选中的取反
                model.selected = !model.selected;
            }
            else
            {   // 其余的设置为NO
                model.selected = NO;
            }
        }];
        
        [tableView reloadData];
    };
    cell.getHandler = ^(NSIndexPath *indexPath) {
        SPSDKCoupon *model = self.dataSource[indexPath.row];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [ShopSDK receiveCoupon:model result:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!error)
            {
                model.isGet = YES;
                [tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:SPSDKCouponRefreshNotif object:nil];
                [MBProgressHUD showTitle:@"领取成功"];
            }
            else
            {
                [MBProgressHUD showTitle:error.message];
            }
        }];
    };
    cell.useNowHandler = ^(NSIndexPath *indexPath) {
        SPSDKCoupon *model = self.dataSource[indexPath.row];
        SPSDKAllProductViewController *allVC = [[SPSDKAllProductViewController alloc] init];
        allVC.labels = model.labelIds;
        [self.navigationController pushViewController:allVC animated:YES];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (_type == SPSDKCouponPageTypeSelectUnuse)
    {
        return 138.f;
    }
    return 118.f;
}

- (IBAction)onAction:(id)sender
{
    if (_type == SPSDKCouponPageTypeSelectUse)
    { // 确定
        SPSDKCoupon *coupon = nil;
        for (SPSDKCoupon *model in self.dataSource)
        {
            if (model.selected)
            {
                coupon = model;
                break;
            }
        }
        if (self.selectCouponHandler)
        {
            self.selectCouponHandler(coupon);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)dealloc
{
    if (_type == SPSDKCouponPageTypePersonal)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
