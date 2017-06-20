//
//  WPPayPopupController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/21.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPayPopupController.h"
#import "Header.h"

#define kDotSize CGSizeMake (10, 10)  //密码黑点的大小
#define kDotCount 6  //密码个数

@interface WPPayPopupController () <UITextFieldDelegate>

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UILabel *lineLabel;

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
    
    [self titleLabel];
    [self cancelButton];
    [self lineLabel];
    [self moneyLabel];
    
    //输入密码框
    [self textField];
    [self initPwdTextField];
    [self forgetButton];
    
}

#pragma mark - Init

- (UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight / 4, kScreenWidth, kScreenHeight * 3 / 4)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView.layer.borderWidth = 1.0f;
        _bottomView.layer.borderColor = [UIColor lineColor].CGColor;
        _bottomView.userInteractionEnabled = YES;
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        _titleLabel.text = @"输入支付密码";
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:5];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.bottomView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 50, 50)];
        [_cancelButton setImage:[UIImage imageNamed:@"btn_x_content_n"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:_cancelButton];
    }
    return _cancelButton;
}

- (UILabel *)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), kScreenWidth, WPLineHeight)];
        _lineLabel.backgroundColor = [UIColor lineColor];
        [self.bottomView addSubview:_lineLabel];
    }
    return _lineLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineLabel.frame), kScreenWidth, 50)];
        _moneyLabel.text = self.titleString;
        _moneyLabel.textColor = [UIColor blackColor];
        _moneyLabel.font = [UIFont systemFontOfSize:15];
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
        _forgetButton.titleLabel.font = [UIFont systemFontOfSize:15];
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
    if([string isEqualToString:@"\n"])
    {
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

/**
 *  清除密码
 */
- (void)clearUpPassword
{
    self.textField.text = @"";
    [self textFieldDidChange:self.textField];
}

/**
 *  重置显示的点
 */
- (void)textFieldDidChange:(UITextField *)textField
{
//    NSLog(@"%@", textField.text);
    for (UIView *dotView in self.dotArray) {
        dotView.hidden = YES;
    }
    for (int i = 0; i < textField.text.length; i++) {
        ((UIView *)[self.dotArray objectAtIndex:i]).hidden = NO;
    }
    if (textField.text.length == kDotCount) {
//        NSLog(@"输入完毕");
        if (self.payPasswordBlock) {
            self.payPasswordBlock(textField.text);
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
