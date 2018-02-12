//
//  SPSDKCommentViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/19.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKCommentViewController.h"
#import "SPSDKCommentCell.h"

static NSString *const SPSDKCommentCellId = @"SPSDKCommentCell";

@interface SPSDKCommentViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation SPSDKCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView registerNib:[SPSDKCommentCell loadNib] forCellReuseIdentifier:SPSDKCommentCellId];
    self.tableView.estimatedRowHeight = 150.f;
    
    [self refresh];
}

- (void)refresh
{
    __weak typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.pageIndex = 1;
        
        [ShopSDK getCommentsWithProduct:weakSelf.product
                                  level:weakSelf.commentLevel
                           commentStars:0
                             hasPicture:weakSelf.pictureFilter
                               pageSize:SPSDKPageSize
                              pageIndex:weakSelf.pageIndex
                                 result:^(NSUInteger pageIndex, NSUInteger countNum, NSString *praiseRate, NSArray<SPSDKProductComment *> *commentList, NSUInteger picCommentCount, NSDictionary *countByStars, NSError *error) {
                                     if (!error)
                                     {
                                         weakSelf.dataSource = [commentList mutableCopy];
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
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageIndex ++;
        
        [ShopSDK getCommentsWithProduct:weakSelf.product
                                  level:weakSelf.commentLevel
                           commentStars:0
                             hasPicture:weakSelf.pictureFilter
                               pageSize:SPSDKPageSize
                              pageIndex:weakSelf.pageIndex
                                 result:^(NSUInteger pageIndex, NSUInteger countNum, NSString *praiseRate, NSArray<SPSDKProductComment *> *commentList, NSUInteger picCommentCount, NSDictionary *countByStars, NSError *error) {
                                     if (!error)
                                     {
                                         [weakSelf.dataSource addObjectsFromArray:commentList];
                                         [weakSelf.tableView reloadData];
                                         [weakSelf.tableView.mj_footer endRefreshing];
                                         if (commentList.count == 0)
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.tableView.mj_footer.hidden = self.dataSource.count == 0;
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKCommentCellId forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

@end
