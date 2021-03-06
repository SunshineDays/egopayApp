//
//  WPMerchantGradeProductCell.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/4.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMerchantGradeProductCell.h"

@implementation WPMerchantGradeProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.backgroundColor = [UIColor clearColor];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.lvImageView.contentMode = UIViewContentModeScaleAspectFit;


}


- (void)setMerchantLvModel:(WPMemberProuctModel *)merchantLvModel {
    self.lvNameLabel.text = [NSString stringWithFormat:@"%@会员", merchantLvModel.lvname];
    self.priceNameLabel.text = [NSString stringWithFormat:@"%.2f", merchantLvModel.price];
}

- (void)setDelegateLvModel:(WPAgencyProductModel *)delegateLvModel {
    self.lvNameLabel.text = delegateLvModel.gradeName;
    self.priceNameLabel.text = [NSString stringWithFormat:@"%.2f", delegateLvModel.price];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
