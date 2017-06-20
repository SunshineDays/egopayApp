//
//  WPMerchantUploadController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/23.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMerchantUploadController.h"
#import "Header.h"
#import "WPMerchantPhotoController.h"
#import "WPSelectListController.h"
#import "WPSexPickerView.h"
#import "WPAreaPickerView.h"

@interface WPMerchantUploadController () <WPAreaPickerViewDelegate, WPSexPickerViewDelegate>

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) WPRowTableViewCell *nameCell;

@property (nonatomic, strong) WPRowTableViewCell *sexCell;

@property (nonatomic, strong) WPRowTableViewCell *phoneCell;

@property (nonatomic, strong) WPRowTableViewCell *shopNameCell;

@property (nonatomic, strong) WPRowTableViewCell *shopAddressCell;

@property (nonatomic, strong) WPRowTableViewCell *shopAddressDetailCell;

@property (nonatomic, strong) WPButton *nextButton;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *area;


@end

@implementation WPMerchantUploadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商家认证";
    
    [self stateLabel];
    [self nameCell];
    [self sexCell];
    [self phoneCell];
    [self shopNameCell];
    [self shopAddressCell];
    [self shopAddressDetailCell];
    [self nextButton];
}

#pragma mark -init

-(UILabel *)stateLabel {
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, WPNavigationHeight, kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
        _stateLabel.text = self.failureString.length > 0 ? self.failureString : @"请填写您的真实信息";
        _stateLabel.textColor = [UIColor themeColor];
        _stateLabel.font = [UIFont systemFontOfSize:15];
        [self.view addSubview:_stateLabel];

    }
    return _stateLabel;
}

- (WPRowTableViewCell *)nameCell
{
    if (!_nameCell) {
        _nameCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.stateLabel.frame), kScreenWidth, WPRowHeight);
        [_nameCell tableViewCellTitle:@"联系人" placeholder:@"请输入您的姓名" rectMake:rect];
        [self.view addSubview:_nameCell];
    }
    return _nameCell;
}

- (WPRowTableViewCell *)sexCell {
    if (!_sexCell) {
        _sexCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.nameCell.frame), kScreenWidth, WPRowHeight);
        [_sexCell tableViewCellTitle:@"性别" buttonTitle:@"男" rectMake:rect];
        [_sexCell.button addTarget:self action:@selector(sexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _sexCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.view addSubview:_sexCell];
    }
    return _sexCell;
}

- (WPRowTableViewCell *)phoneCell
{
    if (!_phoneCell) {
        _phoneCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.sexCell.frame), kScreenWidth, WPRowHeight);
        [_phoneCell tableViewCellTitle:@"联系电话" placeholder:@"请输入电话号码" rectMake:rect];
        _phoneCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:_phoneCell];
    }
    return _phoneCell;
}

- (WPRowTableViewCell *)shopNameCell
{
    if (!_shopNameCell) {
        _shopNameCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.phoneCell.frame), kScreenWidth, WPRowHeight);
        [_shopNameCell tableViewCellTitle:@"店铺名称" placeholder:@"请输入店铺名称" rectMake:rect];
        [self.view addSubview:_shopNameCell];
    }
    return _shopNameCell;
}

- (WPRowTableViewCell *)shopAddressCell
{
    if (!_shopAddressCell) {
        _shopAddressCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.shopNameCell.frame), kScreenWidth, WPRowHeight);
        [_shopAddressCell tableViewCellTitle:@"店铺地址" buttonTitle:@"请选择店铺地址" rectMake:rect];
        _shopAddressCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [_shopAddressCell.button addTarget:self action:@selector(addressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_shopAddressCell];
    }
    return _shopAddressCell;
}

- (WPRowTableViewCell *)shopAddressDetailCell
{
    if (!_shopAddressDetailCell) {
        _shopAddressDetailCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.shopAddressCell.frame), kScreenWidth, WPRowHeight);
        [_shopAddressDetailCell tableViewCellTitle:@"详细地址" placeholder:@"请输入店铺详细地址" rectMake:rect];
        [self.view addSubview:_shopAddressDetailCell];
    }
    return _shopAddressDetailCell;
}

- (WPButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.shopAddressDetailCell.frame) + 30, kScreenWidth - WPLeftMargin * 2, WPButtonHeight)];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nextButton];
    }
    return _nextButton;
}

#pragma mark - WPSexPickerViewDelegate
- (void)wp_selectedResultWithSex:(NSString *)sex
{
    [self.sexCell.button setTitle:sex forState:UIControlStateNormal];
    [self.sexCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma mark - WPAreaPickerViewDelegate
- (void)wp_selectedResultWithProvince:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    
    if ([city isEqualToString:@"市辖区"] || [city isEqualToString:@"县"]) {
        city = province;
        [self.shopAddressCell.button setTitle:[NSString stringWithFormat:@"%@%@",province, area] forState:UIControlStateNormal];
    }
    else {
        [self.shopAddressCell.button setTitle:[NSString stringWithFormat:@"%@%@%@",province,city ,area] forState:UIControlStateNormal];
    }
    [self.shopAddressCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.province = province;
    self.city = city;
    self.area = area;
}

#pragma mark - Action

- (void)sexButtonClick:(UIButton *)button {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    WPSexPickerView *pickerView = [[WPSexPickerView alloc] initSexPickerView];
    pickerView.sexPickerViewDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
}

- (void)addressButtonClick:(UITapGestureRecognizer *)gesture {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    WPAreaPickerView *pickerView = [[WPAreaPickerView alloc] initAreaPickerView];
    pickerView.areaPickerViewDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
}

- (void)nextButtonClick:(UIButton *)button {
//    WPMerchantPhotoController *vc = [[WPMerchantPhotoController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
    if (self.nameCell.textField.text.length < 2) {
        [WPProgressHUD showInfoWithStatus:@"请输入姓名"];
    }
    else if ([self.sexCell.button.titleLabel.text isEqualToString:@"请选择性别"]) {
        [WPProgressHUD showInfoWithStatus:@"请选择性别"];
    }
    else if (![WPRegex validateMobile:self.phoneCell.textField.text]) {
        [WPProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
    }
    else if (self.shopNameCell.textField.text.length == 0) {
        [WPProgressHUD showInfoWithStatus:@"请输入店铺名称"];
    }
    else if ([self.shopAddressCell.textField.text isEqualToString:@"请选择店铺地址"]) {
        [WPProgressHUD showInfoWithStatus:@"请选择店铺地址"];
    }
    else if (self.shopAddressDetailCell.textField.text.length == 0) {
        [WPProgressHUD showInfoWithStatus:@"请输入店铺的详细地址"];
    }
    else {
        [self pushToNextCtr];
    }
}

- (void)pushToNextCtr {
    
    NSDictionary *parameters = @{
                                 @"telephone" : self.phoneCell.textField.text,
                                 @"linkMan" : self.nameCell.textField.text,
                                 @"linkManSex" : [self.sexCell.button.titleLabel.text isEqualToString:@"男"] ? @"1" : @"2",
                                 @"shopName" : self.shopNameCell.textField.text,
                                 @"country" : @"中国",
                                 @"province" : self.province,
                                 @"city" : self.city,
                                 @"area" : self.area,
                                 @"detailAddr" : self.shopAddressDetailCell.textField.text
                                 };
    
    
    WPMerchantPhotoController *vc = [[WPMerchantPhotoController alloc] init];
    [vc.shopInforDic addEntriesFromDictionary:parameters];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
