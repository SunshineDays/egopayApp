//
//  WPEditUserInforView.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/12.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPEditUserInforView.h"

@interface WPEditUserInforView () <UITextFieldDelegate>

@property (nonatomic, strong) WPEditUserInfoModel *model;

@end

@implementation WPEditUserInforView


- (instancetype)initWithModel:(WPEditUserInfoModel *)model
{
    if (self = [super init]) {
        [self setFrame:[UIScreen mainScreen].bounds];
        self.model = model;
        [self emailCell];
    }
    return self;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 40, WPTopMargin, 80, 80)];
        _avatarImageView.layer.cornerRadius = 40;
        _avatarImageView.layer.borderColor = [UIColor lineColor].CGColor;
        _avatarImageView.layer.borderWidth = WPLineHeight;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
        [self addSubview:_avatarImageView];
    }
    return _avatarImageView;
}

- (WPRowTableViewCell *)shopNumberCell {
    if (!_shopNumberCell) {
        _shopNumberCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.avatarImageView.frame) + 10, kScreenWidth, WPRowHeight);
        [_shopNumberCell tableViewCellTitle:@"商户编号" contentTitle:[NSString stringWithFormat:@"%ld", (long)self.model.merchantno] rectMake:rect];
        [self addSubview:_shopNumberCell];
    }
    return _shopNumberCell;
}

- (WPRowTableViewCell *)nameCell {
    if (!_nameCell) {
        _nameCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.shopNumberCell.frame), kScreenWidth, WPRowHeight);
        [_nameCell tableViewCellTitle:@"姓        名" contentTitle:self.model.fullName.length > 0 ? self.model.fullName : self.model.userName rectMake:rect];
        [self addSubview:_nameCell];
    }
    return _nameCell;
}

- (WPRowTableViewCell *)sexCell {
    if (!_sexCell) {
        _sexCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.nameCell.frame), kScreenWidth, WPRowHeight);
        [_sexCell tableViewCellTitle:@"性        别" buttonTitle:self.model.sex == 0 ? @"请选择(只能修改一次)" : self.model.sex == 1 ? @"男" : @"女" rectMake:rect];
        
        [self addSubview:_sexCell];
    }
    return _sexCell;
}

- (WPRowTableViewCell *)addressCell {
    if (!_addressCell) {
        _addressCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.sexCell.frame), kScreenWidth, WPRowHeight);
        NSString *buttonTitle;
        if (self.model.province.length == 0) {
            buttonTitle = @"请选择地址";
        }
        else {
            NSString *city = ([self.model.city isEqualToString:@"市辖区"] || [self.model.city isEqualToString:@"县"]) ? @"" : self.model.city;
            
            buttonTitle = [NSString stringWithFormat:@"%@%@%@", self.model.province, city, self.model.area];
        }
        [_addressCell tableViewCellTitle:@"地        址" buttonTitle:buttonTitle rectMake:rect];
        [self addSubview:_addressCell];
    }
    return _addressCell;
}

- (WPRowTableViewCell *)addressDetailCell {
    if (!_addressDetailCell) {
        _addressDetailCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.addressCell.frame), kScreenWidth, WPRowHeight);
        [_addressDetailCell tableViewCellTitle:@"详细地址" placeholder:self.model.address.length == 0 ? @"请输入详细地址" : self.model.address rectMake:rect];
        _addressDetailCell.textField.delegate = self;
        [self addSubview:_addressDetailCell];
    }
    return _addressDetailCell;
}

- (WPRowTableViewCell *)emailCell {
    if (!_emailCell) {
        _emailCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.addressDetailCell.frame), kScreenWidth, WPRowHeight);
        [_emailCell tableViewCellTitle:@"电子邮箱" placeholder:self.model.email.length == 0 ? @"请输入电子邮箱" : self.model.email rectMake:rect];
        _emailCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        _emailCell.textField.delegate = self;
        [self addSubview:_emailCell];
    }
    return _emailCell;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [WPJudgeTool validateSpace:string];
}

@end
