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
    self.lineLabel.backgroundColor = [UIColor tableViewColor];

}

- (void)setProfitModel:(WPProfitDetailModel *)profitModel {
    
    self.withdrawMoneyLabel.text = [NSString stringWithFormat:@"%.2f", profitModel.txAmount];
    
    self.profitMoneyLabel.text = [NSString stringWithFormat:@"%.2f元", profitModel.benefit];
    
    self.merchantNumberLabel.text = [NSString stringWithFormat:@"%@", profitModel.merchantno];
    
    NSString *dateString = [WPPublicTool stringToDateString:[NSString stringWithFormat:@"%@", profitModel.createTime]];
    self.profitDateLabel.text = [NSString stringWithFormat:@"%@", dateString];
    
    self.orderNumberLabel.text = [NSString stringWithFormat:@"%@", profitModel.orderno];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
