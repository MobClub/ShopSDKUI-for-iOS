//
//  SPSDKRefundPhotoFooterView.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/20.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKRefundPhotoFooterView.h"
#import "SPSDKAddPhotoCell.h"

static NSString *const SPSDKAddPhotoCellId = @"SPSDKAddPhotoCell";

@interface SPSDKRefundPhotoFooterView () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat height;

@end

@implementation SPSDKRefundPhotoFooterView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorForHex:0xf7f7f7];

    _height = (ScreenWidth - 30 - 3 * 10) / 4;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[SPSDKAddPhotoCell loadNib] forCellWithReuseIdentifier:SPSDKAddPhotoCellId];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKAddPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SPSDKAddPhotoCellId forIndexPath:indexPath];
    if (indexPath.row == self.photos.count)
    {
        cell.imageV.image = [UIImage imageNamed:@"addphoto"];
        cell.deleteBtn.hidden = YES;
    }
    else
    {
        cell.deleteBtn.hidden = NO;
        cell.imageV.image = self.photos[indexPath.row];
        cell.deleteBtn.tag = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(onDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_height, _height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.photos.count)
    {
        if (self.addPhotoHandler)
        {
            self.addPhotoHandler();
        }
    }
}

- (void)onDeleteAction:(UIButton *)sender
{
    if (self.deletePhotoHandler)
    {
        self.deletePhotoHandler(sender.tag);
    }
}

@end
