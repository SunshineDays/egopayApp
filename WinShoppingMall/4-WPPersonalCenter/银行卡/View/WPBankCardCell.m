//
//  WPBankCardCell.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/18.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBankCardCell.h"
#import "Header.h"

@implementation WPBankCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cardImageView.contentMode = UIViewContentModeScaleAspectFit;

    self.layer.cornerRadius = 3;
    self.layer.borderColor = [UIColor lineColor].CGColor;
    self.layer.borderWidth = WPLineHeight;
}

- (void)setModel:(WPBankCardModel *)model {
    self.cardImageView.image = [WPUserTool payBankImageWithBankCode:model.bankCode];
    
    self.cardNameLabel.text = model.bankName;
    self.cardNumberLabel.text = [WPPublicTool stringStarWithString:[WPPublicTool base64DecodeString:model.cardNumber] headerIndex:0 footerIndex:4];
    self.cardTypeLabel.text = model.cardType == 1 ? @"信用卡" : @"储蓄卡";
    self.backgroundColor = model.cardType == 1 ? [UIColor colorWithRGBString:@"#E7576E"] : [UIColor colorWithRGBString:@"#1BB093"];
    if (model.auditStatus == 1) {
        switch (model.extCardType) {
            case 3:
                self.extCardTypeLabel.text = @"JCB";
                break;
            case 4:
                self.extCardTypeLabel.text = @"VISA";
                break;
            case 5:
                self.extCardTypeLabel.text = @"MASTER";
                break;
            default:
                break;
        }
    }
    else if (model.auditStatus == 0) {
        self.extCardTypeLabel.text = @"未认证";
    }
    else if (model.auditStatus == 2) {
        self.extCardTypeLabel.text = @"认证失败";
    }
    else if (model.auditStatus == 3) {
        self.extCardTypeLabel.text = @"认证中";
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
