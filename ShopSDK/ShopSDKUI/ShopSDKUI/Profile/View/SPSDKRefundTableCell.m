//
//  SPSDKRefundTableCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/10/18.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKRefundTableCell.h"
#import "SPSDKAddPhotoCell.h"
#import "SPSDKRefundTableModel.h"

static NSString *const SPSDKAddPhotoCellId = @"SPSDKAddPhotoCell";

@interface SPSDKRefundTableCell () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SPSDKRefundTableCell

- (NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setHasPicture:(BOOL)hasPicture
{
    _hasPicture = hasPicture;
    
    self.collectionView.hidden = !hasPicture;
    self.detailLabel.hidden = hasPicture;
}

- (void)setModel:(SPSDKRefundTableModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.detailTitle ? model.detailTitle : @"无";
    NSMutableArray *urls = [NSMutableArray array];
    for (SPSDKImage *image in model.images)
    {
        [urls addObject:image.src];
    }
    self.dataSource = [urls mutableCopy];
    [self.collectionView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerNib:[SPSDKAddPhotoCell loadNib] forCellWithReuseIdentifier:SPSDKAddPhotoCellId];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKAddPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SPSDKAddPhotoCellId forIndexPath:indexPath];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:self.dataSource[indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholdImage"]];
    cell.deleteBtn.hidden = YES;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth - 95 - 2 * 10) / 3, (ScreenWidth - 95 - 2 * 10) / 3);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
