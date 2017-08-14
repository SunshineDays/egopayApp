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
    
    self.wayImageView.layer.cornerRadius = 24;
    self.wayImageView.layer.masksToBounds = YES;
}


- (void)setModel:(WPBillModel *)model {

    self.wayImageView.image = [WPUserTool billTypeImageWithModel:model];
    self.wayImageView.contentMode = UIViewContentModeScaleAspectFit;

    self.wayLabel.text = [WPUserTool billTypePurposeWithModel:model];
    
    self.typeLabel.text = [WPUserTool billTypeStateWithModel:model];
    self.typeLabel.textColor = [WPUserTool billTypeStateColorWithModel:model];
    
    self.dateLabel.text = [WPPublicTool dateStringWith:[WPPublicTool stringToDateString:model.createDate]];
    
    NSString *typeStr = model.inPaystate == 1 ? @"+" : @"-";
    self.moneyLabel.text = [NSString stringWithFormat:@"%@ %.2f",typeStr, model.amount];
    
    self.poundageLabel.text = model.counterFee > 0 ? [NSString stringWithFormat:@"-%.2f%@", model.counterRate * 100, @"%"] : @"   ";
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
