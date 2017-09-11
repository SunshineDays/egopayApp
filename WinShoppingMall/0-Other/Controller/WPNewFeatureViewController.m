//
//  WPNewFeatureViewController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/13.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPNewFeatureViewController.h"
#import "WPNewFeatureCell.h"
#import "WPHelpTool.h"
#import "WPChooseInterface.h"

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
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.imageArray = @[@"iPhone_A", @"iPhone_B", @""];
    }
    else
    {
        self.imageArray = @[@"iPad_A", @"iPad_B", @""];
    }
}

- (void)setupCollectionView
{
    [self.collectionView registerClass:[WPNewFeatureCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > (self.imageArray.count - 2) * kScreenWidth) {
        [WPHelpTool rootViewController:[WPChooseInterface chooseRootViewController]];
        CATransition *transition = [CATransition animation];
        transition.type = @"pageCurl";
        transition.duration = 1;
        [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
