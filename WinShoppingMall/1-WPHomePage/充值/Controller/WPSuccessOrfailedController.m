//
//  WPSuccessOrfailedController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/27.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPSuccessOrfailedController.h"
#import "Header.h"

@interface WPSuccessOrfailedController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation WPSuccessOrfailedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem WP_itemWithTarget:self action:nil image:nil highImage:nil];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem WP_itemWithTarget:self action:@selector(confrimButtonClick:) color:nil highColor:nil title:@"完成"];
    [self imageView];
    [self titleLabel];
    
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, WPNavigationHeight + 100, 100, 100)];
        _imageView.image = [UIImage imageNamed: self.showType == 2 ? @"icon_failure" : @"icon_selected_content1_n"];
        [self.view addSubview:_imageView];
    }
    return _imageView;
};

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 20, kScreenWidth, WPRowHeight)];
        
        if (!self.showType) {
            _titleLabel.text = @"提交成功";
        }
        else if (self.showType == 1) {
            _titleLabel.text = @"充值成功";
        }
        else if (self.showType == 2) {
        _titleLabel.text = @"充值失败";
        }
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}

#pragma mark - Action

- (void)confrimButtonClick:(UIButton *)button {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
