//
//  WPJpushServiceController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/22.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPJpushServiceController.h"
#import "Header.h"
#import "WPTabBarController.h"
#import "WPNotificationBillDetailModel.h"
#import "WPNotificationMessageModel.h"
#import "WPNoticifationApproveModel.h"
#import "WPNotificationMerchantModel.h"
#import "WPNotificationCardModel.h"
#import "WPTouchIDShowController.h"

@interface WPJpushServiceController ()

@property (nonatomic, strong) UILabel *messageContenLabel;

//  账单详情
@property (nonatomic, strong) WPNotificationBillDetailModel *billModel;

//  系统消息
@property (nonatomic, strong) WPNotificationMessageModel *messageModel;

//  实名认证
@property (nonatomic, strong) WPNoticifationApproveModel *approveModel;

//  商家认证
@property (nonatomic, strong) WPNotificationMerchantModel *merchantModel;

//  银行卡认证
@property (nonatomic, strong) WPNotificationCardModel *cardModel;

@end

@implementation WPJpushServiceController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [WPUserInfor sharedWPUserInfor].userInfoDict = nil;

    NSString *target = self.resultDict[@"bis_result"][@"target"];
    
    if ([target isEqualToString:@"trade_detail"] || [target isEqualToString:@"qr_bill"]) {
        [self getBillData];
    }
    else if ([target isEqualToString:@"sys_notice"]) {
        [self getMessageData];
    }
    else if ([target isEqualToString:@"authenticate"]) {
        [self getApproveData];
    }
    else if ([target isEqualToString:@"mer_cert"]) {
        [self getMerchantData];
    }
    else if ([target isEqualToString:@"card_list"]) {
        [self getCardData];
    }
}

#pragma mark - Init

#pragma mark - 账单详情

- (void)initBillHeaderLabel
{
    NSArray *headerArray = self.billModel.counterFee > 0 ? @[@"付款金额", @"手续费", @"可提现金额", @"当前状态", @"交易类型", @"支付方式", @"支付时间", @"账单编号", @"备        注"] : @[@"付款金额", @"当前状态", @"交易类型", @"支付方式", @"支付时间", @"账单编号", @"备        注"];
    for (int i = 0; i < headerArray.count; i++) {
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, WPTopMargin + 40 * i, 100, 40)];
        headerLabel.text = headerArray[i];
        headerLabel.textColor = [UIColor darkGrayColor];
        headerLabel.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:headerLabel];
    }
}

- (void)initBillContentLabel
{
    
    NSString *moneyString = [NSString stringWithFormat:@"%.2f", self.billModel.amount];
    
    NSString *poundageString = [NSString stringWithFormat:@"%.2f", self.billModel.counterFee];
    
    NSString *trueMoneyString = [NSString stringWithFormat:@"%.2f", self.billModel.avl_amount];
    
    NSArray *stateArray = @[@"失败", @"成功", @"取消", @"待处理", @"待确认", @"待返回", @"异常单", @" ", @" "];
    NSString *stateString = stateArray[self.billModel.payState];
    
    NSArray *typeArray = @[@" ", @"充值", @"转账", @"还款", @"提现到卡", @"付款", @"二维码收款", @"退款", @"提现到余额", @"商户升级", @"代理升级", @"", @""];
    NSString *typeString = typeArray[self.billModel.tradeType];
    
    NSArray *wayArray = @[@" ", @"银行卡", @"微信", @"支付宝", @"余额", @"国际信用卡", @"QQ钱包", @" ", @" "];
    NSString *wayString = wayArray[self.billModel.paychannelid];
    
    NSString *dateString = self.billModel.createDate;
    
    NSString *numberString = [NSString stringWithFormat:@"%@", self.billModel.orderno];

    NSString *remarkString = self.billModel.remark;
    
    NSArray *contentArray = self.billModel.counterFee > 0 ? @[moneyString, poundageString, trueMoneyString, stateString, typeString, wayString, dateString, numberString, remarkString] : @[moneyString, stateString, typeString, wayString, dateString, numberString, remarkString];
    
    //  动态设置备注高度
    float height = [WPPublicTool textHeightFromTextString:self.billModel.remark width:kScreenWidth - WPLeftMarginField - WPLeftMargin miniHeight:40 fontSize:15];
    
    for (int i = 0; i < contentArray.count; i++) {
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, WPTopMargin + 40 * i, kScreenWidth - WPLeftMargin - 120, i == contentArray.count - 1 ? height : 40)];
        contentLabel.text = contentArray[i];
        contentLabel.textColor = [UIColor grayColor];
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:contentLabel];
    }
}

#pragma mark - 系统消息

- (void)initMessageTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, WPTopMargin, kScreenWidth, WPRowHeight)];
    titleLabel.text = self.messageModel.title;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLabel];
}


- (UILabel *)messageContenLabel
{
    if (!_messageContenLabel) {
        _messageContenLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, WPTopMargin + WPRowHeight, kScreenWidth - 2 * WPLeftMargin, [WPPublicTool textHeightFromTextString:self.messageModel.content width:kScreenWidth - 2 * WPLeftMargin miniHeight:WPRowHeight fontSize:15])];
        _messageContenLabel.text = self.messageModel.content;
        _messageContenLabel.textColor = [UIColor blackColor];
        _messageContenLabel.font = [UIFont systemFontOfSize:15];
        _messageContenLabel.numberOfLines = 0;
        [self.view addSubview:_messageContenLabel];
    }
    return _messageContenLabel;
}

- (void)initMessageDateLabel
{
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.messageContenLabel.frame) + 10, kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
    dateLabel.text = self.messageModel.create_time;
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.font = [UIFont systemFontOfSize:15];
    dateLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:dateLabel];
}

#pragma mark - 实名认证

- (void)initApproveStateLabel
{
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, WPTopMargin, kScreenWidth, WPRowHeight)];
    stateLabel.text = self.approveModel.auditStatus == 1 ? @"认证成功" : @"认证失败，请重新提交审核吧";
    stateLabel.textColor = [UIColor themeColor];
    stateLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:stateLabel];
    for (int i = 0; i < 3; i++) {
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(stateLabel.frame) + WPRowHeight * i, kScreenWidth, WPLineHeight)];
        lineView.backgroundColor = [UIColor lineColor];
        [self.view addSubview:lineView];
    }
}

- (void)initApproveHeaderLabel
{
    NSArray *headerArray = @[@"姓        名", @"身份证号"];
    for (int i = 0; i < headerArray.count; i++) {
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, WPTopMargin + WPRowHeight + WPRowHeight * i, 80, WPRowHeight)];
        headerLabel.text = headerArray[i];
        headerLabel.textColor = [UIColor blackColor];
        headerLabel.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:headerLabel];
    }
}

- (void)initApproveContentLabel
{
    NSString *fullName = [WPPublicTool stringWithStarString:self.approveModel.fullName headerIndex:1 footerIndex:0];
    NSString *userIDNmuber = [WPPublicTool stringWithStarString:[WPPublicTool base64DecodeString:self.approveModel.identityCard] headerIndex:3 footerIndex:2];
    
    NSArray *contentArray = @[fullName, userIDNmuber];
    
    for (int i = 0; i < contentArray.count; i++) {
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMarginField, WPTopMargin + WPRowHeight * i, kScreenWidth- WPLeftMarginField - WPLeftMargin, WPRowHeight)];
        headerLabel.text = contentArray[i];
        headerLabel.textColor = [UIColor blackColor];
        headerLabel.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:headerLabel];
    }
}

#pragma mark - 商家认证

- (void)initMerchantStateLabel
{
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    stateLabel.numberOfLines = 0;
    stateLabel.text = self.merchantModel.auditStatus == 1 ? [NSString stringWithFormat:@"您的商铺:%@审核通过啦！", self.merchantModel.shopName] : [NSString stringWithFormat:@"您的商铺:%@审核失败了\n请重新提交审核信息", self.merchantModel.shopName];
    stateLabel.textColor = [UIColor themeColor];
    stateLabel.font = [UIFont systemFontOfSize:20];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:stateLabel];
}

#pragma mark - 银行卡认证

- (void)initCardStateLabel
{
    
    NSString *cardNumber = [NSString stringWithFormat:@"%@", [WPPublicTool base64DecodeString:self.cardModel.cardNumber]];
    cardNumber = [cardNumber substringWithRange:NSMakeRange(cardNumber.length - 4, 4)];
    NSString *cardType = self.cardModel.cardType == 1 ? @"信用卡" : @"储蓄卡";
    
    UILabel *stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    stateLabel.numberOfLines = 0;
    stateLabel.text = self.cardModel.auditStatus == 1 ? [NSString stringWithFormat:@"您尾号为：%@的%@%@认证通过啦！\n赶快去充值提现吧！", cardNumber, self.cardModel.bankName, cardType] : [NSString stringWithFormat:@"您尾号wei%@的%@%@认证失败了\n请重新提交审核信息", cardNumber, self.cardModel.bankName, cardType];
    stateLabel.textColor = [UIColor themeColor];
    stateLabel.font = [UIFont systemFontOfSize:17];
    stateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:stateLabel];
}

#pragma mark - Action

- (void)leftItemClick:(UIButton *)button
{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[WPTabBarController alloc] init];

}

#pragma mark - Methods

- (NSDictionary *)stringToModelWithParameter:(NSString *)parameter
{
    NSDictionary *bisList = self.resultDict[@"bis_result"];
    NSString *result = bisList[parameter];
    NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    return dict;
}

#pragma mark - Data

#pragma mark - 账单详情
- (void)getBillData
{
    self.billModel = [WPNotificationBillDetailModel mj_objectWithKeyValues:[self stringToModelWithParameter:@"tradeInfo"]];
    self.navigationItem.title = @"账单详情";
    [self initBillHeaderLabel];
    [self initBillContentLabel];
}

#pragma mark - 系统消息
- (void)getMessageData
{
    self.messageModel = [WPNotificationMessageModel mj_objectWithKeyValues:[self stringToModelWithParameter:@"content"]];
    self.navigationItem.title = @"消息详情";
    [self initMessageTitleLabel];
    [self messageContenLabel];
    [self initMessageDateLabel];
}

#pragma mark - 实名认证
- (void)getApproveData
{
    self.approveModel = [WPNoticifationApproveModel mj_objectWithKeyValues:[self stringToModelWithParameter:@"IdCard"]];
    self.navigationItem.title = @"实名认证状态";
    [self initApproveStateLabel];
    [self initApproveHeaderLabel];
    [self initApproveContentLabel];
}

#pragma mark - 商家认证
- (void)getMerchantData
{
    self.merchantModel = [WPNotificationMerchantModel mj_objectWithKeyValues:[self stringToModelWithParameter:@"shop"]];
    self.navigationItem.title = @"商家认证状态";
    [self initMerchantStateLabel];
}

#pragma mark - 银行卡认证
- (void)getCardData
{
    self.cardModel = [WPNotificationCardModel mj_objectWithKeyValues:[self stringToModelWithParameter:@"card"]];
    self.navigationItem.title = @"银行卡认证状态";
    [self initCardStateLabel];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
