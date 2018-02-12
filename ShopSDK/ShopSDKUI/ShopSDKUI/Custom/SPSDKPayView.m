//
//  SPSDKPayView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/17.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKPayView.h"
#import "SPSDKPayCell.h"
#import "SPSDKPayModel.h"
#import "SPSDKUIPayConfig.h"


static NSString *const SPSDKPayCellId = @"SPSDKPayCellId";

@interface SPSDKPayView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIView *contentView;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UILabel *totalPriceLabel;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) SPSDKPayType payType;

@end

@implementation SPSDKPayView

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        NSMutableArray *models = [NSMutableArray array];
        
        if ([SPSDKUIPayConfig defaultConfig].payTypes.count == 0)
        {
            for (int i = 0; i < 1; i++)
            {
                SPSDKPayModel *model = [SPSDKPayModel new];
                switch (i) {
                    case 0:
                    {
                        model.selected = YES;
                        model.payPlatform = @"支付宝支付";
                        model.payType = SPSDKPayTypeAlipay;
                        model.icon = @"zhifubao";
                    }
                        break;
                    case 1:
                    {
                        model.selected = NO;
                        model.payPlatform = @"微信支付";
                        model.payType = SPSDKPayTypeWechat;
                        model.icon = @"weixzhifu";
                    }
                        break;
                    default:
                        break;
                }
                [models addObject:model];
            }

        }
        else
        {
            [[SPSDKUIPayConfig defaultConfig].payTypes enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                SPSDKPayModel *model = [SPSDKPayModel new];
                model.selected = YES;
                switch ([obj unsignedIntegerValue])
                {
                    case 22:
                        model.payPlatform = @"微信支付";
                        model.payType = SPSDKPayTypeWechat;
                        model.icon = @"weixzhifu";
                        break;
                    case 50:
                        model.payPlatform = @"支付宝支付";
                        model.payType = SPSDKPayTypeAlipay;
                        model.icon = @"zhifubao";
                        break;
                    default:
                        break;
                }
                
                if (model.payType != 0)
                {
                    [models addObject:model];
                }
                
            }];
            
        }
        
        
        _dataSource = [NSMutableArray arrayWithArray:models];
    }
    return _dataSource;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        _padding = SPSDKiPhoneX ? 34.f : 0.f;
        _height = _padding + 230.f - 44.f;
        _payType = SPSDKPayTypeAlipay;
        [self configureUI];
    }
    return self;
}

- (void)configureUI
{
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, _height)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contentView];
    [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] init]];
    
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 42.f)];
    [self.contentView addSubview:barView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, barView.bottom, ScreenWidth, 1.f)];
    [self.contentView addSubview:line];
    line.backgroundColor = [UIColor colorForString:@"#dddddd"];
    
    UILabel *label = [[UILabel alloc] init];
    [barView addSubview:label];
    label.font = [UIFont systemFontOfSize:14.f];
    label.text = @"请选择支付方式";
    [label sizeToFit];
    label.center = barView.center;
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [barView addSubview:cancelBtn];
    [cancelBtn addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [cancelBtn sizeToFit];
    cancelBtn.right = ScreenWidth - 14.f;
    cancelBtn.centerY = label.centerY;
    cancelBtn.enlargeRadius = 10.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 43.f, ScreenWidth, 142.f - 44.f) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:self.tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 52.f)];
    self.totalPriceLabel = [[UILabel alloc] initWithFrame:headerView.bounds];
    [headerView addSubview:self.totalPriceLabel];
    self.totalPriceLabel.textAlignment = NSTextAlignmentCenter;
    self.totalPriceLabel.font = [UIFont systemFontOfSize:13.f];
    self.tableView.tableHeaderView = headerView;
    
    UIButton *payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:payBtn];
    payBtn.frame = CGRectMake(0, _tableView.bottom, ScreenWidth, 45.f);
    UIImage *image = [UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45.f)];
    [payBtn setBackgroundImage:image forState:UIControlStateNormal];
    [payBtn setBackgroundImage:image forState:UIControlStateHighlighted];
    [payBtn setTitle:@"确认付款" forState:UIControlStateNormal];
    [payBtn addTarget:self action:@selector(onPay) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setPrice:(float)price
{
    _price = price;
    
    self.totalPriceLabel.attributedText = [self priceStringWithTotalPrice:price];
}

- (void)setOrder:(SPSDKOrder *)order
{
    _order = order;
    
    self.totalPriceLabel.attributedText = [self priceStringWithTotalPrice:order.paidMoney / 100.f];
}

- (NSAttributedString *)priceStringWithTotalPrice:(float)totalPrice
{
    NSString *priceStr = [NSString stringWithFormat:@"支付总金额￥%.2f元", totalPrice];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:priceStr];
    [attributedStr addAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] } range:NSMakeRange(0, 5)];
    [attributedStr addAttributes:@{ NSForegroundColorAttributeName : SPSDKMainColor } range:NSMakeRange(5, priceStr.length - 6)];
    [attributedStr addAttributes:@{ NSForegroundColorAttributeName : [UIColor blackColor] } range:NSMakeRange(priceStr.length - 1, 1)];
    return [attributedStr copy];
}

#pragma mark - Action

- (void)onPay
{
    if (self.payHandler)
    {
        self.payHandler(_order, _payType, _price);
    }
}

- (void)onCancel
{
    if (self.cancelHandler)
    {
        self.cancelHandler(_order);
    }
    [self removeSelfFromSupView];
}

- (void)show
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, ScreenHeight - _height, ScreenWidth, _height);
    }];
}

- (void)hide
{
    [self removeSelfFromSupView];
}

- (void)removeSelfFromSupView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, _height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKPayCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKPayCellId];
    if (!cell)
    {
        cell = [SPSDKPayCell loadInstanceFromNib];
    }
    cell.indexPath = indexPath;
    cell.model = self.dataSource[indexPath.row];
    cell.didSelectHandler = ^(NSIndexPath *indexPath) {
        for (SPSDKPayModel *model in self.dataSource)
        {
            model.selected = NO;
        }
        SPSDKPayModel *model = self.dataSource[indexPath.row];
        model.selected = YES;
        _payType = model.payType;
        [tableView reloadData];
    };
    return cell;
}

@end
