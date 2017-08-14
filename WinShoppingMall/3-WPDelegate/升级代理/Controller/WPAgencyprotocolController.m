//
//  WPAgencyprotocolController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/5.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPAgencyprotocolController.h"
#import "Header.h"
#import "WPProductController.h"
#import "WPTitleView.h"

@interface WPAgencyprotocolController () <UIWebViewDelegate>

@property (nonatomic, strong) WPTitleView *titleView;

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) WPButton *agreeButton;

@end

@implementation WPAgencyprotocolController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self titleView];
    
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", WPBaseURL, WPDelegateProtocolWebURL]]]];
    
    [self agreeButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.indicatorView startAnimating];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [WPPublicTool cleanCacheAndCookie];
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

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight - WPButtonHeight - 20)];
        _webView.backgroundColor = [UIColor cellColor];
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (WPButton *)agreeButton
{
    if (!_agreeButton) {
        _agreeButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, kScreenHeight - WPButtonHeight - 10, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_agreeButton setTitle:@"我已阅读并同意该协议" forState:UIControlStateNormal];
        [WPPublicTool buttonWithButton:_agreeButton userInteractionEnabled:YES];
        [_agreeButton addTarget:self action:@selector(agreeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_agreeButton];
    }
    return _agreeButton;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicatorView stopAnimating];
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
    [WPHelpTool postWithURL:WPAgencyURL parameters:parameter success:^(id success)
    {
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"])
        {
            if (weakSelf.agreeBlock)
            {
                weakSelf.agreeBlock();
                [weakSelf cancelButtonAction];
            }
        }
    } failure:^(NSError *error)
    {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
