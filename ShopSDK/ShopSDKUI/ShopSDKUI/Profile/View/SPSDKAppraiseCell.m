//
//  SPSDKAppraiseCell.m
//  ShopSDKUI
//
//  Created by LeeJay on 2017/9/26.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "SPSDKAppraiseCell.h"
#import "SPSDKAddPhotoCell.h"
#import "SPSDKStarView.h"
#import "SPSDKAppraiseModel.h"
#import "SPSDKTextView.h"

static NSString *const SPSDKAddPhotoCellId = @"SPSDKAddPhotoCell";

@interface SPSDKAppraiseCell () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SPSDKStarViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *anonymousBtn;
@property (weak, nonatomic) IBOutlet UILabel *topLine;
@property (weak, nonatomic) IBOutlet UILabel *bottomLine;
@property (weak, nonatomic) IBOutlet SPSDKStarView *starView;
@property (weak, nonatomic) IBOutlet SPSDKTextView *commentTextView;

@end

@implementation SPSDKAppraiseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.starView.delegate = self;
    self.commentTextView.delegate = self;
    
    self.topLine.backgroundColor = SPSDKLineColor;
    self.bottomLine.backgroundColor = SPSDKLineColor;
    
    [self.collectionView registerNib:[SPSDKAddPhotoCell loadNib] forCellWithReuseIdentifier:SPSDKAddPhotoCellId];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setModel:(SPSDKAppraiseModel *)model
{
    _model = model;
    
    self.starView.scorePercent = model.commentStars / 5.f;
    self.commentTextView.text = model.comment;
    self.anonymousBtn.selected = model.anonymity;
    
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _model.photos.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SPSDKAddPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SPSDKAddPhotoCellId forIndexPath:indexPath];
    if (indexPath.row == _model.photos.count)
    {
        cell.imageV.image = [UIImage imageNamed:@"addphoto"];
        cell.deleteBtn.hidden = YES;
    }
    else
    {
        cell.deleteBtn.hidden = NO;
        cell.imageV.image = _model.photos[indexPath.row];
        cell.deleteBtn.tag = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(onDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth - 30 - 3 * 10) / 4, (ScreenWidth - 30 - 3 * 10) / 4);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _model.photos.count)
    {
        if (self.addPhotoHandler)
        {
            self.addPhotoHandler(_section);
        }
    }
}

- (void)onDeleteAction:(UIButton *)sender
{
    if (self.deletePhotoHandler)
    {
        self.deletePhotoHandler(sender.tag, _section);
    }
}

- (IBAction)onAnonymousAction:(UIButton *)sender
{
    if (self.anonymousHandler)
    {
        self.anonymousHandler(_model.anonymity, _section);
    }
}

- (void)starView:(SPSDKStarView *)starView scorePercent:(CGFloat)scorePercent
{
    if (self.selectStarHandler)
    {
        self.selectStarHandler(5 * scorePercent, _section);
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.textViewHandler)
    {
        self.textViewHandler(textView.text, _section);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
