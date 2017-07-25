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
#import "WPGatheringCodeController.h"
#import "WPRechargeStateController.h"
#import "WPUserRateModel.h"
#import "WPUserRechargeView.h"
#import "WPQRCodeModel.h"

@interface WPUserRechargeController () <UITextFieldDelegate>

//  支付方式
@property (nonatomic, copy) NSString *payType;

@property (nonatomic, strong) WPBankCardModel *model;

@property (nonatomic, strong) WPUserRateModel *rateModel;

@property (nonatomic, strong) WPUserRechargeView *rechargeView;

@end

@implementation WPUserRechargeController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor cellColor];
    self.navigationItem.title = @"充值";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"限额说明" style:UIBarButtonItemStylePlain target:self action:@selector(rechargeStateAction)];
    
    [self getPoundageData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.rechargeView.moneyCell.textField becomeFirstResponder];
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

- (void)rechargeStateAction
{
    WPRechargeStateController *vc = [[WPRechargeStateController alloc] init];
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
    if (self.rechargeView.cvvCell.hidden)
    {
        [WPPublicTool buttonWithButton:self.rechargeView.confirmButton userInteractionEnabled:[self.rechargeView.moneyCell.textField.text floatValue] > 0 ? YES : NO];
    }
    else
    {
        [WPPublicTool buttonWithButton:self.rechargeView.confirmButton userInteractionEnabled:([self.rechargeView.moneyCell.textField.text floatValue] > 0 && self.rechargeView.cvvCell.textField.text.length == 3) ? YES : NO];
    }
}

- (void)selectWayAction
{
    __weakSelf
    [WPHelpTool showPayTypeWithAmount:nil navigationController:self.navigationController Card:^(WPBankCardModel *model)
    {
        weakSelf.rechargeView.cvvCell.hidden = [[NSString stringWithFormat:@"%d", model.cardType] isEqualToString:@"1"] ? NO : YES;
        //  获取payType以及改变weakSelf.rechargeView.cardCell内容
        weakSelf.payType = [WPPublicTool payCardWithView:weakSelf.rechargeView.cardCell model:model];
    } other:^(id rowType)
    {
        weakSelf.rechargeView.cvvCell.hidden = YES;
        //  获取payType以及改变weakSelf.rechargeView.cardCell内容
        weakSelf.payType = [WPPublicTool payThirdWithView:weakSelf.rechargeView.cardCell rowType:rowType];
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
            if ([WPJudgeTool isPayTouchID])
            {
                __weakSelf
                [WPHelpTool payWithTouchIDsuccess:^(id success)
                {
                    [weakSelf pushWithChargeDataWithPassword:success];
                } failure:^(NSError *error)
                {
                    [weakSelf showPayPopupView];
                }];
            }
            else
            {
                [self showPayPopupView];
            }
        }
        else
        {
            [self pushWithChargeDataWithPassword:@""];
        }
    }
}

- (void)showPayPopupView
{
    __weakSelf
    [WPHelpTool showPayPasswordViewWithTitle:[NSString stringWithFormat:@"充值金额:%@元", self.rechargeView.moneyCell.textField.text] navigationController:self.navigationController success:^(id success)
    {
        [weakSelf pushWithChargeDataWithPassword:success];
    }];
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
                                 @"cardId" : [NSString stringWithFormat:@"%ld", (long)self.model.id] ? [NSString stringWithFormat:@"%ld", (long)self.model.id] : @"",
                                 @"cnv" : [WPPublicTool base64EncodeString:self.rechargeView.cvvCell.textField.text],
                                 @"payPassword" : [WPPublicTool base64EncodeString:payPassword]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPRechargeURL parameters:parameters success:^(id success)
    {
        
        [WPHelpTool payResultControllerWithTitle:@"充值结果" successResult:success navigationController:weakSelf.navigationController];

    } failure:^(NSError *error)
    {
        
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
