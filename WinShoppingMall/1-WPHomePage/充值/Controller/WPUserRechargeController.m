//
//  WPUserRechargeController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/27.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserRechargeController.h"
#import "WPCardTableViewCell.h"
#import "Header.h"
#import "WPSuccessOrfailedController.h"
#import "WPPayCodeController.h"
#import "WPUserRateModel.h"
#import "WPUserRechargeView.h"
#import "WPQRCodeModel.h"
#import "WPPublicWebViewController.h"

@interface WPUserRechargeController () <UITextFieldDelegate>

//  支付方式
@property (nonatomic, copy) NSString *payType;

@property (nonatomic, strong) WPBankCardModel *cardModel;

@property (nonatomic, strong) WPUserRateModel *rateModel;

@property (nonatomic, strong) WPUserRechargeView *rechargeView;

@end

@implementation WPUserRechargeController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor cellColor];
    self.navigationItem.title = @"充值";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"userHelp"] style:UIBarButtonItemStylePlain target:self action:@selector(rightItemAction)];
    
    [self getPoundageData];
}

#pragma mark - Init

- (WPUserRechargeView *)rechargeView
{
    if (!_rechargeView) {
        _rechargeView = [[WPUserRechargeView alloc] initWithModel:self.rateModel];
        
        [_rechargeView.cardCell.backgroundButton addTarget:self action:@selector(selectWayAction) forControlEvents:UIControlEventTouchUpInside];

        [_rechargeView.moneyCell.textField addTarget:self action:@selector(moneyCellTextField) forControlEvents:UIControlEventEditingChanged];

        [_rechargeView.cvvCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];

        [_rechargeView.confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:_rechargeView];
    }
    return _rechargeView;
}


#pragma mark - Action

- (void)rightItemAction
{
    WPPublicWebViewController *vc = [[WPPublicWebViewController alloc] init];
    vc.navigationItem.title = @"用户帮助";
    vc.webUrl = [NSString stringWithFormat:@"%@/%@", WPBaseURL, WPUserHelpWebURL];
    [self.navigationController pushViewController:vc animated:YES];
}

//  动态计算手续费
- (void)moneyCellTextField
{
    self.rechargeView.poundageLabel.text = [NSString stringWithFormat:@"手续费：%@", [WPPublicTool stringPoundageWithString:self.rechargeView.moneyCell.textField.text rate:self.rateModel.rate]];
    [self changeButtonSurface];
}

//  动态设置按钮的外观以及是否可以点击
- (void)changeButtonSurface
{
    BOOL isEdabled = self.rechargeView.cvvCell.hidden ? ([self.rechargeView.moneyCell.textField.text floatValue] > 0 ? YES : NO) : (([self.rechargeView.moneyCell.textField.text floatValue] > 0 && self.rechargeView.cvvCell.textField.text.length == 3) ? YES : NO);
    [WPPublicTool buttonWithButton:self.rechargeView.confirmButton userInteractionEnabled:isEdabled];
}

- (void)selectWayAction
{
    __weakSelf
    [WPHelpTool showPayTypeWithAmount:nil card:^(WPBankCardModel *model)
    {
        weakSelf.rechargeView.cvvCell.hidden = [[NSString stringWithFormat:@"%d", model.cardType] isEqualToString:@"1"] ? NO : YES;
        //  获取payType以及改变weakSelf.rechargeView.cardCell内容
        weakSelf.payType = [WPPublicTool payCardWithView:weakSelf.rechargeView.cardCell model:model];
        weakSelf.cardModel = model;
    } other:^(id rowType)
    {
        weakSelf.rechargeView.cvvCell.hidden = YES;
        //  获取payType以及改变weakSelf.rechargeView.cardCell内容
        weakSelf.payType = [WPPublicTool payThirdWithView:weakSelf.rechargeView.cardCell rowType:rowType];
        weakSelf.cardModel = nil;
    }];
    
}

- (void)confirmButtonAction
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if ([self.rechargeView.moneyCell.textField.text floatValue] == 0 || self.rechargeView.moneyCell.textField.text.length == 0)
    {
        [WPProgressHUD showInfoWithStatus:@"请输入充值金额"];
    }
    else if ([self.rechargeView.cardCell.contentLabel.text isEqualToString:@"请选择充值方式"])
    {
        [WPProgressHUD showInfoWithStatus:@"请选择支付方式"];
    }
    else if (self.rechargeView.cvvCell.hidden == NO && self.rechargeView.cvvCell.textField.text.length != 3)
    {
        [WPProgressHUD showInfoWithStatus:@"请输入CVV码"];
    }
    else if ([self.rechargeView.moneyCell.textField.text floatValue] > 500 && [self.payType isEqualToString:@"2"] && ![WPJudgeTool isIDCardApprove])
    {
        [WPProgressHUD showInfoWithStatus:@"微信每次最多充值500元"];
    }
    else if ([self.rechargeView.moneyCell.textField.text floatValue] > 1000 && [self.payType isEqualToString:@"3"] && ![WPJudgeTool isIDCardApprove])
    {
        [WPProgressHUD showInfoWithStatus:@"支付宝每次最多充值1000元"];
    }
    else
    {
        if ([self.payType isEqualToString:@"1"])
        {
            __weakSelf
            [WPPayTool payWithTitle:[NSString stringWithFormat:@"充值金额:%@元", self.rechargeView.moneyCell.textField.text] password:^(id password) {
                [weakSelf pushWithChargeDataWithPassword:password];
            }];
        }
        else
        {
            [self pushWithChargeDataWithPassword:@""];
        }
        
    }
}


#pragma mark - Data

- (void)getPoundageData
{
    NSDictionary *parameter = @{
                                @"rateType" : @"1"
                                };
    __weakSelf
    [WPHelpTool getWithURL:WPPoundageURL parameters:parameter success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            weakSelf.rateModel = [WPUserRateModel mj_objectWithKeyValues:result];
            [weakSelf rechargeView];
        }
    } failure:^(NSError *error)
    {
        
    }];
}

- (void)pushWithChargeDataWithPassword:(NSString *)payPassword
{
    NSDictionary *parameters = @{
                                 @"rechargeAmount" : self.rechargeView.moneyCell.textField.text,
                                 @"payMethod" : self.payType,
                                 @"cardId" : self.cardModel.id ? [NSString stringWithFormat:@"%ld", (long)self.cardModel.id] : @"",
                                 @"cnv" : [WPPublicTool base64EncodeString:self.rechargeView.cvvCell.textField.text],
                                 @"payPassword" : [WPPublicTool base64EncodeString:payPassword]
                                 };
    [WPHelpTool postWithURL:WPRechargeURL parameters:parameters success:^(id success)
    {
        [WPHelpTool payResultControllerWithTitle:@"充值结果" successResult:success];

    } failure:^(NSError *error)
    {
        
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
