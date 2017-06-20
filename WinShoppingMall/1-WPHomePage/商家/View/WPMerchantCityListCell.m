//
//  WPMerchantCityListCell.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/31.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMerchantCityListCell.h"

@implementation WPMerchantCityListCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];

}

- (void)setModel:(WPMerchantCityListModel *)model {
    self.cityName.text = model.name;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
