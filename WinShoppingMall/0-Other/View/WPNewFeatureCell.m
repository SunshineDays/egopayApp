//
//  WPNewFeatureCell.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/10.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPNewFeatureCell.h"
#import "UIView+WPExtension.h"
#import "WPTabBarController.h"
#import "UIColor+WPColor.h"
#import "WPChooseInterface.h"
#import "WPHelpTool.h"

@implementation WPNewFeatureCell

- (void)setImages:(NSArray *)imagesArray index:(NSUInteger)index
{
    self.imageView.image = [UIImage imageNamed:imagesArray[index]];
    self.startButton.hidden = (index != (imagesArray.count - 2));
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = [UIScreen mainScreen].bounds;
    
    self.startButton.xc_width = 150;
    self.startButton.xc_height = 60;
    self.startButton.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height * 0.87);
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self.contentView addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (UIButton *)startButton
{
    if (!_startButton) {
        UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [startButton addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:startButton];
        _startButton = startButton;
    }
    return _startButton;
}

- (void)startButtonClick:(UIButton *)button
{
    [WPHelpTool rootViewController:[WPChooseInterface chooseRootViewController]];
    CATransition *transition = [CATransition animation];
    transition.type = @"pageCurl";
    transition.duration = 1;
    [[UIApplication sharedApplication].keyWindow.layer addAnimation:transition forKey:nil];
}



@end
