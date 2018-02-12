//
//  SPSDKAppraiseViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/13.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKAppraiseViewController.h"
#import "SPSDKAppraiseCell.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"
#import "SPSDKAppraiseModel.h"

static NSString *const SPSDKAppraiseCellId = @"SPSDKAppraiseCell";

@interface SPSDKAppraiseViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet SPSDKGroupTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) SPSDKOrder *order;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SPSDKAppraiseViewController

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (instancetype)initWithOrder:(SPSDKOrder *)order
{
    self = [super init];
    if (self)
    {
        _order = order;
    }
    return self;
}

- (UIImagePickerController *)imagePickerVc
{
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bottomConstraint.constant = SPSDKiPhoneX ? 34.f : 0.f;
    
    self.title = @"评价";
    
    _height = (ScreenWidth - 30 - 3 * 10) / 4;
    
    [self.submitBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateNormal];
    [self.submitBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateHighlighted];
    
    for (SPSDKTradingCommodity *tradingCommodity in _order.orderCommodityList)
    {
        SPSDKAppraiseModel *model = [SPSDKAppraiseModel new];
        model.anonymity = YES;
        model.orderCommodityId = tradingCommodity.orderCommodityId;
        model.commodityId = tradingCommodity.commodity.commodityId;
        [self.dataSource addObject:model];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKAppraiseCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKAppraiseCellId];
    if (!cell)
    {
        cell = [SPSDKAppraiseCell loadInstanceFromNib];
    }
    SPSDKTradingCommodity *tradingCommodity = _order.orderCommodityList[indexPath.section];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:tradingCommodity.commodity.image.src] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];
    cell.section = indexPath.section;
    
    SPSDKAppraiseModel *model = self.dataSource[indexPath.section];
    cell.model = model;
    
    cell.addPhotoHandler = ^(NSInteger section) {
        _section = section;
        [self showActionSheet];
    };
    
    cell.deletePhotoHandler = ^(NSInteger index, NSInteger section) {
        SPSDKAppraiseModel *model = self.dataSource[section];
        [model.selectedAssets removeObjectAtIndex:index];
        [model.photos removeObjectAtIndex:index];
        [tableView reloadData];
    };
    
    cell.selectStarHandler = ^(NSInteger star, NSInteger section) {
        SPSDKAppraiseModel *model = self.dataSource[section];
        model.commentStars = star;
    };
    
    cell.anonymousHandler = ^(BOOL anonymous, NSInteger section) {
        SPSDKAppraiseModel *model = self.dataSource[section];
        model.anonymity = !anonymous;
        [tableView reloadData];
    };
    
    cell.textViewHandler = ^(NSString *text, NSInteger section) {
        SPSDKAppraiseModel *model = self.dataSource[section];
        model.comment = text;
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

- (IBAction)onSubmitAction:(id)sender
{
    NSMutableArray *comments = [NSMutableArray array];
    for (SPSDKAppraiseModel *model in self.dataSource)
    {
        if (model.commentStars)
        {
            if (!model.comment)
            {
                switch (model.commentStars)
                {
                    case 1:
                        model.comment = @"差评";
                        break;
                    case 2:
                    case 3:
                    case 4:
                        model.comment = @"中评";
                        break;
                    case 5:
                        model.comment = @"好评";
                        break;
                    default:
                        break;
                }
            }
            
            SPSDKProductComment *comment = [[SPSDKProductComment alloc] initWithOrderCommodityId:model.orderCommodityId
                                                                                     commodityId:model.commodityId
                                                                                         comment:model.comment
                                                                                           stars:model.commentStars
                                                                                      submitImgs:model.photos
                                                                                     isAnonymity:model.anonymity];
            
            [comments addObject:comment];
        }
        
    }
    
    if (!comments.count)
    {
        [MBProgressHUD showTitle:@"请选择评分和评论内容再提交"];
        return;
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ShopSDK addCommentWithOrder:_order
                        comments:comments
                          result:^(NSError *error) {
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              if (!error)
                              {
                                  [MBProgressHUD showTitle:@"评价成功"];
                                  [self.navigationController popViewControllerAnimated:YES];
                                  if (self.appraiseHandler)
                                  {
                                      self.appraiseHandler(_indexSection);
                                  }
                              }
                              else
                              {
                                  [MBProgressHUD showTitle:error.message];
                              }
                          }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKAppraiseModel *model = self.dataSource[indexPath.section];
    NSInteger row = ceilf((model.photos.count + 1) / 4.0);
    return 258.f + row * _height + (row - 1) * 10.f;
}

- (void)showActionSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"去相册选择", nil];
    [sheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self takePhoto];
    }
    else if (buttonIndex == 1)
    {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:10 delegate:self];
        imagePickerVc.allowPickingVideo = NO;
        SPSDKAppraiseModel *model = self.dataSource[_section];
        imagePickerVc.selectedAssets = model.selectedAssets;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

            SPSDKAppraiseModel *model = self.dataSource[_section];
            model.photos = [photos mutableCopy];
            model.selectedAssets = [assets mutableCopy];
            [self.tableView reloadData];
            
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerController

- (void)takePhoto
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later)
    {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    }
    else if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        if (iOS7Later)
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        }
        else
        {
            [self takePhoto];
        }
    }
    else if ([TZImageManager authorizationStatus] == 2)
    { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        alert.tag = 1;
        [alert show];
    }
    else if ([TZImageManager authorizationStatus] == 0)
    { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    }
    else
    {
        [self pushImagePickerController];
    }
}

// 调用相机
- (void)pushImagePickerController
{
    // 提前定位
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(CLLocation *location, CLLocation *oldLocation) {
        _location = location;
    } failureBlock:^(NSError *error) {
        _location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later)
        {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    }
    else
    {
        SPSDKLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    SPSDKAppraiseModel *model = self.dataSource[_section];
    if (model.photos.count >= 10)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"你最多只能选择10张照片"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"])
    {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error){
            if (error)
            {
                [tzImagePickerVc hideProgressHUD];
                SPSDKLog(@"图片保存失败 %@",error);
            }
            else
            {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image
{
    SPSDKAppraiseModel *model = self.dataSource[_section];
    [model.selectedAssets addObject:asset];
    [model.photos addObject:image];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
