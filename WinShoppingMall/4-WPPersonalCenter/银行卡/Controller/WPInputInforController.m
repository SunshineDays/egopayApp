//
//  WPEditInforController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/9.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPInputInforController.h"
#import "Header.h"

@interface WPInputInforController ()

@property (nonatomic, strong) UITextField *textField;

@end

@implementation WPInputInforController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor tableViewColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveClick)];
    
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
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, WPTopY + 30, kScreenWidth, WPRowHeight)];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WPLeftMargin, 0)];
        _textField.leftViewMode = UITextFieldViewModeAlways;
        if ([self.navigationItem.title isEqualToString:@"开户银行"]) {
            _textField.placeholder = @"请输入开户银行";
        }
        else {
            _textField.text = self.placeholder;
        }
        _textField.clearButtonMode = UITextFieldViewModeAlways;
        _textField.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        [self.view addSubview:_textField];
    }
    return _textField;
}

#pragma mark - Action

- (void)saveClick
{
    if ([self.navigationItem.title isEqualToString:@"电子邮箱"])
    {
        if (![WPJudgeTool validateEmail:self.textField.text])
        {
            [WPProgressHUD showInfoWithStatus:@"电子邮箱格式错误"];
        }
        else
        {
            if (self.inforBlock)
            {
                self.inforBlock(self.textField.text);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
    else
    {
        if (self.textField.text.length == 0)
        {
            [WPProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"请输入%@", self.navigationItem.title]];
        }
        else
        {
            if (self.inforBlock)
            {
                self.inforBlock(self.textField.text);
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
