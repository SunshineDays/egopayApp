//
//  WPDelegateAgreementController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/5.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPDelegateAgreementController.h"
#import "Header.h"
#import "WPProductController.h"
#import "WPTitleView.h"

@interface WPDelegateAgreementController () <UIScrollViewDelegate>

@property (nonatomic, strong) WPTitleView *titleView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *agreementLabel;

@property (nonatomic, strong) WPButton *agreeButton;

@end

@implementation WPDelegateAgreementController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cellColor];
    [self titleView];
    [self agreementLabel];
    [self agreeButton];
}

#pragma mark - Init

- (WPTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[WPTitleView alloc] init];
        [_titleView.cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _titleView.titleLabel.text = @"代理协议";
        [self.view addSubview:_titleView];
    }
    return _titleView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight - WPButtonHeight - 20)];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UILabel *)agreementLabel {
    if (!_agreementLabel) {
        _agreementLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, 10, kScreenWidth - 2 * WPLeftMargin, [WPPublicTool textHeightFromTextString:self.agreementString width:kScreenWidth - 2 * WPLeftMargin miniHeight:WPRowHeight fontSize:15])];
        _agreementLabel.text = self.agreementString;
        _agreementLabel.numberOfLines = 0;
        _agreementLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        [self.scrollView addSubview:_agreementLabel];
        
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(_agreementLabel.frame));
    }
    return _agreementLabel;
}

- (WPButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, kScreenHeight - WPButtonHeight - 10, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_agreeButton setTitle:@"我已阅读并同意该协议" forState:UIControlStateNormal];
        [WPPublicTool buttonWithButton:_agreeButton userInteractionEnabled:YES];
        [_agreeButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_agreeButton];
    }
    return _agreeButton;
}

#pragma mark - Action

- (void)cancelButtonAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)agreeButtonClick:(UIButton *)button
{
    [self postUserAgreeData];
}

#pragma mark - Data

- (void)postUserAgreeData
{
    [WPProgressHUD showProgressWithStatus:@"提交中"];
    NSDictionary *parameter = @{
                                @"isAgreeAg" : @"1"
                                };
    __weakSelf
    [WPHelpTool postWithURL:WPDelegateURL parameters:parameter success:^(id success) {
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"]) {
            if (weakSelf.agreeBlock) {
                weakSelf.agreeBlock();
                [weakSelf cancelButtonAction];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
