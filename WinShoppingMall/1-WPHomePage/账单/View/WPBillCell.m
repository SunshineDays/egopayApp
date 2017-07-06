//
//  WPBillCell.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/13.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBillCell.h"
#import "Header.h"

@implementation WPBillCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
}


- (void)setModel:(WPBillModel *)model {

    self.wayImageView.image = [WPUserTool typeImageWith:model.tradeType];
    self.wayImageView.contentMode = UIViewContentModeScaleAspectFit;

    self.wayLabel.text = [WPUserTool typePurposeWith:model.tradeType];
    
    self.typeLabel.text = [WPUserTool typeStateWith:model.payState];
    self.typeLabel.textColor = [UIColor colorWithRGBString:[WPUserTool typeStateColorWith:model.payState]];
    
    self.dateLabel.text = [WPPublicTool dateToLocalDate:model.createDate];
    
    NSString *typeStr = model.inPaystate == 1 ? @"+" : @"-";
    self.moneyLabel.text = [NSString stringWithFormat:@"%@ %.2f",typeStr, model.amount];
    
    self.poundageLabel.text = model.counterFee > 0 ? [NSString stringWithFormat:@"-%.2f%@", model.counterRate * 100, @"%"] : @"   ";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
