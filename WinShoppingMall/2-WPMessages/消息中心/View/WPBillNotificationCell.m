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
    self.payResultLabel.text = [NSString stringWithFormat:@"%@%@", [WPUserTool typePurposeWith:model.tradeType], model.payState == 1 ? @"成功" : @"失败"];
    
    self.dateLabel.text = [[WPPublicTool dateToLocalDate:model.finishDate] substringToIndex:[WPPublicTool dateToLocalDate:model.finishDate].length - 6];
    
    self.moneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",model.amount];
    
    self.wayLabel.text = [WPUserTool typeWayWith:model.paychannelid];
    
    self.typeLabel.text = [WPUserTool typePurposeWith:model.tradeType];
    
    self.stateLabel.text = model.orderno;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
