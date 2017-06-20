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
//    [self.imageView sd_setImageWithURL:[NSURL WP_URLWithString:model.avater]];
    NSArray *imageArray = @[@"icon_chongzhi_content_n", @"icon_zhuanzhangi_content_n", @"icon_huankuan_content_n", @"icon_tixian_content_n", @"icon_fukuan_content_n", @"icon_shoukuanma_content_n", @"icon_fukuan_content_n", @"icon_tixian_content_n", @"icon_shanghushengji_n", @"icon_shanghushengji_n"];
    self.wayImageView.image = [UIImage imageNamed:imageArray[model.tradeType - 1]];
    self.wayImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSArray *wayArray = @[@" ", @"充值", @"转账", @"还款", @"提现到卡", @"付款", @"二维码收款", @"退款", @"提现到余额", @"商户升级", @"代理升级", @"", @""];
    NSString *wayString = wayArray[model.tradeType];
    self.wayLabel.text = wayString;
    
    NSArray *stateArray = @[@"失败", @" ", @" ", @"取消", @"待处理", @"待确认", @"待返回", @"异常单", @" ", @" "];
    NSArray *colorArray = @[@"EE3B3B", @"", @"", @"50bca3", @"50bca3", @"50bca3", @"50bca3", @"EE3B3B", @" ", @" "];
    NSString *typeString = stateArray[model.payState];
    NSString *colorString = colorArray[model.payState];
    self.typeLabel.text = typeString;
    self.typeLabel.textColor = [UIColor colorWithRGBString:colorString];

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
