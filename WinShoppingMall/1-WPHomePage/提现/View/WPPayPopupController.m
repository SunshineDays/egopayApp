//
//  WPPayPopupController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/21.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPayPopupController.h"
#import "Header.h"
#import "WPPopupTitleView.h"
#import <IQKeyboardManager/IQKeyboardManager.h>

#define kDotSize CGSizeMake (10, 10)  //密码黑点的大小
#define kDotCount 6  //密码个数

@interface WPPayPopupController () <UITextFieldDelegate>

@property (nonatomic, strong) WPPopupTitleView *titleView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIButton *forgetButton;

@property (nonatomic, strong) NSMutableArray *dotArray;

// 密码框高度
@property (nonatomic, assign) float rowHeight;

@end

@implementation WPPayPopupController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRGBString:@"#000000" alpha:0.3];

    self.rowHeight = (kScreenWidth - 2 * WPLeftMargin) / kDotCount;
    
    [self.textField becomeFirstResponder];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    
    [self titleView];
    [self moneyLabel];
    
    //输入密码框
    [self textField];
    [self initPwdTextField];
    [self forgetButton];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;  //点击背景隐藏键盘
}

#pragma mark - Init

- (WPPopupTitleView *)titleView
{
    if (!_titleView) {
        _titleView = [[WPPopupTitleView alloc] init];
        _titleView.titleLabel.text = @"输入支付密码";
        [_titleView.imageButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_titleView];
    }
    return _titleView;
}

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(self.titleView.frame))];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.userInteractionEnabled = YES;
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _moneyLabel.text = self.titleString;
        _moneyLabel.textColor = [UIColor blackColor];
        _moneyLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        [self.bottomView addSubview:_moneyLabel];
    }
    return _moneyLabel;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.moneyLabel.frame), kScreenWidth - 2 * WPLeftMargin, self.rowHeight)];
        _textField.backgroundColor = [UIColor whiteColor];
        //输入的文字颜色为白色
        _textField.textColor = [UIColor whiteColor];
        //输入框光标的颜色为白色
        _textField.tintColor = [UIColor whiteColor];
        _textField.delegate = self;
        _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        _textField.layer.borderColor = [[UIColor lineColor] CGColor];
        _textField.layer.borderWidth = 1;
        [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.bottomView addSubview:_textField];
    }
    return _textField;
}

- (UIButton *)forgetButton
{
    if (!_forgetButton) {
        _forgetButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth - 100, CGRectGetMaxY(self.textField.frame) + 10, 100 - WPLeftMargin, WPButtonHeight)];
        [_forgetButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        [_forgetButton addTarget:self action:@selector(forgetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_forgetButton];
    }
    return _forgetButton;
}

- (void)initPwdTextField
{
    //生成分割线
    for (int i = 0; i < kDotCount - 1; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (i + 1) * self.rowHeight, CGRectGetMinY(self.textField.frame), 1, self.rowHeight)];
        lineView.backgroundColor = [UIColor lineColor];
        [self.bottomView addSubview:lineView];
    }
    
    self.dotArray = [[NSMutableArray alloc] init];
    //生成中间的点
    for (int i = 0; i < kDotCount; i++) {
        UIView *dotView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.textField.frame) + (self.rowHeight - kDotCount) / 2 + i * self.rowHeight, CGRectGetMinY(self.textField.frame) + (self.rowHeight - kDotSize.height) / 2, kDotSize.width, kDotSize.height)];
        dotView.backgroundColor = [UIColor blackColor];
        dotView.layer.cornerRadius = kDotSize.width / 2.0f;
        dotView.clipsToBounds = YES;
        dotView.hidden = YES; //先隐藏
        [self.bottomView addSubview:dotView];
        //把创建的黑色点加入到数组中
        [self.dotArray addObject:dotView];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([string isEqualToString:@"\n"]) {
        //按回车关闭键盘
        [textField resignFirstResponder];
        return NO;
    } else if(string.length == 0) {
        //判断是不是删除键
        return YES;
    }
    else if(textField.text.length >= kDotCount) {
        //输入的字符个数大于6，则无法继续输入，返回NO表示禁止输入
        return NO;
    } else {
        return YES;
    }
}


//  清除密码
- (void)clearUpPassword
{
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
}


//  重置显示的点
- (void)textFieldDidChange:(UITextField *)textField
{
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
    }
    if (textField.text.length == kDotCount) {
        if (self.payPasswordBlock) {
            self.payPasswordBlock(textField.text);
            if ([WPAppTool isPayTouchID]) {
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark - Action

- (void)cancelButtonAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)forgetButtonClick:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.forgetPasswordBlock) {
        self.forgetPasswordBlock();
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
