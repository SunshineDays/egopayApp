//
//  WPBillNotificationCell.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/15.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBillNotificationCell.h"
#import "WPPublicTool.h"

@implementation WPBillNotificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.layer.borderColor = [UIColor lineColor].CGColor;
    self.layer.borderWidth = 1;
}

- (void)setModel:(WPBillModel *)model
{
    NSArray *typeArray = @[@" ", @"充值", @"转账", @"还款", @"提现到卡", @"付款", @"二维码收款", @"退款", @"提现到余额", @"商户升级", @"代理升级", @"", @""];
    NSArray *wayArray = @[@" ", @"银行卡", @"微信", @"支付宝", @"余额", @"国际信用卡", @"QQ钱包", @" ", @" "];

//    self.payResultLabel.text = model.payState == 1 ? @"成功" : @"失败";
    
    self.payResultLabel.text = [NSString stringWithFormat:@"%@%@", typeArray[model.tradeType], model.payState == 1 ? @"成功" : @"失败"];
    
    self.dateLabel.text = [[WPPublicTool dateToLocalDate:model.finishDate] substringToIndex:[WPPublicTool dateToLocalDate:model.finishDate].length - 6];
    
    self.moneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",model.amount];
    
    self.wayLabel.text = wayArray[model.paychannelid];
    
    self.typeLabel.text = typeArray[model.tradeType];
    
    self.stateLabel.text = model.orderno;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
