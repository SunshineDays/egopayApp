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

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.layer.cornerRadius = 10;
    self.layer.borderColor = [UIColor lineColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.masksToBounds = YES;
}

- (void)setModel:(WPBillModel *)model
{
    self.payResultLabel.text = [NSString stringWithFormat:@"%@%@", [WPUserTool billTypePurposeWithModel:model], model.payState == 1 ? @"成功" : @"失败"];
    
    self.dateLabel.text = [[WPPublicTool stringToDateString:model.finishDate] substringToIndex:[WPPublicTool stringToDateString:model.finishDate].length - 6];
    
    self.moneyLabel.text = [NSString stringWithFormat:@"¥ %.2f",model.amount];
    
    self.wayLabel.text = [WPUserTool billTypeWayWithModel:model];
    
    self.typeLabel.text = [WPUserTool billTypePurposeWithModel:model];
    
    self.stateLabel.text = model.orderno;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
