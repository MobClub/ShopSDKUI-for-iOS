//
//  SPSDKRefundDetailViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/20.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKRefundDetailViewController.h"
#import "SPSDKRefundProgressCell.h"
#import "SPSDKFillLogisticsViewController.h"
#import "SPSDKRefundDetailCell.h"
#import "SPSDKRefundDetailHeader.h"
#import "SPSDKLogisticsViewController.h"
#import "SPSDKApplyRefundViewController.h"
#import "SPSDKOrderDetailViewController.h"

static NSString *const SPSDKRefundProgressCellId = @"SPSDKRefundProgressCell";
static NSString *const SPSDKRefundDetailCellId = @"SPSDKRefundDetailCell";

@interface SPSDKRefundDetailViewController () <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *orderDetailBtn;
@property (weak, nonatomic) IBOutlet UIButton *contactServiceBtn;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet SPSDKGroupTableView *tableView;
@property (nonatomic, strong) SPSDKRefundDetail *detailModel;
@property (nonatomic, assign) SPSDKRefundStatus status;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) SPSDKTradingCommodity *orderCommodity;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation SPSDKRefundDetailViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (instancetype)initWithOrderCommodity:(SPSDKTradingCommodity *)orderCommodity
{
    self = [super init];
    if (self)
    {
        _orderCommodity = orderCommodity;
    }
    return self;
}

- (IBAction)onOrderDetailAction:(id)sender
{
    SPSDKOrderDetailViewController *orderVC = [[SPSDKOrderDetailViewController alloc] initWithOrder:_detailModel.order];
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (IBAction)onServiceAction:(id)sender
{
    [MBProgressHUD showTitle:@"敬请期待"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bottomConstraint.constant = SPSDKiPhoneX ? 34.f : 0.f;
    
    self.title = @"退款详情";
    
    [self configure];
    
    [self requestData];
}

- (void)requestData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ShopSDK getRefundDetailWithOrderCommodity:_orderCommodity result:^(SPSDKRefundDetail *detail, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error)
        {
            self.detailModel = detail;
            self.dataSource = [detail.descirbeList mutableCopy];
            [self.tableView reloadData];
        }
        else
        {
            [MBProgressHUD showTitle:error.message];
        }
    }];
}

- (void)configure
{
    self.orderDetailBtn.layer.cornerRadius = 2.f;
    self.orderDetailBtn.layer.masksToBounds = YES;
    self.orderDetailBtn.layer.borderColor = SPSDKTextColor.CGColor;
    self.orderDetailBtn.layer.borderWidth = 1.f;
    [self.orderDetailBtn setTitleColor:SPSDKTextColor forState:UIControlStateNormal];
    
    self.contactServiceBtn.layer.cornerRadius = 2.f;
    self.contactServiceBtn.layer.masksToBounds = YES;
    self.contactServiceBtn.layer.borderColor = SPSDKMainColor.CGColor;
    self.contactServiceBtn.layer.borderWidth = 1.f;
    [self.contactServiceBtn setTitleColor:SPSDKMainColor forState:UIControlStateNormal];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.dataSource.count == 0)
    {
        return 0;
    }
    return self.dataSource.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        SPSDKRefundProgressCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKRefundProgressCellId];
        if (!cell)
        {
            cell = [SPSDKRefundProgressCell loadInstanceFromNib];
        }
        cell.progressLabel.text = [NSString progressStringWithStatus:_detailModel.status];
        cell.orderLabel.text = [NSString stringWithFormat:@"%@", @(_detailModel.order.orderId)];
        return cell;
    }
    else
    {
        SPSDKRefundDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKRefundDetailCellId];
        if (!cell)
        {
            cell = [SPSDKRefundDetailCell loadInstanceFromNib];
        }
        cell.indexPath = indexPath;
        cell.model = self.dataSource[indexPath.section - 1];
        cell.actionHandler = ^(NSString *title, SPSDKRefundDesc *refundDesc) {
            [self actionTitle:title refundDesc:refundDesc];
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 66.f;
    }
    else
    {
        float cellHeight = 0.f;
        
        SPSDKRefundDesc *model = self.dataSource[indexPath.section - 1];
        
        switch (model.status)
        {
            case SPSDKRefundStatusApplying: // 发起申请
            {
                if (model.refundImgs.count)
                {
                    NSInteger row = ceilf((model.refundImgs.count + 1) / 4.0);
                    cellHeight = 30.f * 4 + (ScreenWidth - 95 - 2 * 10) / 3 * row + 16.f;
                }
                else
                {
                    cellHeight = 30.f * 4;
                }
            }
                break;
                
            case SPSDKRefundStatusAgree: // 商家同意,等待发货
            {
                if (model.refundType == SPSDKRefundTypeMoneyOnly)
                {
                    cellHeight = 0.f;
                }
                else
                {
                    cellHeight = 30.f * 4;
                }
            }
                break;
                
            case SPSDKRefundStatusSellerRejected: // 商家不同意/驳回
            {
                cellHeight = 30.f;
            }
                break;
                
            case SPSDKRefundStatusTransporting: // 退款商品寄送中
            {
                cellHeight = 60.f;
            }
                break;
                
            case SPSDKRefundStatusSuccess: // 商家退款成功
            {
                cellHeight = 30.f;
            }
                break;
                
            case SPSDKRefundStatusRefundClosed: // 关闭退款
            {
                cellHeight = 0.f;
            }
                break;
                
            case SPSDKRefundStatusRefunding: // 正在退款中
            {
                cellHeight = 30.f;
            }
                break;
                
            default:
                break;
        }
        
        if (indexPath.section == 1
            && model.status != SPSDKRefundStatusSuccess
            && model.status != SPSDKRefundStatusRefundClosed
            && model.status != SPSDKRefundStatusRefunding)
        {
            return cellHeight + 42.f;
        }
        return cellHeight;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return nil;
    }
    SPSDKRefundDesc *model = self.dataSource[section - 1];
    SPSDKRefundDetailHeader *header = [SPSDKRefundDetailHeader loadInstanceFromNib];
    header.stateLabel.text = [NSString refundStatusStringWithStatus:model.status];
    header.dateLabel.text = [NSDate dateWithTimeStamp:model.createAt];
    NSString *remain = [NSDate dateWithRemainTimeStamp:_detailModel.expiration];
    if ([remain isEqualToString:@"已结束"])
    {
        header.remainLabel.text = remain;
    }
    else
    {
        header.remainLabel.attributedText = [self remianStringWithRemain:remain status:model.status];
    }
    header.remainLabel.hidden = (section != 1
                                 || model.status == SPSDKRefundStatusRefundClosed
                                 || model.status == SPSDKRefundStatusSuccess
                                 || model.status == SPSDKRefundStatusRefunding);
    return header;
}

- (NSAttributedString *)remianStringWithRemain:(NSString *)remain status:(SPSDKRefundStatus)status
{
    NSString *desc = nil;
    switch (status)
    {
        case SPSDKRefundStatusApplying:
        case SPSDKRefundStatusTransporting:
        {
            desc = @"后系统自动退款";
        }
            break;
            
        case SPSDKRefundStatusAgree:
        case SPSDKRefundStatusSellerRejected:
        {
            desc = @"后系统自动关闭退款";
        }
            break;
            
        default:
            break;
    }
    
    NSString *str = [NSString stringWithFormat:@"%@%@", remain, desc];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attributedStr addAttributes:@{ NSForegroundColorAttributeName : SPSDKMainColor } range:NSMakeRange(0, remain.length)];
    [attributedStr addAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] } range:NSMakeRange(remain.length, str.length - remain.length)];
    return [attributedStr copy];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return CGFLOAT_MIN;
    }
    
    if (section == 1 )
    {
        SPSDKRefundDesc *model = self.dataSource[section - 1];
        if (model.status == SPSDKRefundStatusRefundClosed
            || model.status == SPSDKRefundStatusSuccess
            || model.status == SPSDKRefundStatusRefunding)
        {
            return 46.f;
        }
        return 66.f;
    }
    
    return 46.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

- (void)actionTitle:(NSString *)title refundDesc:(SPSDKRefundDesc *)refundDesc
{
    if ([title isEqualToString:@"填写物流"] || [title isEqualToString:@"修改物流"])
    {
        SPSDKFillLogisticsViewController *fillVC = [[SPSDKFillLogisticsViewController alloc] initWithOrderCommodity:_orderCommodity isAdd:([title isEqualToString:@"填写物流"] ? 0 : 1)];
        fillVC.completHandler = ^{
            [self requestData];
        };
        [self.navigationController pushViewController:fillVC animated:YES];
    }
    else if ([title isEqualToString:@"追踪物流"])
    {
        SPSDKLogisticsViewController *logisticsVC = [[SPSDKLogisticsViewController alloc] initWithTransport:refundDesc.transport type:SPSDKLogisticsTypeRefund];
        [self.navigationController pushViewController:logisticsVC animated:YES];
    }
    else if ([title isEqualToString:@"取消退款"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"取消退款？"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确认", nil];
        [alert show];
    }
    else if ([title isEqualToString:@"修改退款"])
    {
        
        SPSDKApplyRefundViewController *applyVC = [[SPSDKApplyRefundViewController alloc] initWithOrderCommodity:_detailModel.orderCommodity isModify:YES];
        applyVC.refundHandler = ^(NSIndexPath *indexPath) {
            [self requestData];
        };
        [self.navigationController pushViewController:applyVC animated:YES];
    }
    else
    {
        SPSDKApplyRefundViewController *applyVC = [[SPSDKApplyRefundViewController alloc] initWithOrderCommodity:_detailModel.orderCommodity isModify:NO];
        applyVC.refundHandler = ^(NSIndexPath *indexPath) {
            [self requestData];
        };
        [self.navigationController pushViewController:applyVC animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [ShopSDK cancelRefundWithOrderCommodity:_orderCommodity result:^(NSError *error) {
            if (!error)
            {
                [MBProgressHUD showTitle:@"取消退款成功"];
                [self requestData];
            }
            else
            {
                [MBProgressHUD showTitle:error.message];
            }
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
