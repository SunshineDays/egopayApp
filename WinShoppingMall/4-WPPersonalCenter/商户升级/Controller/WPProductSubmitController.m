//
//  WPProductSubmitController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/6.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPProductSubmitController.h"

#import "Header.h"

#import "WPAddCardController.h"
#import "WPSuccessOrfailedController.h"
#import "WPPayCodeController.h"
#import "WPUserEnrollController.h"
#import "WPCardTableViewCell.h"

@interface WPProductSubmitController ()<UIPopoverPresentationControllerDelegate>

@property (nonatomic, strong) WPCustomRowCell *moneyCell;

@property (nonatomic, strong) WPCardTableViewCell *cardCell;

@property (nonatomic, strong) WPCustomRowCell *cvvCell;

@property (nonatomic, strong) WPButton *confirmButton;

@property (nonatomic, copy) NSString *payType;

@property (nonatomic, strong) WPBankCardModel *model;

/**
 *  判断代理／商户升级
 *  YES:代理  NO:商户
 */
@property (nonatomic, assign) BOOL isAgency;

@property (nonatomic, copy) NSString *userLv;

@property (nonatomic, copy) NSString *gradeMoney;

@end

@implementation WPProductSubmitController

- (void)initWithTitle:(NSString *)title userLv:(NSString *)userLv gradeMoney:(NSString *)gradeMoney isAgency:(BOOL)isAgency
{
    self.navigationItem.title = title;
    self.userLv = userLv;
    self.gradeMoney = gradeMoney;
    self.isAgency = isAgency;
}

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cellColor];

    [self confirmButton];
}

#pragma mark - Init



- (WPCardTableViewCell *)cardCell
{
    if (!_cardCell) {
        _cardCell = [[WPCardTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, WPTopY + 20, kScreenWidth, 80);
        [_cardCell tableViewCellImage:[UIImage imageNamed:@"icon_yinhang_n"] content:@"请选择支付方式" rectMake:rect];
        [_cardCell.backgroundButton addTarget:self action:@selector(wayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_cardCell];
    }
    return _cardCell;
}

- (WPCustomRowCell *)moneyCell
{
    if (!_moneyCell) {
        _moneyCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.cardCell.frame) + 20, kScreenWidth, WPRowHeight);
        [_moneyCell rowCellTitle:@"升级金额" contentTitle:[NSString stringWithFormat:@"¥%@", self.gradeMoney] rectMake:rect];
        _moneyCell.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_moneyCell];
    }
    return _moneyCell;
}

- (WPCustomRowCell *)cvvCell
{
    if (!_cvvCell) {
        _cvvCell = [[WPCustomRowCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.moneyCell.frame) + 20, kScreenWidth, WPRowHeight);
        [_cvvCell rowCellTitle:@"CVV码" placeholder:@"信用卡背面后三位数字" rectMake:rect];
        _cvvCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        _cvvCell.backgroundColor = [UIColor whiteColor];
        _cvvCell.hidden = YES;
        [self.view addSubview:_cvvCell];
    }
    return _cvvCell;
}

- (WPButton *)confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.cvvCell.frame) + 20, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
        [WPPublicTool buttonWithButton:_confirmButton userInteractionEnabled:YES];
        [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
    }
    return _confirmButton;
}

#pragma mark - Action

- (void)wayButtonClick:(UIButton *)button
{
    __weakSelf
    [WPHelpTool showPayTypeWithAmount:self.gradeMoney card:^(WPBankCardModel *model)
    {
        weakSelf.model = model;
        weakSelf.cvvCell.hidden = [[NSString stringWithFormat:@"%d", model.cardType] isEqualToString:@"1"] ? NO : YES;
        weakSelf.payType = [WPPublicTool payCardWithView:self.cardCell model:model];
        weakSelf.model = model;
    } other:^(id rowType)
    {
        weakSelf.cvvCell.hidden = YES;
        weakSelf.payType = [WPPublicTool payThirdWithView:self.cardCell rowType:rowType];
        weakSelf.model = nil;
    }];
}

- (void)confirmButtonAction:(UIButton *)button
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if ([self.cardCell.contentLabel.text isEqualToString:@"请选择支付方式"])
    {
        [WPProgressHUD showInfoWithStatus:@"请选择支付方式"];
    }
    else if (self.cvvCell.hidden == NO && self.cvvCell.textField.text.length != 3)
    {
        [WPProgressHUD showInfoWithStatus:@"请输入CVV码"];
    }
    else
    {
        if ([self.payType isEqualToString:@"1"] || [self.payType isEqualToString:@"4"])
        {
            __weakSelf
            [WPPayTool payWithTitle:[NSString stringWithFormat:@"支付金额:%@元", self.gradeMoney] password:^(id password) {
                [weakSelf pushMerchantGradeDataWithPayPassword:password];

            }];
        }
        else
        {
            [self pushMerchantGradeDataWithPayPassword:@""];
        }
    }
}


#pragma mark - Data

- (void)pushMerchantGradeDataWithPayPassword:(NSString *)payPassword
{
    NSDictionary *parameters = @{
                                 @"uplvId" :  self.userLv,
                                 @"payMethod" : self.payType,
                                 @"cnv" : self.cvvCell.textField.text.length == 0 ? @"" : [WPPublicTool base64EncodeString:self.cvvCell.textField.text],
                                 @"cardId" : self.model.id ? [NSString stringWithFormat:@"%ld", (long)self.model.id] : @"",
                                 @"payPassword" : [WPPublicTool base64EncodeString:payPassword]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:self.isAgency ? WPAgencyGradeURL : WPMerchantGradeURL parameters:parameters success:^(id success)
    {
        [WPHelpTool payResultControllerWithTitle:weakSelf.isAgency ? @"代理升级结果" : @"商户升级结果" successResult:success];
    } failure:^(NSError *error)
    {
        
    }];
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
