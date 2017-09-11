//
//  WPPublicWebViewController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/21.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPublicWebViewController.h"
#import "Header.h"

@interface WPPublicWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WPPublicWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.delegate = self;
    
    if ([[WPUserInfor sharedWPUserInfor].userPhone isEqualToString:@"18888888888"]) {
        self.webUrl = [NSString stringWithFormat:@"%@/%@", WPBaseURL, WPUserProtocolWebURL];
    }
    __weakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:weakSelf.webUrl]]];
        
//         [weakSelf.webView loadHTMLString:[WPUserInfor sharedWPUserInfor].userPhone baseURL:nil];
//        dataString = [dataString substringFromIndex:19];
//
//        dataString = [dataString substringToIndex:dataString.length - 3];
    });
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

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, WPTopY, kScreenWidth, kScreenHeight - WPNavigationHeight)];
        _webView.backgroundColor = [UIColor cellColor];
        [self.view addSubview:_webView];
    }
    return _webView;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.indicatorView stopAnimating];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
