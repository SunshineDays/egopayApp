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
#import "WPBankCardController.h"
#import "WPRechargeWebViewController.h"

@interface WPUserRechargeController () <UITextFieldDelegate>

//  支付方式
@property (nonatomic, copy) NSString *payType;

//@property (nonatomic, strong) WPBankCardModel *cardModel;

@property (nonatomic, strong) WPUserRateModel *rateModel;

@property (nonatomic, strong) WPUserRechargeView *rechargeView;

@property (nonatomic, copy) NSString *depositCardID;

@property (nonatomic, copy) NSString *creditCradID;

/**  是否是第三方支付  */
@property (nonatomic, assign) BOOL isApp;

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

        [_rechargeView.depositCardCell.backgroundButton addTarget:self action:@selector(selectCardAction) forControlEvents:UIControlEventTouchUpInside];
        
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
    [WPPublicTool buttonWithButton:self.rechargeView.confirmButton userInteractionEnabled:[self.rechargeView.moneyCell.textField.text floatValue] > 0];
}

- (void)selectWayAction
{
    __weakSelf
    [WPHelpTool showPayTypeWithAmount:nil card:^(WPBankCardModel *model)
    {
        weakSelf.rechargeView.depositCardCell.hidden = NO;
        //  获取payType以及改变weakSelf.rechargeView.cardCell内容
        weakSelf.payType = [WPPublicTool payCardWithView:weakSelf.rechargeView.cardCell model:model];
//        weakSelf.cardModel = model;
        weakSelf.creditCradID = [NSString stringWithFormat:@"%ld", (long)model.id];
        weakSelf.isApp = NO;
    } other:^(id rowType)
    {
        weakSelf.rechargeView.depositCardCell.hidden = YES;
        //  获取payType以及改变weakSelf.rechargeView.cardCell内容
        weakSelf.payType = [WPPublicTool payThirdWithView:weakSelf.rechargeView.cardCell rowType:rowType];
        weakSelf.creditCradID = nil;
        weakSelf.isApp = YES;
    }];
    
}

- (void)selectCardAction
{
    WPBankCardController *vc = [[WPBankCardController alloc] init];
    vc.showCardType = @"3";
    __weakSelf
    vc.cardInfoBlock = ^(WPBankCardModel *model)
    {
        weakSelf.depositCardID = [NSString stringWithFormat:@"%ld", (long)model.id];
        [WPPublicTool payCardWithView:weakSelf.rechargeView.depositCardCell model:model];
    };
    [self.navigationController pushViewController:vc animated:YES];
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
            [self pushAppData];
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
                                 @"clientId" : [WPUserInfor sharedWPUserInfor].clientId,
                                 @"rechargeAmount" : self.rechargeView.moneyCell.textField.text,
                                 @"payMethod" : self.payType,
                                 @"receiveCardId" : self.depositCardID,
                                 @"payCardId" : self.creditCradID,
                                 @"payPassword" : [WPPublicTool base64EncodeString:payPassword]
                                 };
    
        NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
        __weakSelf
        NSBlockOperation *blockoperation = [NSBlockOperation blockOperationWithBlock:^{
            [WPProgressHUD showProgressIsLoading];
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            manager.requestSerializer.timeoutInterval = 40;
            [manager POST:[NSString stringWithFormat:@"%@/%@", WPBaseURL, WPRechargeURL]
               parameters:parameters
                 progress:^(NSProgress * _Nonnull uploadProgress)
             {
                 
             }
                  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
             {
                 [WPProgressHUD dismiss];
                 // 把\n转化为\\n
                 NSString *dataString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                 dataString = [dataString stringByReplacingOccurrencesOfString:@"" withString:@"\\n"];
                 
                 WPRechargeWebViewController *vc = [[WPRechargeWebViewController alloc] init];
                 vc.htmlString = dataString;
                 [weakSelf.navigationController pushViewController:vc animated:YES];
                 
                 NSData *resultData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
                 NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableContainers error:nil];
                 NSString *type = [NSString stringWithFormat:@"%@", dict[@"type"]];
                 if ([type isEqualToString:@"-1"])  //重新登录
                 {
                     [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationUserLogout object:nil];
                     [WPUserInfor sharedWPUserInfor].payTouchID = nil;
                     [[WPUserInfor sharedWPUserInfor] updateUserInfor];
                 }
                 else if (dict[@"result"][@"err_msg"])
                 {
                     [WPProgressHUD showInfoWithStatus:dict[@"result"][@"err_msg"]];
                 }
             }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
             {
                 [WPProgressHUD dismiss];
                 [WPProgressHUD showInfoWithStatus:@"网络错误,请重试"];
             }];
        }];
        [operationQueue addOperation:blockoperation];
    
}


- (void)pushAppData
{
    NSDictionary *parameters = @{
                                 @"rechargeAmount" : self.rechargeView.moneyCell.textField.text,
                                 @"payMethod" : self.payType,
                                 @"receiveCardId" : @"",
                                 @"payCardId" : @"",
                                 @"payPassword" : @""
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
