//
//  WPNewFeatureViewController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/13.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPNewFeatureViewController.h"
#import "WPNewFeatureCell.h"

@interface WPNewFeatureViewController ()

@property (nonatomic, strong) NSArray *imageArray;

@end

@implementation WPNewFeatureViewController

static NSString * const reuseIdentifier = @"WPNewFeatureCellID";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupImages];
    [self setupCollectionView];
}

- (instancetype)init
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = [UIScreen mainScreen].bounds.size;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return [self initWithCollectionViewLayout:layout];
}

- (void)setupImages
{
    self.imageArray = @[@"guide1", @"guide2"];
}

- (void)setupCollectionView
{
    [self.collectionView registerClass:[WPNewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WPNewFeatureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    [cell setImages:self.imageArray index:indexPath.item];
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
