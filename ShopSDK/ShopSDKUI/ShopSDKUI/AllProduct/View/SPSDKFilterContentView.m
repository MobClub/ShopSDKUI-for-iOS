//
//  SPSDKFilterContentView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/11.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKFilterContentView.h"
#import "SPSDKFilterView.h"
#import "SPSDKFilterCell.h"
#import "SPSDKPriceRangeCell.h"
#import "SPSDKFilterHeader.h"

#import "SPSDKTransportStrategy+SPSDKExtension.h"
#import "SPSDKProductLabel+SPSDKExtension.h"

static NSString *const SPSDKFliterCellId = @"SPSDKFilterCell";
static NSString *const SPSDKPriceRangeCellId = @"SPSDKPriceRangeCell";

@interface SPSDKFilterContentView () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet SPSDKGroupTableView *tableView;
@property (nonatomic, copy) NSArray *titles;

@property (nonatomic, copy) NSArray *labelList;
@property (nonatomic, copy) NSArray *strategyList;
@property (nonatomic, assign) NSInteger min;
@property (nonatomic, assign) NSInteger max;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation SPSDKFilterContentView

- (IBAction)_resetBtnClick:(UIButton *)sender
{
    _max = 0;
    _min = 0;
    
    [self _reloadData];
    
    if (self.resetHandler)
    {
        self.resetHandler();
    }
}

- (IBAction)_sureBtnClick:(UIButton *)sender
{
    __block SPSDKTransportStrategy *selectedStrategy = nil;
    [_strategyList enumerateObjectsUsingBlock:^(SPSDKTransportStrategy *strategy, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (strategy.selected)
        {
            selectedStrategy = strategy;
        }
        
    }];
    
    NSMutableArray *selectedLabelList = [NSMutableArray array];
    [_labelList enumerateObjectsUsingBlock:^(SPSDKProductLabel *label, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (label.selected)
        {
            [selectedLabelList addObject:label];
        }
        
    }];
    
    if (self.sureHandler)
    {
        self.sureHandler(_max, _min, selectedStrategy, selectedLabelList);
    }
    
    [(SPSDKFilterView *)self.superview removeSelfFromSupView];
}

- (NSArray *)titles
{
    if (!_titles)
    {
        _titles = @[@"价格区间(元)", @"配送区域/邮费", @"标签筛选"];
    }
    return _titles;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.bottomConstraint.constant = SPSDKiPhoneX ? 34.f : 0.f;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.resetBtn.backgroundColor = [UIColor colorForHex:0xf9f9f9];
    [self.sureBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(SPSDKFilterContentWidth / 2.0, 45)] forState:UIControlStateNormal];
    [self.sureBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(SPSDKFilterContentWidth / 2.0, 45)] forState:UIControlStateHighlighted];
    
    [self _reloadData];
}

- (void)_reloadData
{
    __weak typeof(self) weakSelf = self;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [ShopSDK getLabelsWithNumb:20 result:^(NSArray<SPSDKProductLabel *> *labelList, NSError *error) {
            if (!error)
            {
                weakSelf.labelList = labelList;
            }
            else
            {
                [MBProgressHUD showTitle:error.message];
            }
            dispatch_group_leave(group);
        }];
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [ShopSDK getTransportStrategy:^(NSArray<SPSDKTransportStrategy *> *strategyList, NSError *error) {
            
            if (!error)
            {
                weakSelf.strategyList = strategyList;
            }
            else
            {
                [MBProgressHUD showTitle:error.message];
            }
            dispatch_group_leave(group);
            
        }];
    });
    
    dispatch_group_notify(group, queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf animated:YES];
            [weakSelf.tableView reloadData];
        });
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        SPSDKPriceRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKPriceRangeCellId];
        if (!cell)
        {
            cell = [SPSDKPriceRangeCell loadInstanceFromNib];
        }
        
        cell.leftTextField.text = _min ? [NSString stringWithFormat:@"%@", @(_min)] : nil;
        cell.rightTextField.text = _max ? [NSString stringWithFormat:@"%@", @(_max)] :  nil;
        cell.textFieldHandler = ^(NSString *text, BOOL isLeft) {
            if (isLeft)
            {
                _min = [text integerValue];
            }
            else
            {
                _max = [text integerValue];
            }
        };
        return cell;
    }
    else
    {
        SPSDKFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKFliterCellId];
        if (!cell)
        {
            cell = [SPSDKFilterCell loadInstanceFromNib];
        }
        
        if (indexPath.section == 1)
        {
            cell.datas = _strategyList;
        }
        else
        {
            cell.datas = _labelList;
        }
        
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 40.f;
    }
    else
    {
        if (indexPath.section == 1)
        {
            NSInteger row = ceilf(_strategyList.count / 3.0);
            return row * 30 + (row - 1) * 10.f + 10.f;
        }
        
        NSInteger row = ceilf(_labelList.count / 3.0);
        return row * 30 + (row - 1) * 10.f + 10.f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SPSDKFilterHeader *header = [SPSDKFilterHeader loadInstanceFromNib];
    header.title = self.titles[section];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.f;
}

@end
