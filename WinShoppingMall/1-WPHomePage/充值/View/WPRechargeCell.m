//
//  WPRechargeCell.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/19.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPRechargeCell.h"
#import "Header.h"

@implementation WPRechargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bankImageView.contentMode = UIViewContentModeScaleAspectFit;
    // Initialization code
}

- (void)setModel:(WPBankCardModel *)model {
    self.bankImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"BANK_%@", model.bankCode]];
    if (!self.bankImageView.image) {
        self.bankImageView.image = [UIImage imageNamed:@"icon_yinhang_n"];
    }
    NSString *cardNumber = [WPPublicTool base64DecodeString:model.cardNumber];
    cardNumber = [cardNumber substringFromIndex:cardNumber.length - 4];
    NSString *cardType = model.cardType == 1 ? @"信用卡" : @"储蓄卡";
    self.bankNameLabel.text = [NSString stringWithFormat:@"%@%@(%@)", model.bankName, cardType, cardNumber];
}

- (void)setInvitingModel:(WPInvitingPeopleModel *)invitingModel {
    self.bankNameLabel.text = [WPPublicTool stringHiddenWithString:[NSString stringWithFormat:@"%@", invitingModel.phone] headerIndex:3 footerIndex:4];
}

- (void)setSubAccountListModel:(WPSubAccountListModel *)subAccountListModel
{
    self.bankNameLabel.text = subAccountListModel.clerkName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
