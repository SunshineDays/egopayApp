//
//  WPEditInforController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/9.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMoreBankController.h"
#import "Header.h"

@interface WPMoreBankController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;


@end

@implementation WPMoreBankController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    
    [self initLineView];
    [self textField];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textField becomeFirstResponder];
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(WPLeftMargin, WPNavigationHeight + 50, kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
        _textField.placeholder = @"请输入银行名称";
        _textField.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _textField.delegate = self;
        [self.view addSubview:_textField];
    }
    return _textField;
}

- (void)initLineView
{
    for (int i = 0; i < 2; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight + 50 - 1 + 50 * i, kScreenWidth, 1)];
        lineView.backgroundColor = [UIColor lineColor];
        [self.view addSubview:lineView];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [WPRegex validateReplacementString:string];
}

#pragma mark - Action

- (void)saveClick
{
    if (self.textField.text.length == 0) {
        [WPProgressHUD showInfoWithStatus:@"请输入银行名称"];
    }
    else {
        if (self.inforBlock) {
            self.inforBlock(self.textField.text);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
