//
//  WPEditUserInfoController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/24.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPEditUserInfoController.h"
#import "Header.h"
#import "WPAreaPickerView.h"
#import "WPEditUserInforView.h"

@interface WPEditUserInfoController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, WPAreaPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) WPEditUserInforView *inforView;

//  头像
@property (nonatomic, copy) NSString *avatarString;

@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *county;

//  判断是修改头像还是用户信息 YES:头像，NO:信息
@property (nonatomic, assign) BOOL isAvatar;

@end

@implementation WPEditUserInfoController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"修改个人信息";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonClick:)];

    [self inforView];
}

#pragma mark - Init

- (WPEditUserInforView *)inforView
{
    if (!_inforView) {
        _inforView = [[WPEditUserInforView alloc] initWithModel:self.model];
        
        _inforView.avatarImageView.image = self.avaterImage;
        [_inforView.avatarImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageViewClick:)]];
        
        if (self.model.sex != 1 && self.model.sex != 2)
        {
            [_inforView.sexCell.button addTarget:self action:@selector(sexButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            _inforView.sexCell.accessoryType = UITableViewCellAccessoryNone;
        }

        [_inforView.addressCell.button addTarget:self action:@selector(addressButtonClick) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:_inforView];
     }
    return _inforView;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.avatarString = [WPPublicTool imageToString:image];
    [self pushUserInforData:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WPAreaPickerViewDelegate
- (void)wp_selectedResultWithProvince:(NSString *)province city:(NSString *)city area:(NSString *)area
{
    self.province = province;
    self.city = city;
    self.county = area;
    city = ([city isEqualToString:@"市辖区"] || [city isEqualToString:@"县"]) ? @"" : city;
    [self.inforView.addressCell.button setTitle:[NSString stringWithFormat:@"%@%@%@",province,city ,area] forState:UIControlStateNormal];

    [self.inforView.addressCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
}

#pragma mark - Action

- (void)avatarImageViewClick:(UITapGestureRecognizer *)gesture
{
    self.isAvatar = YES;
    [self alertControllerWithPhoto:YES];
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
    [self.inforView.sexCell.button setTitle:sex forState:UIControlStateNormal];
    [self.inforView.sexCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)addressButtonClick
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    WPAreaPickerView *pickerView = [[WPAreaPickerView alloc] initAreaPickerView];
    pickerView.areaPickerViewDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
}

- (void)confirmButtonClick:(UIButton *)button
{
    if ([self.inforView.sexCell.button.titleLabel.text isEqualToString:@"请选择(只能修改一次)"])
    {
        [WPProgressHUD showInfoWithStatus:@"请选择您的性别"];
    }
    else if ([self.inforView.addressCell.button.titleLabel.text isEqualToString:@"请选择地址"])
    {
        [WPProgressHUD showInfoWithStatus:@"请选择地址"];
    }
    else if (self.inforView.addressDetailCell.textField.text.length == 0 && self.model.address.length == 0)
    {
        [WPProgressHUD showInfoWithStatus:@"请输入详细地址"];
    }
    else if (![WPJudgeTool validateEmail:self.inforView.emailCell.textField.text] && self.model.email.length == 0)
    {
        [WPProgressHUD showInfoWithStatus:@"电子邮箱格式错误"];
    }
    else if (![WPJudgeTool validateEmail:self.inforView.emailCell.textField.text] && self.inforView.emailCell.textField.text.length > 0 && self.model.email.length != 0)
    {
        [WPProgressHUD showInfoWithStatus:@"电子邮箱格式错误"];
    }
    else
    {
        self.isAvatar = NO;
        [self pushUserInforData:nil];
    }
}

#pragma mark - Data

- (void)pushUserInforData:(UIImage *)avaterImage
{
    
    NSDictionary *parameters;
    if (self.isAvatar)
    {
        //  上传用户头像
        parameters = @{@"headImg" : self.isAvatar ? self.avatarString : @""};
    }
    else
    {
        //  上传用户信息
        parameters = @{
                        @"sex" : [self.inforView.sexCell.button.titleLabel.text isEqualToString:@"男"] ? @"1" : @"2",
                        @"country" : @"中国",
                        @"province" : self.province ? self.province : self.model.province,
                        @"city" : self.city ? self.city : self.model.city,
                        @"area" : self.county ? self.county : self.model.area,
                        @"address" : self.inforView.addressDetailCell.textField.text.length == 0 ? self.model.address : self.inforView.addressDetailCell.textField.text,
                        @"email" : self.inforView.emailCell.textField.text.length == 0 ? self.model.email : self.inforView.emailCell.textField.text
                        };
    }
    
    __weakSelf
    [WPHelpTool postWithURL:self.isAvatar ? WPUserChangeAvatarURL : WPUserChangeInforURL parameters:parameters success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        
        if ([type isEqualToString:@"1"])
        {
            //  修改个人头像
            if (weakSelf.isAvatar)
            {
                weakSelf.inforView.avatarImageView.image = avaterImage;
                NSDictionary *statusDict = [[NSDictionary alloc] initWithObjectsAndKeys:avaterImage, @"avatarImage", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationChangeUserInfor object:nil userInfo:statusDict];
            }
            //  修改个人信息
            else
            {
                [WPProgressHUD showSuccessWithStatus:@"修改成功"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:WPNotificationChangeUserInfor object:nil userInfo:nil];
            }
        }
    } failure:^(NSError *error)
    {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
