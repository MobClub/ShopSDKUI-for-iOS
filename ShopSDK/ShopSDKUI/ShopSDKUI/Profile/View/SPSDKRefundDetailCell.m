//
//  SPSDKRefundDetailCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/18.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKRefundDetailCell.h"
#import "SPSDKRefundTableCell.h"
#import "SPSDKRefundTableModel.h"

static NSString *const SPSDKRefundTableCellId = @"SPSDKRefundTableCell";

@interface SPSDKRefundDetailCell () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *barView;
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *barConstraint;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;

@property (nonatomic, assign) BOOL hasPicture;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SPSDKRefundDetailCell

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    self.barView.hidden = indexPath.section != 1;
    if (self.barView.hidden)
    {
        self.barConstraint.constant = 0.f;
    }
    else
    {
        self.barConstraint.constant = 42.f;
    }
    self.btn1.hidden = self.barView.hidden;
    self.btn2.hidden = self.barView.hidden;
    self.btn3.hidden = self.barView.hidden;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.line.backgroundColor = SPSDKLineColor;
    self.bottomLine.backgroundColor = SPSDKLineColor;
    
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self configureButton:self.btn1];
    [self configureButton:self.btn2];
    [self configureButton:self.btn3];
}

- (void)configureButton:(UIButton *)button
{
    button.layer.cornerRadius = 2.f;
    button.layer.masksToBounds = YES;
    button.layer.borderColor = SPSDKTextColor.CGColor;
    button.layer.borderWidth = 1.f;
    [button setTitleColor:SPSDKTextColor forState:UIControlStateNormal];
}

- (NSString *)refundTypeStringWithType:(NSInteger)type
{
    return type == 0 ? @"退款" : @"退款退货";
}

- (void)setModel:(SPSDKRefundDesc *)model
{
    _model = model;
    
    if (model.refundImgs.count)
    {
        _hasPicture = YES;
    }
    
    switch (model.status)
    {
        case SPSDKRefundStatusApplying: // 发起申请
        {
            self.line.hidden = NO;
            
            /*
             status    Integer    0
             refundType    Integer
             0表示退款，1表示退款退货
             createAt    Long    时间戳
             refundFee    Integer    退款金额
             refundImgUrls    List<String>    照片列表
             refundDesc    String    退款描述
             refundReason    String    退款原因
             */
            SPSDKRefundTableModel *tableModel = [[SPSDKRefundTableModel alloc] initWithTitle:@"退款类型"
                                                                                 detailTitle:[self refundTypeStringWithType:model.refundType]
                                                                                   imageUrls:nil];
            SPSDKRefundTableModel *tableModel1 = [[SPSDKRefundTableModel alloc] initWithTitle:@"退款原因"
                                                                                 detailTitle:model.refundReason
                                                                                   imageUrls:nil];
            SPSDKRefundTableModel *tableModel2 = [[SPSDKRefundTableModel alloc] initWithTitle:@"退款说明"
                                                                                 detailTitle:model.refundDesc
                                                                                   imageUrls:nil];
            SPSDKRefundTableModel *tableModel3 = [[SPSDKRefundTableModel alloc] initWithTitle:@"退款金额"
                                                                                  detailTitle:[NSString stringWithFormat:@"￥%.2f", model.refundFee / 100.f]
                                                                                   imageUrls:nil];
            SPSDKRefundTableModel *tableModel4 = [[SPSDKRefundTableModel alloc] initWithTitle:@"凭证图片"
                                                                                  detailTitle:nil
                                                                                    imageUrls:model.refundImgs];
            
            self.dataSource = [NSMutableArray arrayWithObjects:tableModel, tableModel1, tableModel2, tableModel3, model.refundImgs.count ? tableModel4 : nil, nil];
            
            if (_indexPath.section == 1)
            {
                self.btn1.hidden = NO;
                self.btn2.hidden = NO;
                self.btn3.hidden = YES;
                
                [self.btn1 setTitle:@"取消退款" forState:UIControlStateNormal];
                [self.btn2 setTitle:@"修改退款" forState:UIControlStateNormal];
            }
        }
            break;
            
        case SPSDKRefundStatusAgree: // 商家同意,等待发货
        {
            /*
             status    Integer    1
             refundType    Integer
             0表示退款，1表示退款退货
             createAt    Long    时间戳
             receiver    String    收货人
             receiverTelephone    String    收货电话
             receiverAddress    String    收货地址
             remark    String
             */
            
            if (model.refundType == SPSDKRefundTypeMoneyOnly)
            {
                self.line.hidden = YES;
            }
            else
            {
                self.line.hidden = NO;
            }
            
            SPSDKRefundTableModel *tableModel = [[SPSDKRefundTableModel alloc] initWithTitle:@"收货人"
                                                                                 detailTitle:model.receiver
                                                                                   imageUrls:nil];
            SPSDKRefundTableModel *tableModel1 = [[SPSDKRefundTableModel alloc] initWithTitle:@"联系电话"
                                                                                  detailTitle:model.receiverTelephone
                                                                                    imageUrls:nil];
            SPSDKRefundTableModel *tableModel2 = [[SPSDKRefundTableModel alloc] initWithTitle:@"退款地址"
                                                                                  detailTitle:model.receiverAddress
                                                                                    imageUrls:nil];
            SPSDKRefundTableModel *tableModel3 = [[SPSDKRefundTableModel alloc] initWithTitle:@"备注"
                                                                                  detailTitle:model.remark
                                                                                    imageUrls:nil];
            
            self.dataSource = [NSMutableArray arrayWithObjects:tableModel, tableModel1, tableModel2, tableModel3, nil];
            
            if (_indexPath.section == 1)
            {
                self.btn1.hidden = NO;
                self.btn2.hidden = NO;
                self.btn3.hidden = YES;
                
                [self.btn1 setTitle:@"取消退款" forState:UIControlStateNormal];
                [self.btn2 setTitle:@"填写物流" forState:UIControlStateNormal];
            }
        }
            break;
            
        case SPSDKRefundStatusSellerRejected: // 商家不同意/驳回
        {
            self.line.hidden = NO;
            
            /*
             status    Integer    2
             refundType    Integer
             0表示退款，1表示退款退货
             createAt    Long    时间戳
             rejectReason    String    驳回原因
             */
            SPSDKRefundTableModel *tableModel = [[SPSDKRefundTableModel alloc] initWithTitle:@"原因"
                                                                                 detailTitle:model.rejectReason
                                                                                   imageUrls:nil];
            
            self.dataSource = [NSMutableArray arrayWithObjects:tableModel, nil];
            
            if (_indexPath.section == 1)
            {
                self.btn1.hidden = NO;
                self.btn2.hidden = NO;
                self.btn3.hidden = YES;
                
                [self.btn1 setTitle:@"取消退款" forState:UIControlStateNormal];
                [self.btn2 setTitle:@"重新申请" forState:UIControlStateNormal];
            }
        }
            break;
            
        case SPSDKRefundStatusTransporting: // 退款商品寄送中
        {
            self.line.hidden = NO;
            
            /*
             status    Integer    3
             refundType    Integer
             0表示退款，1表示退款退货
             createAt    Long    时间戳
             transportId    String    物流单号
             expressCompanyName    String    物流公司
             */
            SPSDKRefundTableModel *tableModel = [[SPSDKRefundTableModel alloc] initWithTitle:@"退货运单号"
                                                                                 detailTitle:model.expressNo
                                                                                   imageUrls:nil];
            SPSDKRefundTableModel *tableModel1 = [[SPSDKRefundTableModel alloc] initWithTitle:@"承运方"
                                                                                 detailTitle:model.expressCompanyName
                                                                                   imageUrls:nil];
            
            self.dataSource = [NSMutableArray arrayWithObjects:tableModel, tableModel1, nil];
            
            if (_indexPath.section == 1)
            {
                self.btn1.hidden = NO;
                self.btn2.hidden = NO;
                self.btn3.hidden = NO;
                
                [self.btn1 setTitle:@"取消退款" forState:UIControlStateNormal];
                [self.btn2 setTitle:@"追踪物流" forState:UIControlStateNormal];
                [self.btn3 setTitle:@"修改物流" forState:UIControlStateNormal];
            }
        }
            break;
            
        case SPSDKRefundStatusSuccess: // 商家退款成功
        {
            self.line.hidden = NO;
            
            /*
             status    Integer    4
             refundType    Integer
             0表示退款，1表示退款退货
             createAt    Long    时间戳
             refundFee    Integer    退款金额
             successType    Integer
             0 商户退款
             1 超时退款
             */
            SPSDKRefundTableModel *tableModel = [[SPSDKRefundTableModel alloc] initWithTitle:@"退款金额"
                                                                                 detailTitle:[NSString stringWithFormat:@"￥%.2f", model.refundFee / 100.f]
                                                                                   imageUrls:nil];

            self.dataSource = [NSMutableArray arrayWithObjects:tableModel, nil];
            
            self.barView.hidden = YES;
            self.barConstraint.constant = 0.f;
            self.btn1.hidden = self.barView.hidden;
            self.btn2.hidden = self.barView.hidden;
            self.btn3.hidden = self.barView.hidden;
        }
            break;
            
        case SPSDKRefundStatusRefundClosed: // 关闭退款
        {
            /*
             status    Integer    5
             refundType    Integer
             0表示退款，1表示退款退货
             createAt    Long    时间戳
             remark    String    备注
             closeType    Integer
             0 商户关闭退款
             1 买家取消退款
             2 超时关闭退款
             */
            self.line.hidden = YES;
            
            self.barView.hidden = YES;
            self.barConstraint.constant = 0.f;
            self.btn1.hidden = self.barView.hidden;
            self.btn2.hidden = self.barView.hidden;
            self.btn3.hidden = self.barView.hidden;
        }
            break;
            
        case SPSDKRefundStatusRefunding: // 正在退款中
        {
            /*
             status=6 退款打款中
             字段    类型    说明
             createAt    Long    时间戳
             refundFee    Integer
             退款金额
             successType    Integer
             0 商户退款
             1 超时退款
             status    Integer    退款状态
             refundType    Integer
             0表示退款，1表示退款退货
             */
            self.line.hidden = NO;
            
            SPSDKRefundTableModel *tableModel = [[SPSDKRefundTableModel alloc] initWithTitle:@"退款金额"
                                                                                 detailTitle:[NSString stringWithFormat:@"￥%.2f", model.refundFee / 100.f]
                                                                                   imageUrls:nil];
            
            self.dataSource = [NSMutableArray arrayWithObjects:tableModel, nil];
            
            self.barView.hidden = YES;
            self.barConstraint.constant = 0.f;
            self.btn1.hidden = self.barView.hidden;
            self.btn2.hidden = self.barView.hidden;
            self.btn3.hidden = self.barView.hidden;
        }
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKRefundTableCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKRefundTableCellId];
    if (!cell)
    {
        cell = [SPSDKRefundTableCell loadInstanceFromNib];
    }
    cell.hasPicture = _hasPicture && indexPath.row == 4;
    cell.model = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 4)
    {
        SPSDKRefundTableModel *model = self.dataSource[indexPath.row];
        NSInteger row = ceilf((model.images.count + 1) / 4.0);
        return (ScreenWidth - 95 - 2 * 10) / 3 * row + 16.f;
    }
    else
    {
        return 30.f;
    }
}

- (IBAction)onBtnAction:(UIButton *)sender
{
    NSString *title = sender.titleLabel.text;
  
    if (self.actionHandler)
    {
        self.actionHandler(title, _model);
    }
}

@end
