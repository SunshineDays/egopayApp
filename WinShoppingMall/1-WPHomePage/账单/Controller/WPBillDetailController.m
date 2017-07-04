//
//  WPBillDetailController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/17.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBillDetailController.h"

#import "Header.h"

@interface WPBillDetailController ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation WPBillDetailController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"账单详情";
    [self titleLabel];
    [self contentLabel];
    [self lineView];
}

#pragma mark - Init

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        NSArray *titleArray = self.model.counterFee > 0 ? @[@"付款金额", @"手续费", @"可提现金额", @"当前状态", @"交易类型", @"支付方式", @"支付时间", @"账单编号", @"备        注"] : @[@"付款金额", @"当前状态", @"交易类型", @"支付方式", @"支付时间", @"账单编号", @"备        注"];
        for (int i = 0; i < titleArray.count; i++) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, WPTopMargin + 40 * i, 80, 40)];
            _titleLabel.text = titleArray[i];
            _titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
            _titleLabel.textColor = [UIColor darkGrayColor];
            [self.view addSubview:_titleLabel];
        }
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        NSString *moneyString = [NSString stringWithFormat:@"%.2f", self.model.amount];
        
        NSString *poundageString = [NSString stringWithFormat:@"%.2f", self.model.counterFee];
        
        NSString *trueMoneyString = [NSString stringWithFormat:@"%.2f", self.model.avl_amount];
        
        NSArray *stateArray = @[@"失败", @"成功", @"取消", @"待处理", @"待确认", @"待返回", @"异常单", @" ", @" "];
        NSString *stateString = stateArray[self.model.payState];

        NSArray *typeArray = @[@" ", @"充值", @"转账", @"还款", @"提现到卡", @"付款", @"二维码收款", @"退款", @"提现到余额", @"商户升级", @"代理升级", @" ", @" "];
        NSString *typeString = typeArray[self.model.tradeType];
        
        NSArray *wayArray = @[@" ", @"银行卡", @"微信", @"支付宝", @"余额", @"国际信用卡", @"QQ钱包", @" ", @" "];
        NSString *wayString = wayArray[self.model.paychannelid];

        NSString *dateString = [WPPublicTool dateToLocalDate:[NSString stringWithFormat:@"%@", self.model.createDate ? self.model.createDate : self.model.finishDate]];
        NSString *numberString = [NSString stringWithFormat:@"%@", self.model.orderno];
        NSString *remarkString = self.model.remark;
        
        NSArray *contentArray = self.model.counterFee > 0 ? @[moneyString, poundageString, trueMoneyString, stateString, typeString, wayString, dateString, numberString, remarkString] : @[moneyString, stateString, typeString, wayString, dateString, numberString, remarkString];
        
        //  动态设置备注高度
        float height = [WPPublicTool textHeightFromTextString:self.model.remark width:kScreenWidth - WPLeftMarginField - WPLeftMargin miniHeight:40 fontSize:15];
        
        for (int i = 0; i < contentArray.count; i++) {
            _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMarginField, WPTopMargin + 40 * i, kScreenWidth - WPLeftMarginField - WPLeftMargin, i == contentArray.count - 1 ? height : 40)];
            _contentLabel.text = contentArray[i];
            _contentLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
            _contentLabel.textColor = [UIColor grayColor];
            _contentLabel.textAlignment = NSTextAlignmentRight;
            _contentLabel.numberOfLines = 0;
            [self.view addSubview:_contentLabel];
        }
    }
    return _contentLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.contentLabel.frame) + 10, kScreenWidth - WPLeftMargin, WPLineHeight)];
        _lineView.backgroundColor = [UIColor lineColor];
        [self.view addSubview:_lineView];
    }
    return _lineView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
