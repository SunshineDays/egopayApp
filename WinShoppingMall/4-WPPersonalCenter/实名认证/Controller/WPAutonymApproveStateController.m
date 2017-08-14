//
//  WPAutonymApproveStateController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/23.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPAutonymApproveStateController.h"

 
#import "WPApproveLoadPhotoController.h"

#import "Header.h"

@interface WPAutonymApproveStateController ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) WPButton *nextButton;


@end

@implementation WPAutonymApproveStateController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"上传身份证照片";
    [self imageView];
    [self nextButton];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WPLeftMargin, WPTopY + WPLeftMargin, kScreenWidth - 2 * WPLeftMargin, (kScreenWidth - 2 * WPLeftMargin) * 346 / 350)];
        [_imageView setImage:[UIImage imageNamed:@"icon_zhengming_n"]];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (WPButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.imageView.frame) + 40, kScreenWidth - 2 * WPLeftMargin, 40)];
        [_nextButton setTitle:@"上传手持身份证半身照（正面带头像）" forState:UIControlStateNormal];
        [WPPublicTool buttonWithButton:_nextButton userInteractionEnabled:YES];
        [_nextButton addTarget:self action:@selector(loadPhotoButtonClik) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nextButton];
    }
    return _nextButton;
}



- (void)loadPhotoButtonClik
{
    WPApproveLoadPhotoController *vc = [[WPApproveLoadPhotoController alloc] init];
    vc.isIDCard = YES;
    vc.navigationItem.title = @"认证身份信息";
    vc.idCardDic = self.idCardDic;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
