//
//  SPSDKFilterCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/26.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKFilterCell.h"
#import "SPSDKFilterItemCell.h"
#import "SPSDKProductLabel+SPSDKExtension.h"
#import "SPSDKTransportStrategy+SPSDKExtension.h"


static NSString *const SPSDKFilterItemCellId = @"SPSDKFilterItemCell";

@interface SPSDKFilterCell () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation SPSDKFilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.collectionView registerNib:[SPSDKFilterItemCell loadNib] forCellWithReuseIdentifier:SPSDKFilterItemCellId];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setDatas:(NSArray *)datas
{
    _datas = datas;
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKFilterItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SPSDKFilterItemCellId forIndexPath:indexPath];
    
    id model = self.datas[indexPath.row];
    NSString *title = nil;
    
    if ([model isKindOfClass:[SPSDKProductLabel class]])
    {
        SPSDKProductLabel *label = (SPSDKProductLabel *)model;
        [cell setSelected:NO isMultiple:YES];
        title = label.labelName;
    }
    else if ([model isKindOfClass:[SPSDKTransportStrategy class]])
    {
        SPSDKTransportStrategy *strategy = (SPSDKTransportStrategy *)model;
        [cell setSelected:NO isMultiple:NO];
        title = strategy.strategyName;
    }
    
    cell.title = title;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SPSDKFilterContentWidth - 30 - 10 - 10) / 3, 30);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKFilterItemCell *cell = (SPSDKFilterItemCell *)[collectionView cellForItemAtIndexPath:indexPath];

    id model = _datas[indexPath.row];
    
    if ([model isKindOfClass:[SPSDKProductLabel class]])
    {
        SPSDKProductLabel *label = (SPSDKProductLabel *)model;
        
        label.selected = !label.selected;
        
        [cell setSelected:label.selected isMultiple:YES];
    }
    
    if ([model isKindOfClass:[SPSDKTransportStrategy class]])
    {
        SPSDKTransportStrategy *strategy = (SPSDKTransportStrategy *)model;
        strategy.selected = !strategy.selected;
        
        [cell setSelected:strategy.selected isMultiple:NO];

        [_datas enumerateObjectsUsingBlock:^(SPSDKTransportStrategy *theStrategy, NSUInteger idx, BOOL * _Nonnull stop) {

            if (![theStrategy isEqual:strategy])
            {
                theStrategy.selected = NO;
            }
            
        }];
        
        NSArray *cells = [collectionView visibleCells];
        [cells enumerateObjectsUsingBlock:^(SPSDKFilterItemCell *theCell, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (![theCell isEqual:cell])
            {
                [theCell setSelected:NO isMultiple:NO];

            }
            
        }];
        
    }
  
}


@end
