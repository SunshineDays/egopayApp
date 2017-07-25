//
//  WPPayTypeController.h
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBaseViewController.h"
#import "WPBankCardModel.h"

@interface WPPayTypeController : WPBaseViewController

/**
 *  交易金额
 */
@property (nonatomic, assign) float amount;

/**
 *  是否支持余额支付
 */
@property (nonatomic, assign) BOOL isBalance;

/**
 *  微信/支付宝/QQ钱包/余额
 */
@property (nonatomic, copy) void(^userPayTypeBlock)(NSInteger payTypeRow);

/**
 *  银行卡
 */
@property (nonatomic, copy) void(^userCardBlock)(WPBankCardModel *model);

/**
 *  添加银行卡
 */
@property (nonatomic, copy) void(^userAddCardBlock)();


@end


////添加银行卡
//vc.userAddCardBlock = ^{
//    //  判断是否通过实名认证
//    if ([WPJudgeTool isIDCardApprove]) {
//        //  有密码
//        if ([WPJudgeTool isPayPassword]) {
//            WPAddCardController *vc = [[WPAddCardController alloc] init];
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        }
//        //  没有密码
//        else {
//            WPPasswordController *vc = [[WPPasswordController alloc] init];
//            [weakSelf.navigationController pushViewController:vc animated:YES];
//        }
//    }
//    else {
//        [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
//    }
//};

//- (void)addCardSuccess:(NSNotification *)notification {
//    NSString *cardNumber = [WPPublicTool base64DecodeString:notification.userInfo[@"cardNumber"]];
//    cardNumber = [cardNumber substringFromIndex:cardNumber.length - 4];
//    [self.wayCell.button setTitle:[NSString stringWithFormat:@"%@(尾号%@)", notification.userInfo[@"bankName"], cardNumber] forState:UIControlStateNormal];
//    [self judgeCardType:notification.userInfo[@"cardType"]];
//    self.payType = @"1";
//    self.cardId = notification.userInfo[@"cardId"];
//}
