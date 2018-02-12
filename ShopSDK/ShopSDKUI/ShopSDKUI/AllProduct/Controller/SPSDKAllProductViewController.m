//
//  SPSDKAllProductViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/7.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKAllProductViewController.h"
#import "SPSDKPriceButton.h"
#import "SPSDKSearchView.h"
#import "SPSDKAllProductGridCell.h"
#import "SPSDKAllProductListCell.h"
#import "SPSDKFilterView.h"
#import "SPSDKChooseView.h"
#import "SPSDKProductViewController.h"
#import "SPSDKSearchViewController.h"
#import <MOBFoundation/MOBFDevice.h>
#import <objc/message.h>


static NSString *const SPSDKAllProductGridCellId = @"SPSDKAllProductGridCell";
static NSString *const SPSDKAllProductListCellId = @"SPSDKAllProductListCell";

@interface SPSDKAllProductViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIButton *saleBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;
@property (weak, nonatomic) IBOutlet UIButton *newsBtn;
@property (weak, nonatomic) IBOutlet SPSDKPriceButton *priceBtn;
@property (weak, nonatomic) IBOutlet UIButton *gridListBtn;
@property (weak, nonatomic) IBOutlet UIButton *fliterBtn;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UILabel *vLine;
@property (weak, nonatomic) IBOutlet UILabel *hLine;
@property (nonatomic, weak) SPSDKSearchView *searchView;
@property (nonatomic, strong) SPSDKFilterView *fliterView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isGrid;
@property (nonatomic, copy) NSString *keyword;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) SPSDKOrdered timeSort;
@property (nonatomic, assign) SPSDKOrdered priceSort;
@property (nonatomic, assign) SPSDKOrdered salesSort;
@property (nonatomic, assign) NSInteger min;
@property (nonatomic, assign) NSInteger max;
@property (nonatomic, strong) SPSDKTransportStrategy *stragtegy;

@end

@implementation SPSDKAllProductViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (SPSDKFilterView *)fliterView
{
    if (!_fliterView)
    {
        _fliterView = [[SPSDKFilterView alloc] init];
    }
    return _fliterView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _keyword = nil;
    
    _isGrid = YES;
    
    _saleBtn.selected = YES;
    
    _timeSort = SPSDKOrderedNone;
    _priceSort = SPSDKOrderedNone;
    _salesSort = SPSDKOrderedDescending;
    
    [self configureUI];
    
    [self refresh];
    
    __weak typeof(self) weakSelf = self;
    self.fliterView.sureHandler = ^(NSUInteger max, NSUInteger min, SPSDKTransportStrategy *stragtegy, NSArray <SPSDKProductLabel *> *labels){
        
        SPSDKLog(@"选中 max:%zd,min:%zd,sta:%@,labelist:%@",max,min,stragtegy,labels);
        //过滤出来的是元,需要乘以100变成分
        weakSelf.min = min * 100;
        weakSelf.max = max * 100;
        
        weakSelf.stragtegy = stragtegy;
        NSMutableArray *labelIds = [NSMutableArray array];
        for (SPSDKProductLabel *label in labels)
        {
            [labelIds addObject:@(label.labelId)];
        }
        weakSelf.labels = [labelIds copy];
        
        [weakSelf.collectionView.mj_header beginRefreshing];
    };
    
    self.fliterView.resetHandler = ^{
        
        SPSDKLog(@"重置");
        
        [weakSelf reset];
    };
}

- (void)reset
{
    self.min = 0;
    self.max = 0;
    self.stragtegy = nil;
    self.labels = nil;
    self.timeSort = SPSDKOrderedNone;
    self.priceSort = SPSDKOrderedNone;
    self.salesSort = SPSDKOrderedDescending;
    self.priceBtn.type = SPSDKPriceTypeNormal;
    self.newsBtn.selected = NO;
    self.saleBtn.selected = YES;
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)refresh
{
    __weak typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.pageIndex = 1;
        
        [ShopSDK getProductsWithKeyword:weakSelf.keyword
                               minPrice:weakSelf.min
                               maxPrice:weakSelf.max
                    transportStrategyId:weakSelf.stragtegy.strategyId
                            labelIdList:weakSelf.labels
                               timeSort:weakSelf.timeSort
                              priceSort:weakSelf.priceSort
                              salesSort:weakSelf.salesSort
                               pageSize:SPSDKPageSize
                              pageIndex:weakSelf.pageIndex
                                 result:^(NSUInteger pageIndex, NSUInteger countNum, NSArray<SPSDKProduct *> *productList, NSError *error) {
                                     if (!error)
                                     {
                                         weakSelf.dataSource = [productList mutableCopy];
                                         [weakSelf.collectionView reloadData];
                                         [weakSelf.collectionView.mj_header endRefreshing];
                                         [weakSelf.collectionView.mj_footer resetNoMoreData];
                                         [weakSelf.view configureTipViewWithTipMessage:@"没有找到相关宝贝~"
                                                                               hasData:weakSelf.dataSource.count
                                                                           noDataImage:[UIImage imageNamed:@"empty_order"]];
                                     }
                                     else
                                     {
                                         [MBProgressHUD showTitle:error.message];
                                         [weakSelf.collectionView.mj_header endRefreshing];
                                     }
                                 }];
    }];
    
    // 马上进入刷新状态
    [self.collectionView.mj_header beginRefreshing];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageIndex ++;
        
        [ShopSDK getProductsWithKeyword:weakSelf.keyword
                               minPrice:weakSelf.min
                               maxPrice:weakSelf.max
                    transportStrategyId:weakSelf.stragtegy.strategyId
                            labelIdList:weakSelf.labels
                               timeSort:weakSelf.timeSort
                              priceSort:weakSelf.priceSort
                              salesSort:weakSelf.salesSort
                               pageSize:SPSDKPageSize
                              pageIndex:weakSelf.pageIndex
                                 result:^(NSUInteger pageIndex, NSUInteger countNum, NSArray<SPSDKProduct *> *productList, NSError *error) {
                                     if (!error)
                                     {
                                         [weakSelf.dataSource addObjectsFromArray:productList];
                                         [weakSelf.collectionView reloadData];
                                         [weakSelf.collectionView.mj_footer endRefreshing];
                                         if (productList.count == 0)
                                         {
                                             [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                                         }
                                     }
                                     else
                                     {
                                         [MBProgressHUD showTitle:error.message];
                                         [weakSelf.collectionView.mj_footer endRefreshing];
                                     }
                                 }];
    }];
}

- (void)configureUI
{
    self.collectionView.backgroundColor = [UIColor colorForHex:0xf7f7f7];
    
    if (SPSDKiOS11)
    {
//        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//2
        SEL setSEL = NSSelectorFromString(@"setContentInsetAdjustmentBehavior:");
        void (*setContentInsetAdjustmentBehavior)(id, SEL, NSInteger) = (void (*)(id, SEL, NSInteger))objc_msgSend;
        setContentInsetAdjustmentBehavior(self.collectionView, setSEL, 2);

    }
    
    
    UIColor *btnColor = [UIColor colorForHex:0x666666];
    
    [self.saleBtn setTitleColor:btnColor forState:UIControlStateNormal];
    [self.saleBtn setTitleColor:SPSDKMainColor forState:UIControlStateSelected];

    [self.newsBtn setTitleColor:btnColor forState:UIControlStateNormal];
    [self.newsBtn setTitleColor:SPSDKMainColor forState:UIControlStateSelected];

    [self.priceBtn setTitleColor:btnColor forState:UIControlStateNormal];

    [self.fliterBtn setTitleColor:btnColor forState:UIControlStateNormal];
    
    self.hLine.backgroundColor = SPSDKLineColor;
    self.vLine.backgroundColor = SPSDKLineColor;
    
    __weak typeof(self) weakSelf = self;
    SPSDKSearchView *searchView = [SPSDKSearchView loadInstanceFromNib];
    searchView.textFieldEnable = NO;
    searchView.hiddenClear = YES;
    self.navigationItem.titleView = searchView;
    _searchView = searchView;
    _searchView.clickHandler = ^{
        SPSDKSearchViewController *searchVC = [[SPSDKSearchViewController alloc] initWithSearchType:SPSDKSearchTypeProduct];
        searchVC.searchKey = weakSelf.searchView.textField.text;
        searchVC.searchHandler = ^(NSString *key) {
            searchView.searchKey = key;
            weakSelf.keyword = key;
            [weakSelf reset];
        };
        searchVC.clickTagHandler = ^(NSInteger index, NSString *key) {
            searchView.searchKey = key;
            weakSelf.keyword = key;
            [weakSelf reset];
        };
        SPSDKNavigationController *nav = [[SPSDKNavigationController alloc] initWithRootViewController:searchVC];
        [weakSelf presentViewController:nav animated:YES completion:nil];
    };
    
    [self.collectionView registerNib:[SPSDKAllProductListCell loadNib] forCellWithReuseIdentifier:SPSDKAllProductListCellId];
    [self.collectionView registerNib:[SPSDKAllProductGridCell loadNib] forCellWithReuseIdentifier:SPSDKAllProductGridCellId];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (ScreenWidth == 320.0)
    {
        self.fliterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    }
    else
    {
        self.fliterBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 30);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    self.collectionView.mj_footer.hidden = self.dataSource.count == 0;
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isGrid)
    {
        SPSDKAllProductGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SPSDKAllProductGridCellId forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
    else
    {
        SPSDKAllProductListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SPSDKAllProductListCellId forIndexPath:indexPath];
        cell.model = self.dataSource[indexPath.row];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isGrid)
    {
        CGFloat width = (ScreenWidth - 5) / 2;
        return CGSizeMake(width , width + 72);
    }
    else
    {
        return CGSizeMake(ScreenWidth, 110);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKProduct *product = self.dataSource[indexPath.row];
    SPSDKProductViewController *productVC = [[SPSDKProductViewController alloc] initWithProduct:product];
    [self.navigationController pushViewController:productVC animated:YES];
}

#pragma mark - Action

- (IBAction)_onGridListAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    _isGrid = !_isGrid;
    
    if (_isGrid)
    {
        self.flowLayout.minimumLineSpacing = 5;
    }
    else
    {
        self.flowLayout.minimumLineSpacing = 0;
    }
    
    [self.collectionView reloadData];
}

- (IBAction)_onFliterAction:(id)sender
{
    [self.fliterView show];
}

- (IBAction)_onPriceAction:(SPSDKPriceButton *)sender
{
    if (sender.type == SPSDKPriceTypeNormal)
    {
        sender.type = SPSDKPriceTypeAsc;
        self.priceSort = SPSDKOrderedAscending;
    }
    else if (sender.type == SPSDKPriceTypeAsc)
    {
        sender.type = SPSDKPriceTypeDesc;
        self.priceSort = SPSDKOrderedDescending;
    }
    else
    {
        sender.type = SPSDKPriceTypeAsc;
        self.priceSort = SPSDKOrderedAscending;
    }
    
    self.saleBtn.selected = NO;
    self.newsBtn.selected = NO;
    
    self.timeSort = SPSDKOrderedNone;
    self.salesSort = SPSDKOrderedNone;
    
    [self.collectionView.mj_header beginRefreshing];
}

- (IBAction)_onNewAction:(UIButton *)sender
{
    if (sender.selected)
    {
        return;
    }
    
    sender.selected = YES;
    
    self.saleBtn.selected = NO;
    self.priceBtn.type = SPSDKPriceTypeNormal;
    
    self.timeSort = SPSDKOrderedDescending;
    self.salesSort = SPSDKOrderedNone;
    self.priceSort = SPSDKOrderedNone;
    
    [self.collectionView.mj_header beginRefreshing];
}

- (IBAction)_onSaleAction:(UIButton *)sender
{
    if (sender.selected)
    {
        return;
    }
    
    sender.selected = YES;
    
    self.priceBtn.type = SPSDKPriceTypeNormal;
    self.newsBtn.selected = NO;
    
    self.salesSort = SPSDKOrderedDescending;
    self.timeSort = SPSDKOrderedNone;
    self.priceSort = SPSDKOrderedNone;
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
