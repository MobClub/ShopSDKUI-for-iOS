//
//  SPSDKProductViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/11.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKProductViewController.h"
#import "SPSDKProductCell.h"
#import "SPSDKNavigationBar.h"
#import "SPSDKConfirmCell.h"
#import "SPSDKCommentCell.h"
#import "SPSDKCommentHeaderView.h"
#import "SPSDKCommentRootViewController.h"
#import "SPSDKChooseView.h"
#import "SPSDKProductImageCell.h"
#import "SPSDKShoppingCartViewController.h"
#import "SPSDKConfirmOrderViewController.h"
#import "SPSDKOrderDetailViewController.h"
#import <UMSSDK/UMSSDK.h>
#import <UMSSDKUI/UMSLoginModuleViewController.h>
#import "SPSDKPaySuccessViewController.h"

static NSString *const SPSDKProductCellId = @"SPSDKProductCell";
static NSString *const SPSDKConfirmCellId = @"SPSDKConfirmCell";
static NSString *const SPSDKCommentCellId = @"SPSDKCommentCell";
static NSString *const SPSDKProductImageCellId = @"SPSDKProductImageCell";

@interface SPSDKProductViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet SPSDKGroupTableView *tableView;
@property (nonatomic, strong) SPSDKNavigationBar *navBar;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) SPSDKProduct *product;
@property (nonatomic, strong) SPSDKProduct *allProduct;
@property (nonatomic, copy) NSString *praiseRate;
@property (nonatomic, assign) NSInteger commentCounts;
@property (nonatomic, assign) NSInteger section;
@property (weak, nonatomic) IBOutlet UIView *serviceView;
@property (weak, nonatomic) IBOutlet UIView *shopCartView;
@property (weak, nonatomic) IBOutlet UIButton *buyNowBtn;
@property (weak, nonatomic) IBOutlet UIButton *addShopCartBtn;
@property (nonatomic, copy) NSDictionary *countByStars;
@property (nonatomic, assign) NSInteger picCommentCount;
@property (nonatomic, assign) BOOL hasChoose;
@property (nonatomic, copy) NSString *chooseDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation SPSDKProductViewController

- (instancetype)initWithProduct:(SPSDKProduct *)product
{
    self = [super init];
    if (self)
    {
        _product = product;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Getters

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
    
    self.bottomConstraint.constant = SPSDKiPhoneX ?  -34.f : 0.f;
    
    _hasChoose = YES;
    
    [self configureUI];
    
    [self requestDataWithProduct];
}

- (void)configureUI
{
    [self.tableView registerNib:[SPSDKCommentCell loadNib] forCellReuseIdentifier:SPSDKCommentCellId];
    self.tableView.estimatedRowHeight = 150.f;
    _navBar = [SPSDKNavigationBar loadInstanceFromNib];
    [self.view addSubview:_navBar];
    _navBar.backgroundAlpha = 0;
    
    [self.buyNowBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake((ScreenWidth - 114) / 2, 45)] forState:UIControlStateNormal];
    [self.buyNowBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake((ScreenWidth - 114) / 2, 45)] forState:UIControlStateHighlighted];
    
    [self.addShopCartBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake((ScreenWidth - 114) / 2, 45)] forState:UIControlStateNormal];
    [self.addShopCartBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake((ScreenWidth - 114) / 2, 45)] forState:UIControlStateHighlighted];
    
    [self.serviceView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onServiceAction)]];
    
    [self.shopCartView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onShopCartAction)]];
}

- (void)requestDataWithProduct
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_group_enter(group);
    [ShopSDK getProductDetailWithProduct:_product result:^(SPSDKProduct *product, NSError *error) {
        dispatch_group_leave(group);
        _allProduct = product;
        if (product.properties.count == 0 && product.commodities.count == 1)
        {
            _hasChoose = NO;
        }
        
        if (error)
        {
            [MBProgressHUD showTitle:error.message];
        }
    }];
    
    dispatch_group_enter(group);
    [ShopSDK getCommentsWithProduct:_product
                              level:SPSDKCommentLevelNone
                       commentStars:0
                         hasPicture:SPSDKPictureFilterNone
                           pageSize:3
                          pageIndex:1
                             result:^(NSUInteger pageIndex, NSUInteger countNum, NSString *praiseRate, NSArray<SPSDKProductComment *> *commentList, NSUInteger picCommentCount, NSDictionary *countByStars, NSError *error) {
                                 dispatch_group_leave(group);
                                 self.picCommentCount = picCommentCount;
                                 self.countByStars = countByStars;
                                 self.commentCounts = countNum;
                                 self.praiseRate = praiseRate;
                                 self.dataSource = [commentList mutableCopy];
                                 if (error)
                                 {
                                     [MBProgressHUD showTitle:error.message];
                                 }
                             }];
    
    dispatch_group_notify(group, queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            _section = 4;
            [self.tableView reloadData];
        });
    });
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _navBar.frame = SPSDKiPhoneX ? CGRectMake(0, 0, ScreenWidth, 88) : CGRectMake(0, 0, ScreenHeight, 64);
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _section;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2)
    {
        return self.dataSource.count;
    }
    if (section == 3)
    {
        return _allProduct.productAdditionalInfos.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        SPSDKProductCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKProductCellId];
        if (!cell)
        {
            cell = [SPSDKProductCell loadInstanceFromNib];
        }
        cell.model = _allProduct;
        return cell;
    }
    else if (indexPath.section == 1)
    {
        SPSDKConfirmCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKConfirmCellId];
        if (!cell)
        {
            cell = [SPSDKConfirmCell loadInstanceFromNib];
        }
        cell.hasTextField = NO;
        cell.detailTitle = nil;
        if (_chooseDescription)
        {
            cell.title = [NSString stringWithFormat:@"已选:%@", _chooseDescription];
        }
        else
        {
            cell.title = @"选择商品型号";
        }
        cell.hidden = !_hasChoose;
        return cell;
    }
    else if (indexPath.section == 2)
    {
        SPSDKCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKCommentCellId forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
    else
    {
        SPSDKProductImageCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKProductImageCellId];
        if (!cell)
        {
            cell = [SPSDKProductImageCell loadInstanceFromNib];
        }
        cell.dict = _allProduct.productAdditionalInfos[indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return ScreenWidth + 115.f;
    }
    else if (indexPath.section == 1)
    {
        if (_hasChoose)
        {
            return 42.f;
        }
        else
        {
            return 0.f;
        }
    }
    else if (indexPath.section == 2)
    {
        return UITableViewAutomaticDimension;
    }
    else
    {
        NSDictionary *dict = _allProduct.productAdditionalInfos[indexPath.row];
        NSDictionary *imageUrl =  dict[@"imgUrl"];
        float width = 0.f, height = 0.f;
        if ([imageUrl isKindOfClass:[NSDictionary class]])
        {
            width = [imageUrl[@"width"] floatValue];
            height = [imageUrl[@"height"] floatValue];
        }
        
        if (width)
        {
            return height * ScreenWidth / width;
        }
        else
        {
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2 || section == 3)
    {
        return 30.f;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1 && !_hasChoose)
    {
        return CGFLOAT_MIN;
    }
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2 || section == 3)
    {
        SPSDKCommentHeaderView *headerView = [SPSDKCommentHeaderView loadInstanceFromNib];
        headerView.isImage = section == 3;
        if (section == 2)
        {
            headerView.praiseRate = _praiseRate;
            headerView.commentCounts = _commentCounts;
            headerView.didSelectHandler = ^{
                SPSDKCommentRootViewController *commentVC = [[SPSDKCommentRootViewController alloc] init];
                commentVC.product = _product;
                commentVC.countByStars = _countByStars;
                commentVC.picCommentCount = _picCommentCount;
                commentVC.commentCounts = _commentCounts;
                [self.navigationController pushViewController:commentVC animated:YES];
            };
        }
        else
        {
            headerView.title = @"商品详情";
        }
        return headerView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        SPSDKChooseView *chooseView = [[SPSDKChooseView alloc] init];
        chooseView.model = _allProduct;
        [chooseView show];
        chooseView.sureHandler = ^(SPSDKCommodity *commodity, NSInteger count) {
            _chooseDescription = commodity.propertyDescribe;
            [self.tableView reloadData];
        };
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat headerViewHeight = ScreenWidth;
    if (offsetY <= 0)
    {
        _navBar.backgroundAlpha = 0;
    }
    else if (offsetY >= headerViewHeight)
    {
        _navBar.backgroundAlpha = 1.0;
    }
    else
    {
        _navBar.backgroundAlpha = offsetY/headerViewHeight;
    }
}

- (IBAction)onBuyNowAction:(id)sender
{
    if ([UMSSDK currentUser])
    {
        if (_hasChoose)
        {
            SPSDKChooseView *chooseView = [[SPSDKChooseView alloc] init];
            chooseView.isBuyNow = YES;
            chooseView.model = _allProduct;
            chooseView.sureHandler = ^(SPSDKCommodity *commodity, NSInteger count) {
                
                _chooseDescription = commodity.propertyDescribe;
                [self.tableView reloadData];
                
                SPSDKTradingCommodity *tradingCommodity = [[SPSDKTradingCommodity alloc] initWithCommodity:commodity count:count];
                
                SPSDKConfirmOrderViewController *confirmOrderVC = [[SPSDKConfirmOrderViewController alloc] initWithSelectProducts:@[tradingCommodity] totalPrice:0.f];
                confirmOrderVC.payResultHandler = ^(SPSDKOrder *order, BOOL isSuccess) {
                    if (isSuccess)
                    {
                        [self pushPaySuccessVCWithOrder:order];
                    }
                    else
                    {
                        SPSDKOrderDetailViewController *orderDetailVC = [[SPSDKOrderDetailViewController alloc] initWithOrder:order];
                        [self.navigationController pushViewController:orderDetailVC animated:YES];
                    }
                };
                [self.navigationController pushViewController:confirmOrderVC animated:YES];
            };
            [chooseView show];
        }
        else
        {
            SPSDKCommodity *commodity = _allProduct.commodities.firstObject;
            if (commodity.usableStock <= 0)
            {
                [MBProgressHUD showTitle:@"库存不足"];
                return;
            }
            SPSDKTradingCommodity *tradingCommodity = [[SPSDKTradingCommodity alloc] initWithCommodity:commodity count:1];
//            commodity.count = 1;
            SPSDKConfirmOrderViewController *confirmOrderVC = [[SPSDKConfirmOrderViewController alloc] initWithSelectProducts:@[tradingCommodity] totalPrice:0.f];
            confirmOrderVC.payResultHandler = ^(SPSDKOrder *order, BOOL isSuccess) {
                
                if (isSuccess)
                {
                    [self pushPaySuccessVCWithOrder:order];
                }
                else
                {
                    SPSDKOrderDetailViewController *orderDetailVC = [[SPSDKOrderDetailViewController alloc] initWithOrder:order];
                    [self.navigationController pushViewController:orderDetailVC animated:YES];
                }
            };
            [self.navigationController pushViewController:confirmOrderVC animated:YES];
        }
    }
    else
    {
        [self login];
    }
}

- (void)pushPaySuccessVCWithOrder:(SPSDKOrder *)order
{
    SPSDKPaySuccessViewController *paySuccessVC = [[SPSDKPaySuccessViewController alloc] initWithOrder:order isOrderDetail:NO];
    [self.navigationController pushViewController:paySuccessVC animated:YES];
}

- (void)login
{
    UMSLoginModuleViewController *umsLoginVC = [[UMSLoginModuleViewController alloc] init];
    __weak typeof(UMSLoginModuleViewController) *weakLoginVC = umsLoginVC;
    umsLoginVC.loginVC.loginHandler = ^(NSError *error) {
        if (!error)
        {
            [weakLoginVC close];
        }
    };
    [self presentViewController:umsLoginVC animated:YES completion:nil];
}

- (IBAction)onAddShopCartAction:(id)sender
{
    if (_hasChoose)
    {
        SPSDKChooseView *chooseView = [[SPSDKChooseView alloc] init];
        chooseView.model = _allProduct;
        [chooseView show];
        chooseView.sureHandler = ^(SPSDKCommodity *commodity, NSInteger count) {
            _chooseDescription = commodity.propertyDescribe;
            [self.tableView reloadData];
        };
    }
    else
    {
        SPSDKCommodity *commodity = _allProduct.commodities.firstObject;
        if (commodity.usableStock <= 0)
        {
            [MBProgressHUD showTitle:@"库存不足"];
            return;
        }
        SPSDKTradingCommodity *tradingCommodity = [[SPSDKTradingCommodity alloc] initWithCommodity:commodity count:1];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [ShopSDK addIntoShoppingCartWithCommodity:tradingCommodity result:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!error)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:SPSDKRefreshShoppingCartNotif object:nil];
                [MBProgressHUD showTitle:@"添加成功"];
            }
            else
            {
                [MBProgressHUD showTitle:error.message];
            }
        }];
    }
}

- (void)onServiceAction
{
    [MBProgressHUD showTitle:@"敬请期待"];
}

- (void)onShopCartAction
{
    SPSDKShoppingCartViewController *shopCartVC = [[SPSDKShoppingCartViewController alloc] init];
    shopCartVC.hasTabBar = NO;
    [self.navigationController pushViewController:shopCartVC animated:YES];
}

@end
