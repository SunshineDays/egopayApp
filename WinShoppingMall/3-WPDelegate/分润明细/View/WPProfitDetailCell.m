//
//  WPProfitDetailCell.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/20.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPProfitDetailCell.h"
#import "Header.h"

@implementation WPProfitDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setProfitModel:(WPProfitDetailModel *)profitModel {
    
    self.withdrawMoneyLabel.text = [NSString stringWithFormat:@"提现金额：%.2f", profitModel.txAmount];
    
    self.profitMoneyLabel.text = [NSString stringWithFormat:@"分润金额：%.2f元", profitModel.benefit];
    
    self.merchantNumberLabel.text = [NSString stringWithFormat:@"商户编号：%@", profitModel.merchantno];
    
    NSString *dateString = [WPPublicTool dateToLocalDate:[NSString stringWithFormat:@"%@", profitModel.createTime]];
    self.profitDateLabel.text = [NSString stringWithFormat:@"分润时间：%@", dateString];
    
    self.orderNumberLabel.text = [NSString stringWithFormat:@"订单编号：%@", profitModel.orderno];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
