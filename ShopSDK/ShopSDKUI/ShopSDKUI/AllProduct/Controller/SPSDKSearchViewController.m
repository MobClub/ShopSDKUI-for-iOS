//
//  SPSDKSearchViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/22.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKSearchViewController.h"
#import "SPSDKSearchView.h"
#import "SPSDKSearchTagView.h"
#import "SPSDKSearchHeader.h"

static NSString *const SPSDKSearchProductKey = @"SPSDKSearchProduct";
static NSString *const SPSDKSearchOrderKey = @"SPSDKSearchOrder";
static NSString *const SPSDKSearchRefundKey = @"SPSDKSearchRefund";

@interface SPSDKSearchViewController ()

@property (nonatomic, weak) SPSDKSearchView *searchView;
@property (nonatomic, strong) SPSDKSearchTagView *tagView;
@property (nonatomic, strong) SPSDKSearchHeader *header;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) SPSDKSearchType type;

@end

@implementation SPSDKSearchViewController

- (instancetype)initWithSearchType:(SPSDKSearchType)type
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self)
    {
        _type = type;
    }
    return self;
}

- (void)dealSearchKey:(NSString *)keyWords
{
    if ([NSString isNullOrEmpty:keyWords])
    {
        return;
    }
    
    NSInteger index = -1;
    for (int i = 0; i < self.dataSource.count; i++)
    {
        NSString *indexStr = self.dataSource[i];
        if ([indexStr isEqualToString:keyWords])
        {
            index = i;
            break;
        }
    }
    
    if (index >= 0)
    {
        [self.dataSource removeObjectAtIndex:index];
    }
    
    if (self.dataSource.count > 0)
    {
        [self.dataSource insertObject:keyWords atIndex:0];
    }
    else
    {
        [self.dataSource addObject:keyWords];
    }

    [self saveSearchHistory];
}

- (NSMutableArray *)readSearchHistory
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self key]];
}

- (NSString *)key
{
    NSString *key = nil;
    switch (_type) {
        case SPSDKSearchTypeProduct:
            key = SPSDKSearchProductKey;
            break;
        case SPSDKSearchTypeOrder:
            key = SPSDKSearchOrderKey;
            break;
        case SPSDKSearchTypeRefund:
            key = SPSDKSearchRefundKey;
            break;
        default:
            break;
    }
    return key;
}

- (void)saveSearchHistory
{
    [[NSUserDefaults standardUserDefaults] setObject:self.dataSource forKey:[self key]];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray arrayWithArray:[self readSearchHistory]];
    }
    return _dataSource;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 1 , 0 );
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createNavigatioItem:SPSDKNavItemTypeTitle name:@"取消" isLeft:NO];
    
    __weak typeof(self) weakSelf = self;
    SPSDKSearchView *searchView = [SPSDKSearchView loadInstanceFromNib];
    searchView.searchKey = _searchKey;
    searchView.needClick = NO;
    self.navigationItem.titleView = searchView;
    _searchView = searchView;

    _searchView.searchHandler = ^(NSString *key) {
        [weakSelf dealSearchKey:key];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        if (weakSelf.searchHandler)
        {
            weakSelf.searchHandler(key);
        }
    };
    searchView.frame = CGRectMake(0, 0, ScreenWidth - 100, 29);

    self.header = [SPSDKSearchHeader loadInstanceFromNib];
    [self.view addSubview:self.header];
    self.header.deleteHandler = ^{
        weakSelf.header.hidden = YES;
        [weakSelf.tagView calculateHeightWithTitles:nil];
        [weakSelf.dataSource removeAllObjects];
        [weakSelf saveSearchHistory];
    };
    self.header.hidden = self.dataSource.count == 0;
    
    self.tagView = [[SPSDKSearchTagView alloc] init];
    [self.view addSubview:self.tagView];
    self.tagView.clickTagHandler = ^(NSInteger index, NSString *key) {
        [weakSelf dealSearchKey:key];
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        if (weakSelf.clickTagHandler)
        {
            weakSelf.clickTagHandler(index, key);
        }
    };
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    self.header.frame = CGRectMake(0, 0, ScreenWidth, 30);
    self.tagView.frame = CGRectMake(0, 30, ScreenWidth - 20, [self.tagView calculateHeightWithTitles:self.dataSource]);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.searchView.textField becomeFirstResponder];
}

- (void)onRightBtnAction:(UIButton *)sender
{
    [self.searchView.textField resignFirstResponder];

    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.cancelHandler)
    {
        self.cancelHandler(self.searchView.textField.text);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
