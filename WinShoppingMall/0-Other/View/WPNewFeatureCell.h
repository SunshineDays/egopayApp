//
//  WPNewFeatureCell.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/10.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPNewFeatureCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *imageView;

@property (nonatomic, weak) UIButton *startButton;

- (void)setImages:(NSArray *)imagesArray index:(NSUInteger)index;

@end
