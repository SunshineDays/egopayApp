//
//  WPUserFeedBackController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/16.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserFeedBackController.h"
#import "Header.h"
#import "WPSelectCardButton.h"

@interface WPUserFeedBackController () <UITextViewDelegate>

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UIView *typeView;

@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) WPButton *confrirmButton;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) NSArray *typeArray;

@property (nonatomic, assign) NSInteger selectType;

@end

@implementation WPUserFeedBackController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cellColor];
    
    self.selectType = 1;
    self.imageArray = @[@"icon_selected_content_s", @"icon_selected_content_n"];
    self.typeArray = self.isFeedback ? @[@"提个建议", @"出错误啦", @"不好用", @"其它"] : @[@"不正当操作", @"发布不良信息", @"虚假交易", @"其它"];
    if (!self.isFeedback) {
        [self textField];
    }
    [self createTypeButton];
    [self textView];
    [self numberLabel];
    [self confrirmButton];
}

#pragma mark - Init

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(4, WPTopMargin, kScreenWidth - 8, WPRowHeight)];
        _textField.backgroundColor = [UIColor whiteColor];
        _textField.placeholder = @"请输入被举报的商户号或手机号";
        _textField.hidden = self.isFeedback;
        _textField.textColor = [UIColor blackColor];
        _textField.font = [UIFont systemFontOfSize:15];
        _textField.layer.borderColor = [UIColor lineColor].CGColor;
        _textField.layer.borderWidth = WPLineHeight;
        _textField.layer.cornerRadius = WPCornerRadius;
        _textView.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:_textField];
    }
    return _textField;
}

- (UIView *)typeView {
    if (!_typeView) {
        _typeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.isFeedback ? WPTopMargin : CGRectGetMaxY(self.textField.frame), kScreenWidth, 80)];
        [self.view addSubview:_typeView];
    }
    return _typeView;
}

- (void)createTypeButton {
    
    for (int i = 0; i < self.typeArray.count; i++) {
        
        UIButton *typeButton = [[WPSelectCardButton alloc] initWithFrame:CGRectMake(WPLeftMargin + kScreenWidth / 2 * (i % 2), 40 * (i / 2), 150, 40)];
        [typeButton setTitle:self.typeArray[i] forState:UIControlStateNormal];
        [typeButton setImage:[UIImage imageNamed:i == 0 ? self.imageArray[0] : self.imageArray[1]] forState:UIControlStateNormal];
        [typeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        typeButton.titleLabel.font = [UIFont systemFontOfSize:15];
        typeButton.tag = i;
        [typeButton addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.typeView addSubview:typeButton];
    }
}


- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(4, CGRectGetMaxY(self.typeView.frame), kScreenWidth - 8, 150)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.delegate = self;
        _textView.layer.masksToBounds = YES;
        _textView.layer.borderColor = [UIColor lineColor].CGColor;
        _textView.layer.borderWidth = 1.0f;
        _textView.layer.cornerRadius = WPCornerRadius;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.text = self.isFeedback ? @"请输入您的反馈内容(不少于20字儿)" : @"请输入您的举报内容(不少于20字儿)";
        _textView.textColor = [UIColor placeholderColor];
        
        _textView.scrollEnabled = YES;
        
        [self.view addSubview:_textView];
    }
    return _textView;
}

- (UILabel *)numberLabel {
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 68, 130, 60, 20)];
        _numberLabel.text = @"0/500";
        _numberLabel.textColor = [UIColor grayColor];
        _numberLabel.font = [UIFont systemFontOfSize:15];
        [self.textView addSubview:_numberLabel];
    }
    return _numberLabel;
}

- (WPButton *)confrirmButton {
    if (!_confrirmButton) {
        _confrirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.textView.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confrirmButton setTitle:@"提交" forState:UIControlStateNormal];
        [_confrirmButton addTarget:self action:@selector(confrirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confrirmButton];
    }
    return _confrirmButton;
}


#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:self.isFeedback ? @"请输入您的反馈内容(不少于20字儿)" : @"请输入您的举报内容(不少于20字儿)"]) {
        textView.text = @"";
    }
    textView.textColor = [UIColor blackColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = self.isFeedback ? @"请输入您的反馈内容(不少于20字儿)" : @"请输入您的举报内容(不少于20字儿)";
        textView.textColor = [UIColor placeholderColor];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/500", (unsigned long)textView.text.length];
}

#pragma mark - Action 

- (void)typeButtonClick:(UIButton *)button {
    for (int i = 0; i < self.typeArray.count; i++) {
        WPSelectCardButton *typeButton = self.typeView.subviews[i];
        if (button.tag == i) {
            [typeButton setImage:[UIImage imageNamed:self.imageArray[0]] forState:UIControlStateNormal];
            self.selectType = button.tag + 1;
        }
        else {
            [typeButton setImage:[UIImage imageNamed:self.imageArray[1]] forState:UIControlStateNormal];
        }
    }
}


- (void)confrirmButtonClick:(UIButton *)button {
    if (self.textView.text.length < 20) {
        [WPProgressHUD showInfoWithStatus:self.isFeedback ? @"反馈内容至少需要20个字儿" : @"举报内容至少需要20个字儿"];
    }
    else if (!([WPRegex validateMobile:self.textField.text] || self.textField.text.length == 6) && !self.isFeedback) {
        [WPProgressHUD showInfoWithStatus:@"手机号或商户号错误"];
    }
    else {
        self.isFeedback ? [self postUserFeedBackData] : [self postUserToReportData];
    }
}

#pragma mark - Data

- (void)postUserFeedBackData {
    NSDictionary *parameters = @{
                                 @"adviceType" : [NSString stringWithFormat:@"%ld", self.selectType],
                                 @"adviceContent" : self.textView.text
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPUserFeedBackURL parameters:parameters success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"]) {
            [WPProgressHUD showSuccessWithStatus:@"提交成功，感谢您的反馈"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else {
            [WPProgressHUD showInfoWithStatus:success[@"err_msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)postUserToReportData {
    NSDictionary *parameters = @{
                                 @"badMerNo" : [NSString stringWithFormat:@"%@", self.textField.text],
                                 @"reportType" : [NSString stringWithFormat:@"%ld", self.selectType],
                                 @"reportContent" : self.textView.text
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPUserToReportURL parameters:parameters success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"]) {
            [WPProgressHUD showSuccessWithStatus:@"提交成功，感谢您的反馈"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else {
            [WPProgressHUD showInfoWithStatus:success[@"err_msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
