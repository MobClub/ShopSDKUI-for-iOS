//
//  SPSDKCourierCompanyViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/17.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKCourierCompanyViewController.h"
#import "SPSDKFillLogisticsHeader.h"
#import "SPSDKCourierCompanyCell.h"
#import "SPSDKTransportCompany+SPSDKExtension.h"

static NSString *const SPSDKCourierCompanyCellId = @"SPSDKCourierCompanyCell";

@interface SPSDKCourierCompanyViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet SPSDKTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic, strong) NSArray *keys;
@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) SPSDKTransportCompany *company;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation SPSDKCourierCompanyViewController

- (instancetype)initWithCompany:(SPSDKTransportCompany *)company
{
    self = [super init];
    if (self)
    {
        _company = company;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"承运方名称";
    
    self.bottomConstraint.constant = SPSDKiPhoneX ? 34.f : 0.f;
    
    if ([self.tableView respondsToSelector:@selector(setSectionIndexColor:)])
    {
        self.tableView.sectionIndexColor = SPSDKMainColor;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [ShopSDK queryTransportCompanyResult:^(NSArray<SPSDKTransportCompany *> *companyList, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSMutableArray *data = [NSMutableArray arrayWithArray:companyList];
            __weak typeof(self) weakSelf = self;
            [self getCompanyDictWithDatas:data handler:^(NSDictionary *dict, NSArray *keys) {
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                weakSelf.dict = [dict mutableCopy];
                weakSelf.keys = keys;
                [weakSelf.tableView reloadData];
            }];
        }
        else
        {
            [MBProgressHUD showTitle:error.message];
        }
    }];
    
    [self.sureBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateNormal];
    [self.sureBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateHighlighted];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *companyList = self.dict[self.keys[section]];
    return companyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKCourierCompanyCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKCourierCompanyCellId];
    if (!cell)
    {
        cell = [SPSDKCourierCompanyCell loadInstanceFromNib];
    }
    cell.indexPath = indexPath;
    NSArray *companyList = self.dict[self.keys[indexPath.section]];
    cell.hiddenLine = indexPath.row == companyList.count - 1;
    cell.model = companyList[indexPath.row];
    cell.didSelectHandler = ^(NSIndexPath *indexPath) {
        // 全部置NO
        [self.dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSArray * _Nonnull companyList, BOOL * _Nonnull stop) {
            for (SPSDKTransportCompany *company in companyList)
            {
                company.selected = NO;
            }
        }];
        NSArray *companyList = self.dict[self.keys[indexPath.section]];
        SPSDKTransportCompany *company = companyList[indexPath.row];
        company.selected = YES;
        [tableView reloadData];
        _company = company;
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SPSDKFillLogisticsHeader *header = [SPSDKFillLogisticsHeader loadInstanceFromNib];
    header.titleLabel.textColor = [UIColor blackColor];
    header.titleLabel.text = self.keys[section];
    return header;
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.keys[section];
}

- (IBAction)onSureAction:(id)sender
{
    if (_company.abbreviation && _company.companyId)
    {
        if (self.selectHandler)
        {
            self.selectHandler(_company);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [MBProgressHUD showTitle:@"请选择一个承运方名称"];
    }
}

#pragma mark - 快递公司分组排序

- (void)getCompanyDictWithDatas:(NSArray<SPSDKTransportCompany *> *)companyList handler:(void (^) (NSDictionary *dict, NSArray *keys))handler
{
    dispatch_queue_t queue = dispatch_queue_create("TransportCompany.com.queue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        for (SPSDKTransportCompany *company in companyList)
        {
            if (_company && _company.companyId == company.companyId)
            {
                company.selected = YES;
            }
            NSString *pinyin = [NSString getPinYinString:company.abbreviation];
            company.pinyin = pinyin;
            NSString *firstLetterString = [self getFirstLetterFromPinyin:pinyin];
            if (dict[firstLetterString])
            {
                [dict[firstLetterString] addObject:company];
            }
            else
            {
                NSMutableArray *arrGroupNames = [NSMutableArray arrayWithObject:company];
                [dict setObject:arrGroupNames forKey:firstLetterString];
            }
        }
        
        NSArray *nameKeys = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        NSMutableDictionary *sortDict = [NSMutableDictionary dictionary];
        // 排序分组内的元素
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSArray * _Nonnull companyList, BOOL * _Nonnull stop) {
           
            NSArray *sortCompanyList = [companyList sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
                SPSDKTransportCompany *model1 = obj1;
                SPSDKTransportCompany *model2 = obj2;
                NSComparisonResult result = [model1.pinyin compare:model2.pinyin];
                return result;
            }];
            
            sortDict[key] = sortCompanyList;
    
        }];
    
        if ([nameKeys.firstObject isEqualToString:@"#"])
        {
            NSMutableArray *mutableNamekeys = [NSMutableArray arrayWithArray:nameKeys];
            [mutableNamekeys insertObject:nameKeys.firstObject atIndex:nameKeys.count];
            [mutableNamekeys removeObjectAtIndex:0];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler)
                {
                    handler(sortDict, [mutableNamekeys copy]);
                }
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler)
            {
                handler(sortDict, nameKeys);
            }
        });
        
    });
}

- (NSString *)getFirstLetterFromPinyin:(NSString *)pinyin
{
    NSString *strPinYin = [pinyin uppercaseString];
    NSString *firstString = [strPinYin substringToIndex:1];
    NSString * regexA = @"^[A-Z]$";
    NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
    return [predA evaluateWithObject:firstString] ? firstString : @"#";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
