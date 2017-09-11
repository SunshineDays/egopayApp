//
//  WPRechargeWebViewController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/9/8.®
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPRechargeWebViewController.h"
#import "Header.h"

@interface WPRechargeWebViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WPRechargeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"提交订单";
    //  此界面禁止使用右滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(popToRootViewController)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(popToRootViewController)];
    
    self.webView.delegate = self;
    
    __weakSelf
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.htmlString = [weakSelf.htmlString substringFromIndex:19];

        weakSelf.htmlString = [weakSelf.htmlString substringToIndex:weakSelf.htmlString.length - 14];
        
        [weakSelf.webView loadHTMLString:weakSelf.htmlString baseURL:nil];
    });
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

- (void)popToRootViewController
{
    //  开启右滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
