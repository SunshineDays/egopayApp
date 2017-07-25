//
//  WPMerchantApproveInforController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/11.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMerchantApproveInforController.h"
#import "Header.h"
#import "WPMerchantApproveInforView.h"
#import "WPMerchantApproveIforModel.h"

@interface WPMerchantApproveInforController ()

@property (nonatomic, strong) WPMerchantApproveInforView *inforView;

@property (nonatomic, strong) WPMerchantApproveIforModel *inforModel;

@end

@implementation WPMerchantApproveInforController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"认证信息";
    
    [self inforView];
}

- (WPMerchantApproveInforView *)inforView
{
    if (!_inforView) {
        _inforView = [[WPMerchantApproveInforView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_inforView];
    }
    return _inforView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
