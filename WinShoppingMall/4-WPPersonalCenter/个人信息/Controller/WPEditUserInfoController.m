//
//  WPEditUserInfoController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/24.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPEditUserInfoController.h"
#import "Header.h"
#import "WPSelectListController.h"
#import "WPSexPickerView.h"
#import "WPAreaPickerView.h"

@interface WPEditUserInfoController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, WPSexPickerViewDelegate, WPAreaPickerViewDelegate>
//  头像
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, copy) NSString *avatarString;

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *county;

//  保存
@property (nonatomic, strong) WPButton *confirmButton;

//  判断是修改头像还是用户信息 YES:头像，NO:信息
@property (nonatomic, assign) BOOL isAvatar;


@property (nonatomic, strong) WPRowTableViewCell *shopNumberCell;

@property (nonatomic, strong) WPRowTableViewCell *nameCell;

@property (nonatomic, strong) WPRowTableViewCell *sexCell;

@property (nonatomic, strong) WPRowTableViewCell *addressCell;

@property (nonatomic, strong) WPRowTableViewCell *addressDetailCell;

@property (nonatomic, strong) WPRowTableViewCell *emailCell;


@end

@implementation WPEditUserInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改个人信息";
    [self avatarImageView];
    
    [self shopNumberCell];
    [self nameCell];
    [self sexCell];
    [self addressCell];
    [self addressDetailCell];
    [self emailCell];
    [self confirmButton];
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 40, WPTopMargin, 80, 80)];
        
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.model.picurl]];
//        _avatarImageView.image = [UIImage imageWithData:data];
        _avatarImageView.image = self.avaterImage;
        if (!_avatarImageView.image) {
            _avatarImageView.image = [UIImage imageNamed:@"titlePlaceholderImage"];
        }
        
        _avatarImageView.layer.cornerRadius = 40;
        _avatarImageView.layer.borderColor = [UIColor lineColor].CGColor;
        _avatarImageView.layer.borderWidth = WPLineHeight;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
        [_avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageViewClick:)]];
        [self.view addSubview:_avatarImageView];
    }
    return _avatarImageView;
}

- (WPRowTableViewCell *)shopNumberCell {
    if (!_shopNumberCell) {
        _shopNumberCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.avatarImageView.frame) + 10, kScreenWidth, WPRowHeight);
        [_shopNumberCell tableViewCellTitle:@"商户编号" contentTitle:[NSString stringWithFormat:@"%d", self.model.merchantno] rectMake:rect];
        [self.view addSubview:_shopNumberCell];
    }
    return _shopNumberCell;
}

- (WPRowTableViewCell *)nameCell {
    if (!_nameCell) {
        _nameCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.shopNumberCell.frame), kScreenWidth, WPRowHeight);
        [_nameCell tableViewCellTitle:@"姓        名" contentTitle:self.model.fullName.length > 0 ? self.model.fullName : self.model.userName rectMake:rect];
        [self.view addSubview:_nameCell];
    }
    return _nameCell;
}

- (WPRowTableViewCell *)sexCell {
    if (!_sexCell) {
        _sexCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.nameCell.frame), kScreenWidth, WPRowHeight);
        [_sexCell tableViewCellTitle:@"性        别" buttonTitle:self.model.sex == 0 ? @"请选择(性别只能修改一次哦)" : self.model.sex == 1 ? @"男" : @"女" rectMake:rect];
        if (self.model.sex != 1 && self.model.sex != 2) {
            [_sexCell.button addTarget:self action:@selector(sexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            _sexCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        [self.view addSubview:_sexCell];
    }
    return _sexCell;
}

- (WPRowTableViewCell *)addressCell {
    if (!_addressCell) {
        _addressCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.sexCell.frame), kScreenWidth, WPRowHeight);
        NSString *buttonTitle;
        if (self.model.province.length == 0) {
            buttonTitle = @"请选择您的地址";
        }
        else {
            if ([self.model.province isEqualToString:self.model.city] || [self.model.city isEqualToString:@"直辖市"] || [self.model.area isEqualToString:@"县"]) {
                buttonTitle = [NSString stringWithFormat:@"%@%@", self.model.province, self.model.area];
            }
            else {
                buttonTitle = [NSString stringWithFormat:@"%@%@%@", self.model.province, self.model.city, self.model.area];
            }
            self.province = self.model.province;
            self.city = self.model.city;
            self.county = self.model.area;
        }
        [_addressCell tableViewCellTitle:@"地        址" buttonTitle:buttonTitle rectMake:rect];
        [_addressCell.button addTarget:self action:@selector(addressButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _addressCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.view addSubview:_addressCell];
    }
    return _addressCell;
}

- (WPRowTableViewCell *)addressDetailCell {
    if (!_addressDetailCell) {
        _addressDetailCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.addressCell.frame), kScreenWidth, WPRowHeight);
        [_addressDetailCell tableViewCellTitle:@"详细地址" placeholder:self.model.address.length == 0 ? @"请输入详细地址" : self.model.address rectMake:rect];
        [self.view addSubview:_addressDetailCell];
    }
    return _addressDetailCell;
}

- (WPRowTableViewCell *)emailCell {
    if (!_emailCell) {
        _emailCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.addressDetailCell.frame), kScreenWidth, WPRowHeight);
        [_emailCell tableViewCellTitle:@"电子邮箱" placeholder:self.model.email.length == 0 ? @"请输入您的电子邮箱" : self.model.email rectMake:rect];
        _emailCell.textField.keyboardType = UIKeyboardTypeEmailAddress;
        [self.view addSubview:_emailCell];
    }
    return _emailCell;
}

- (WPButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.emailCell.frame) + 30, kScreenWidth - 2 * WPLeftMargin, WPButtonHeight)];
        [_confirmButton setTitle:@"保存" forState:UIControlStateNormal];
        [_confirmButton addTarget:self action:@selector(confirmButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_confirmButton];
        
    }
    return _confirmButton;
}

#pragma mark - Action

- (void)avatarImageViewClick:(UITapGestureRecognizer *)gesture {
    self.isAvatar = YES;
    [self createAlertControl];
}

- (void)createAlertControl {
    [self presentViewController:self.alertSheet animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.avatarString = [self imageToString:image];
    [self pushUserInforData:image];
}

#pragma mark - UIImage转NSString
- (NSString *)imageToString:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.2f);
    NSString *imageString = [data base64EncodedStringWithOptions:0];
    return imageString;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WPSexPickerViewDelegate

- (void)wp_selectedResultWithSex:(NSString *)sex
{
    [self.sexCell.button setTitle:sex forState:UIControlStateNormal];
    [self.sexCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

#pragma mark - Action

- (void)sexButtonClick:(UIButton *)button {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    WPSexPickerView *pickerView = [[WPSexPickerView alloc] initSexPickerView];
    pickerView.sexPickerViewDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
}

- (void)addressButtonClick{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    WPAreaPickerView *pickerView = [[WPAreaPickerView alloc] initAreaPickerView];
    pickerView.areaPickerViewDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
    
//    self.pickerView =[[BLAreaPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight * 3 / 4, kScreenWidth, kScreenHeight / 4)];
//    self.pickerView.pickViewDelegate = self;
//    [self.pickerView bl_show];
}

- (void)wp_selectedResultWithProvince:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    
    if ([city isEqualToString:@"市辖区"] || [city isEqualToString:@"县"]) {
        city = province;
        [self.addressCell.button setTitle:[NSString stringWithFormat:@"%@%@",province, area] forState:UIControlStateNormal];
    }
    else {
        [self.addressCell.button setTitle:[NSString stringWithFormat:@"%@%@%@",province,city ,area] forState:UIControlStateNormal];
    }
    [self.addressCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.province = province;
    self.city = city;
    self.county = area;
}


- (void)confirmButtonClick:(UIButton *)button {
    if ([self.sexCell.button.titleLabel.text isEqualToString:@"请选择(性别只能修改一次哦)"]) {
        [WPProgressHUD showInfoWithStatus:@"请选择您的性别"];
    }
    else if ([self.addressCell.button.titleLabel.text isEqualToString:@"请选择您的地址"]) {
        [WPProgressHUD showInfoWithStatus:@"请输入您的地址"];
    }
    else if (self.addressDetailCell.textField.text.length == 0 && self.model.address.length == 0) {
        [WPProgressHUD showInfoWithStatus:@"请输入您的详细地址"];
    }
    else if (![WPRegex validateEmail:self.emailCell.textField.text] && self.model.email.length == 0) {
        [WPProgressHUD showInfoWithStatus:@"电子邮箱格式错误"];
    }
    else if (![WPRegex validateEmail:self.emailCell.textField.text] && self.emailCell.textField.text.length > 0 && self.model.email.length != 0) {
        [WPProgressHUD showInfoWithStatus:@"电子邮箱格式错误"];
    }
    else {
        self.isAvatar = NO;
        [self pushUserInforData:nil];
    }
}

#pragma mark - Data

- (void)pushUserInforData:(UIImage *)avaterImage {
    
    NSDictionary *parameters;
    if (self.isAvatar) {
        //  上传用户头像
        parameters = @{@"headImg" : self.isAvatar ? self.avatarString : @""};
    }
    else {
        //  上传用户信息
        parameters = @{
                        @"sex" : [self.sexCell.button.titleLabel.text isEqualToString:@"男"] ? @"1" : @"2",
                        @"country" : @"中国",
                        @"province" : self.province,
                        @"city" : self.city,
                        @"area" : self.county,
                        @"address" : self.addressDetailCell.textField.text.length == 0 ? self.model.address : self.addressDetailCell.textField.text,
                        @"email" : self.emailCell.textField.text.length == 0 ? self.model.email : self.emailCell.textField.text
                        };

    }
    
    __weakSelf
    [WPHelpTool postWithURL:self.isAvatar ? WPUserChangeAvatarURL : WPUserChangeInforURL parameters:parameters success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        
        if ([type isEqualToString:@"1"]) {
            
            //  修改个人头像
            if (weakSelf.isAvatar) {
                self.avatarImageView.image = avaterImage;
                NSDictionary *statusDict = [[NSDictionary alloc] initWithObjectsAndKeys:avaterImage, @"avatarImage", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationChangeUserInfor object:nil userInfo:statusDict];
                
            }
            //  修改个人信息
            else {
                [WPProgressHUD showSuccessWithStatus:@"信息修改成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationChangeUserInfor object:nil userInfo:nil];
            }
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
