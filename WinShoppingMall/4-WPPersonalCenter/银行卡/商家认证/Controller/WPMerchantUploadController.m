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
#import "WPAreaPickerView.h"
#import "WPMerchantUploadView.h"


@interface WPMerchantUploadController () <WPAreaPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) WPMerchantUploadView *uploadView;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *area;


@end

@implementation WPMerchantUploadController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"商家认证";
    
    [self uploadView];
}

#pragma mark -init

- (WPMerchantUploadView *)uploadView
{
    if (!_uploadView) {
        _uploadView = [[WPMerchantUploadView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _uploadView.stateLabel.text = self.failureString.length > 0 ? self.failureString : @"请填写您的真实信息";
        
        [_uploadView.nameCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        
        [_uploadView.sexCell.button addTarget:self action:@selector(sexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_uploadView.shopNameCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        
        [_uploadView.shopAddressCell.button addTarget:self action:@selector(addressButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_uploadView.shopAddressDetailCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        
        [_uploadView.nextButton addTarget:self action:@selector(nextButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_uploadView];
    }
    return _uploadView;
}

#pragma mark - WPAreaPickerViewDelegate
- (void)wp_selectedResultWithProvince:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    
    if ([city isEqualToString:@"市辖区"] || [city isEqualToString:@"县"]) {
        city = province;
        [self.uploadView.shopAddressCell.button setTitle:[NSString stringWithFormat:@"%@%@",province, area] forState:UIControlStateNormal];
    }
    else {
        [self.uploadView.shopAddressCell.button setTitle:[NSString stringWithFormat:@"%@%@%@",province,city ,area] forState:UIControlStateNormal];
    }
    [self.uploadView.shopAddressCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.province = province;
    self.city = city;
    self.area = area;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [WPJudgeTool validateSpace:string];
}

#pragma mark - Action

- (void)changeButtonSurface
{
    [WPPublicTool buttonWithButton:self.uploadView.nextButton userInteractionEnabled:(self.uploadView.nameCell.textField.text.length > 1 && self.uploadView.phoneCell.textField.text.length > 6 && self.uploadView.shopNameCell.textField.text.length > 0 && self.uploadView.shopAddressDetailCell.textField.text.length > 2) ? YES : NO];
}

- (void)sexButtonClick:(UIButton *)button
{
    __weakSelf
    [WPHelpTool alertControllerTitle:nil rowOneTitle:@"男" rowTwoTitle:@"女" rowOne:^(UIAlertAction *alertAction)
    {
        [weakSelf sexButtonTitleWithSex:alertAction.title];
    } rowTwo:^(UIAlertAction *alertAction)
    {
        [weakSelf sexButtonTitleWithSex:alertAction.title];
    }];
}

- (void)sexButtonTitleWithSex:(NSString *)sex
{
    [self.uploadView.sexCell.button setTitle:sex forState:UIControlStateNormal];
    [self.uploadView.sexCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)addressButtonClick:(UITapGestureRecognizer *)gesture
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    WPAreaPickerView *pickerView = [[WPAreaPickerView alloc] initAreaPickerView];
    pickerView.areaPickerViewDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
}

- (void)nextButtonClick:(UIButton *)button
{
    if (self.uploadView.nameCell.textField.text.length < 2)
    {
        [WPProgressHUD showInfoWithStatus:@"请输入姓名"];
    }
    else if ([self.uploadView.sexCell.button.titleLabel.text isEqualToString:@"请选择性别"])
    {
        [WPProgressHUD showInfoWithStatus:@"请选择性别"];
    }
    else if (![WPJudgeTool validateMobile:self.uploadView.phoneCell.textField.text])
    {
        [WPProgressHUD showInfoWithStatus:@"请输入正确的手机号码"];
    }
    else if (self.uploadView.shopNameCell.textField.text.length == 0)
    {
        [WPProgressHUD showInfoWithStatus:@"请输入店铺名称"];
    }
    else if ([self.uploadView.shopAddressCell.textField.text isEqualToString:@"请选择店铺地址"])
    {
        [WPProgressHUD showInfoWithStatus:@"请选择店铺地址"];
    }
    else if (self.uploadView.shopAddressDetailCell.textField.text.length == 0)
    {
        [WPProgressHUD showInfoWithStatus:@"请输入店铺详细地址"];
    }
    else
    {
        [self pushToNextCtr];
    }
}

- (void)pushToNextCtr
{
    
    NSDictionary *parameters = @{
                                 @"telephone" : self.uploadView.phoneCell.textField.text,
                                 @"linkMan" : self.uploadView.nameCell.textField.text,
                                 @"linkManSex" : [self.uploadView.sexCell.button.titleLabel.text isEqualToString:@"男"] ? @"1" : @"2",
                                 @"shopName" : self.uploadView.shopNameCell.textField.text,
                                 @"country" : @"中国",
                                 @"province" : self.province,
                                 @"city" : self.city,
                                 @"area" : self.area,
                                 @"detailAddr" : self.uploadView.shopAddressDetailCell.textField.text
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
