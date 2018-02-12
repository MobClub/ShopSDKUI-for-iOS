//
//  SPSDKApplyRefundViewController.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/20.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKApplyRefundViewController.h"
#import "SPSDKShopCartCell.h"
#import "SPSDKApplyRefundCell.h"
#import "SPSDKApplyRefundFooterView.h"
#import "SPSDKRefundPhotoFooterView.h"
#import "SPSDKPickerView.h"
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "TZLocationManager.h"

static NSString *const SPSDKShopCartCellId = @"SPSDKShopCartCell";
static NSString *const SPSDKApplyRefundCellId = @"SPSDKApplyRefundCell";

@interface SPSDKApplyRefundViewController () <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet SPSDKGroupTableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (nonatomic, strong) SPSDKPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) SPSDKTradingCommodity *model;
@property (nonatomic, copy) NSString *refundReason;
@property (nonatomic, copy) NSString *refundType;
@property (nonatomic, copy) NSString *refundInstruction;
@property (nonatomic, strong) SPSDKPreRefund *preRefund;
@property (nonatomic, assign) NSUInteger fee;
@property (nonatomic, copy) NSString *feeStr;
@property (nonatomic, strong) SPSDKTradingCommodity *commodity;
@property (nonatomic, assign) BOOL isModify;

@end

@implementation SPSDKApplyRefundViewController

- (instancetype)initWithOrderCommodity:(SPSDKTradingCommodity *)commodity isModify:(BOOL)isModify
{
    self = [super init];
    if (self)
    {
        _commodity = commodity;
        _isModify = isModify;
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

- (NSMutableArray *)photos
{
    if (!_photos)
    {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (NSMutableArray *)selectedAssets
{
    if (!_selectedAssets)
    {
        _selectedAssets = [NSMutableArray array];
    }
    return _selectedAssets;
}

- (SPSDKPickerView *)pickerView
{
    if (!_pickerView)
    {
        _pickerView = [[SPSDKPickerView alloc] initWithPickerType:SPSDKPickerTypeOther];
    }
    return _pickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bottomConstraint.constant = SPSDKiPhoneX ? 34.f : 0.f;
    
    _height = (ScreenWidth - 30 - 3 * 10) / 4;

    self.title = _isModify ? @"修改退款" : @"申请退款";
    [self.submitBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateNormal];
    [self.submitBtn setBackgroundImage:[UIImage gradientImageFromSize:CGSizeMake(ScreenWidth, 45)] forState:UIControlStateHighlighted];
    
    [self requestData];
}

- (void)requestData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ShopSDK refundPreviewWithOrderCommodity:_commodity result:^(SPSDKPreRefund *preRefund, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!error)
        {
            _preRefund = preRefund;
            _model = preRefund.orderCommodity;
            _fee = preRefund.maxRefundMoney;
            _feeStr = [NSString stringWithFormat:@"%.2f", _preRefund.maxRefundMoney / 100.f];
            [self.tableView reloadData];
        }
        else
        {
            [MBProgressHUD showTitle:error.message];
        }
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        SPSDKShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKShopCartCellId];
        if (!cell)
        {
            cell = [SPSDKShopCartCell loadInstanceFromNib];
        }
        cell.isEditing = NO;
        cell.hiddenSelectBtn = YES;
        cell.model = _model;
        return cell;
    }
    else
    {
        SPSDKApplyRefundCell *cell = [tableView dequeueReusableCellWithIdentifier:SPSDKApplyRefundCellId];
        cell.indexPath = indexPath;
        if (!cell)
        {
            cell = [SPSDKApplyRefundCell loadInstanceFromNib];
        }
        if (indexPath.section == 1)
        {
            cell.prefixLabel.text = nil;
            cell.textField.enabled = NO;
            cell.hasArrow = YES;
        }
        else if (indexPath.section == 2)
        {
            cell.prefixLabel.text = @"￥";
            cell.textField.enabled = YES;
            cell.textField.keyboardType = UIKeyboardTypeDecimalPad;
            cell.hasArrow = NO;
        }
        else
        {
            cell.prefixLabel.text = nil;
            cell.textField.enabled = YES;
            cell.hasArrow = NO;
        }
        
        if (indexPath.section == 1)
        {
            if (indexPath.row == 0)
            {
                cell.titleLabel.text = @"退款类型";
                cell.textField.placeholder = @"请选择";
                if (_refundType)
                {
                    cell.textField.text = _refundType;
                }
            }
            else
            {
                cell.hiddenLine = YES;
                cell.titleLabel.text = @"退款原因";
                cell.textField.placeholder = @"请选择";
                if (_refundReason)
                {
                    cell.textField.text = _refundReason;
                }
            }
        }
        else if (indexPath.section == 2)
        {
            cell.hiddenLine = YES;
            cell.titleLabel.text = @"退款金额";
            cell.textField.text = _feeStr;
        }
        else
        {
            cell.hiddenLine = YES;
            cell.titleLabel.text = @"退款说明";
            cell.textField.placeholder = @"请输入退款原因";
        }
        cell.textFieldInputHandler = ^(NSString *text, NSIndexPath *indexPath) {
            if (indexPath.section == 3)
            {
                _refundInstruction = text;
            }
            else if (indexPath.section == 2)
            {
                _feeStr = text;

                if ([text isNumber])
                {
                    if (([text floatValue] * 100) > _preRefund.maxRefundMoney)
                    {
                        _fee = NSNotFound;
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退款金额大于最大退款金额，请修改"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:nil
                                                              otherButtonTitles:@"确定", nil];
                        [alert show];
                    }
                    else
                    {
                        _fee = (NSInteger)([text floatValue] * 100);
                    }
                }
                else
                {
                    _fee = 0;
                    [MBProgressHUD showTitle:@"退款金额必须为数字"];
                }
            }
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 115.f;
    }
    else
    {
        return 42.f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 2)
    {
        SPSDKApplyRefundFooterView *footerView = [SPSDKApplyRefundFooterView loadInstanceFromNib];
        if (section == 0)
        {
            footerView.titleLabel.textColor = SPSDKMainColor;
            footerView.titleLabel.text = @"*建议与客服充分沟通后发起退款流程";
        }
        else
        {
            footerView.titleLabel.textColor = SPSDKTextColor;
            footerView.titleLabel.text = [NSString stringWithFormat:@"最多￥%.2f，含运费￥%.2f", _preRefund.maxRefundMoney / 100.f, _preRefund.freight / 100.f];
        }
        
        return footerView;
    }
    
    if (section == 3)
    {
        SPSDKRefundPhotoFooterView *footerView = [SPSDKRefundPhotoFooterView loadInstanceFromNib];
        footerView.photos = [self.photos copy];
        footerView.addPhotoHandler = ^{
            [self showActionSheet];
        };
        footerView.deletePhotoHandler = ^(NSInteger index) {
            [_selectedAssets removeObjectAtIndex:index];
            [_photos removeObjectAtIndex:index];
            [_tableView reloadData];
        };
        return footerView;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section == 2)
    {
        return 30.f;
    }
    
    if (section == 3)
    {
        NSInteger row = ceilf((_photos.count + 1) / 4.0);
        return 72.f + row * _height + (row - 1) * 10.f;
    }

    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        __weak typeof(self) weakSelf = self;
        if (indexPath.row == 0)
        {
            [self.view endEditing:YES];
            self.pickerView.titles = _preRefund.supportedType == SPSDKSupportedRefundTypeMoneyOnly ? @[@"仅退款"] : @[@"仅退款", @"退货退款"];
            self.pickerView.selectValue = _refundType;
            self.pickerView.valueDidSelectHandler = ^(NSString *title) {
                weakSelf.refundType = title;
                [tableView reloadData];
            };
            [self.pickerView show];
        }
        else
        {
            [self.view endEditing:YES];
            self.pickerView.titles = @[@"不想要了", @"与卖家描述不符", @"少发/漏发", @"发错货", @"未按约定时间发货", @"其它"];
            self.pickerView.selectValue = _refundReason;
            self.pickerView.valueDidSelectHandler = ^(NSString *title) {
                weakSelf.refundReason = title;
                [tableView reloadData];
            };
            [self.pickerView show];
        }
    }
}

- (void)showActionSheet
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
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
        imagePickerVc.selectedAssets = self.selectedAssets;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
            self.photos = [photos mutableCopy];
            self.selectedAssets = [assets mutableCopy];
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
    
    if (self.photos.count >= 10)
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
    [self.selectedAssets addObject:asset];
    [self.photos addObject:image];
    [self.tableView reloadData];
}

- (IBAction)onSubmitAction:(id)sender
{
    SPSDKApplyRefundCell *cell1 = (SPSDKApplyRefundCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    _refundInstruction = cell1.textField.text;
    
    SPSDKRefundType type = NSNotFound;
    
    if ([_refundType isEqualToString:@"仅退款"])
    {
        type = SPSDKRefundTypeMoneyOnly;
    }
    else if ([_refundType isEqualToString:@"退货退款"])
    {
        type = SPSDKRefundTypeAll;
    }
    
    if (type == NSNotFound)
    {
        [MBProgressHUD showTitle:@"请选择退款类型"];
        return;
    }
    
    if (!_refundReason)
    {
        [MBProgressHUD showTitle:@"请选择退款原因"];
        return;
    }
    
    if (!_fee)
    {
        [MBProgressHUD showTitle:@"退款金额必须为数字"];
        return;
    }
    else if (_fee == NSNotFound)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退款金额大于最大退款金额，请修改"
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"确定", nil];
        [alert show];
        return;
    }
    
    if (!_refundInstruction)
    {
        [MBProgressHUD showTitle:@"请输入退款说明"];
        return;
    }
    
    SPSDKRefundReason *reason = [[SPSDKRefundReason alloc] initWithType:type
                                                                 reason:_refundReason
                                                                   desc:_refundInstruction
                                                                    fee:_fee
                                                                 images:_photos];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ShopSDK refundWithOrderCommodity:_model
                         refundReason:reason
                               result:^(NSError *error) {
                                   [MBProgressHUD hideHUDForView:self.view animated:YES];
                                   if (!error)
                                   {
                                       [MBProgressHUD showTitle:_isModify ? @"修改退款成功" : @"申请退款成功"];
                                       [self.navigationController popViewControllerAnimated:YES];
                                       
                                       if (self.refundHandler)
                                       {
                                           self.refundHandler(_indexPath);
                                       }
                                   }
                                   else
                                   {
                                       [MBProgressHUD showTitle:error.message];
                                   }
                               }];
}

@end
