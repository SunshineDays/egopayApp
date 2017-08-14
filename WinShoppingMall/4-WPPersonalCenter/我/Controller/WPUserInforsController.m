//
//  WPUserInforController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/8/1.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserInforsController.h"
#import "Header.h"
#import "WPUserInforsCell.h"
#import "WPAreaPickerView.h"
#import "WPInputInforController.h"
#import "WPAutonymApproveController.h"
#import "WPMyCodeController.h"
#import "WPMerchantUploadController.h"
#import "WPMerchantDetailController.h"
#import "WPMerchantDetailModel.h"
#import "WPAutonymApproveModel.h"
#import "WPAutonyInforController.h"

@interface WPUserInforsController ()<UITableViewDelegate, UITableViewDataSource, WPAreaPickerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *contentArray;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, copy) NSString *province;

@property (nonatomic, copy) NSString *city;

@property (nonatomic, copy) NSString *area;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, strong) WPMerchantDetailModel *merchantModel;
@property (nonatomic, copy) NSString *merchantState;
@property (nonatomic, strong) NSString *failureString;

@property (nonatomic, strong) WPAutonymApproveModel *approveModel;
@property (nonatomic, copy) NSString *approveState;




@end

static NSString * const WPUserInforsCellID = @"WPUserInforsCellID";


@implementation WPUserInforsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人信息";
    
    self.approveState = @"点击认证";
    self.merchantState = @"点击认证";
    
    [self initArray];
    [self.tableView reloadData];
    
    [self getUserApproveData];
    [self getMerchantInforData];
    
}

- (void)initArray
{
    self.titleArray = @[@[@"头像", @"性别", @"手机号码"], @[@"实名认证", @"商家认证", @"我的收款码"], @[@"所在城市", @"详细地址", @"电子邮箱"]];
    
    NSString *city = ([self.model.city  isEqualToString:@"县"] || [self.model.city  isEqualToString:@"市辖区"]) ? (self.model.province ? self.model.province : @"") : (self.model.city ? self.model.city : @"");
    
    self.contentArray = @[@[self.model.picurl ? self.model.picurl : @"", self.model.sex == 1 ? @"男" : @"女", self.model.phone ? self.model.phone : @""], @[self.approveState, self.merchantState, @"", @""], @[city, self.model.address ? self.model.address : @"", self.model.email ? self.model.email : @""]];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPTopY, kScreenWidth, kScreenHeight - WPNavigationHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor tableViewColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPUserInforsCell class]) bundle:nil] forCellReuseIdentifier:WPUserInforsCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.titleArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPUserInforsCell *cell = [tableView dequeueReusableCellWithIdentifier:WPUserInforsCellID];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLabel.text = self.titleArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [cell.avaterImageView sd_setImageWithURL:[NSURL URLWithString:self.contentArray[0][0]] placeholderImage:[UIImage imageNamed:@"titlePlaceholderImage"] options:SDWebImageRefreshCached];
    }
    else if (indexPath.section == 1 && indexPath.row == 2)
    {
        cell.avaterImageView.image = [UIImage imageNamed:@"smallCode"];
    }
    else
    {
        cell.contentLabel.text = self.contentArray[indexPath.section][indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70;
    }
    else {
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0: //头像
                {
                    [self alertControllerWithPhoto:YES];
                    break;
                }
                    
                case 1: //性别
                    [self sexSelected];
                    break;
                    
                case 2: //手机号码
                {
                    
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
            
        case 1:
        {
            switch (indexPath.row) {
                case 0: //实名认证
                {
                    if ([self.approveState isEqualToString:@"已认证"])
                    {
                        WPAutonyInforController *vc = [[WPAutonyInforController alloc] init];
                        vc.model = self.approveModel;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else if ([self.approveState isEqualToString:@"认证中"])
                    {
                        
                    }
                    else {
                        WPAutonymApproveController *vc = [[WPAutonymApproveController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    
                    break;
                }
                
                    
                case 1: //商家认证
                {
                    if ([WPJudgeTool isIDCardApprove])
                    {
                        if ([self.merchantState isEqualToString:@"已认证"])
                        {
                            WPMerchantDetailController *vc = [[WPMerchantDetailController alloc] init];
                            vc.navigationItem.title = self.merchantModel.shopName;
                            vc.model = self.merchantModel;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        else if ([self.merchantState isEqualToString:@"认证中"])
                        {
                            
                        }
                        else {
                            WPMerchantUploadController *vc = [[WPMerchantUploadController alloc] init];
                            vc.failureString = self.failureString;
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                        
                        break;
                    }
                    else
                    {
                        [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
                    }
                    break;
                    
                }
                    
                case 2: //我的收款码
                {
                    if ([WPJudgeTool isIDCardApprove])
                    {
                        WPMyCodeController *vc = [[WPMyCodeController alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else
                    {
                        [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
                    }
                    break;
                }
                
                    
                default:
                    break;
            }
            break;
        }
            
        case 2:
        {
            switch (indexPath.row) {
                case 0: //选择城市
                    [self citySelected];
                    break;
                    
                case 1: //详细地址
                {
                    WPInputInforController *vc = [[WPInputInforController alloc] init];
                    vc.navigationItem.title = @"详细地址";
                    vc.placeholder = self.model.address;
                    __weakSelf
                    vc.inforBlock = ^(NSString *inforBlock) {
                        weakSelf.address = inforBlock;
                        [weakSelf postInforsData];
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                    
                case 2: //电子邮箱
                {
                    WPInputInforController *vc = [[WPInputInforController alloc] init];
                    vc.navigationItem.title = @"电子邮箱";
                    vc.placeholder = self.model.email;
                    __weakSelf
                    vc.inforBlock = ^(NSString *inforBlock) {
                        weakSelf.email = inforBlock;
                        [weakSelf postInforsData];
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                    break;
                }
                    
                default:
                    break;
            }
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self postAvaterDataWith:image];
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
    self.area = area;
    [self postInforsData];
}

#pragma mark - Action

// 选择性别
- (void)sexSelected
{
    __weakSelf
    [WPHelpTool alertControllerTitle:nil rowOneTitle:@"男" rowTwoTitle:@"女" rowOne:^(UIAlertAction *alertAction)
     {
         weakSelf.sex = [alertAction.title isEqualToString:@"男"] ? @"1" : @"2";
         [weakSelf postInforsData];
     } rowTwo:^(UIAlertAction *alertAction)
     {
         weakSelf.sex = [alertAction.title isEqualToString:@"男"] ? @"1" : @"2";
         [weakSelf postInforsData];
     }];
}

// 选择地址
- (void)citySelected
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    WPAreaPickerView *pickerView = [[WPAreaPickerView alloc] initAreaPickerView];
    pickerView.areaPickerViewDelegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:pickerView];
}


#pragma mark - Data

// 获取实名认证信息
- (void)getUserApproveData
{
    __weakSelf
    [WPHelpTool getWithURL:WPUserApproveIDCardPassURL parameters:nil success:^(id success)
     {
         NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
         NSDictionary *result = success[@"result"];
         if ([type isEqualToString:@"1"])
         {
             weakSelf.approveModel = [WPAutonymApproveModel mj_objectWithKeyValues:result];
             NSArray *stateArray = @[@"", @"已认证", @"认证失败", @"认证中"];
             weakSelf.approveState = stateArray[weakSelf.approveModel.state];
         }
         [weakSelf initArray];
         [weakSelf.tableView reloadData];
     } failure:^(NSError *error)
     {
         
     }];
}

// 获取商户认证信息
- (void)getMerchantInforData
{
    __weakSelf
    [WPHelpTool getWithURL:WPQueryShopStatusURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            // 1 成功 2 失败 3 认证中
            NSString *status = [NSString stringWithFormat:@"%@",result[@"status"]];
            
            if ([status intValue] == 1) {
                [WPUserInfor sharedWPUserInfor].shopPassType = @"YES";
                [[WPUserInfor sharedWPUserInfor] updateUserInfor];
                weakSelf.merchantModel = [WPMerchantDetailModel mj_objectWithKeyValues:result];
            }
            if ([status intValue] == 2) {
                weakSelf.failureString = result[@"msg"];
            }
            
            NSArray *stateArray = @[@"", @"已认证", @"认证失败", @"认证中"];
            weakSelf.merchantState = stateArray[[status intValue]];
        }
        [weakSelf initArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

// 获取个人信息
- (void)getUserInforData
{
    __weakSelf
    [WPHelpTool getWithURL:WPUserInforURL parameters:nil success:^(id success)
     {
         [weakSelf.indicatorView stopAnimating];
         NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
         NSDictionary *result = success[@"result"];
         
         if ([type isEqualToString:@"1"])
         {
             weakSelf.model = [WPUserInforModel mj_objectWithKeyValues:result];
             [weakSelf initArray];
         }
         [weakSelf.tableView reloadData];
     } failure:^(NSError *error)
     {
         [weakSelf.indicatorView stopAnimating];
         [weakSelf.tableView.mj_header endRefreshing];
     }];
}

// 修改头像
- (void)postAvaterDataWith:(UIImage *)avaterImage
{
    NSDictionary *parameters = @{@"headImg" : [WPPublicTool imageToString:avaterImage]};
    
    __weakSelf
    [WPHelpTool postWithURL:WPUserChangeAvatarURL parameters:parameters success:^(id success)
     {
         NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
         
         if ([type isEqualToString:@"1"])
         {
             [weakSelf getUserInforData];
             if (weakSelf.avaterBlock) {
                 weakSelf.avaterBlock(avaterImage);
             }
        }
     } failure:^(NSError *error)
     {
         
     }];
}

// 修改个人资料
- (void)postInforsData
{
    
    NSDictionary *parameters = @{
                       @"sex" : self.sex ? self.sex : [NSString stringWithFormat:@"%d", self.model.sex],
                       @"country" : @"中国",
                       @"province" : self.province ? self.province : (self.model.province ? self.model.province : @""),
                       @"city" : self.city ? self.city : (self.model.city ? self.model.city : @""),
                       @"area" : self.area ? self.area : (self.model.area ? self.model.area : @""),
                       @"address" : self.address ? self.address : (self.model.address ? self.model.address : @""),
                       @"email" : self.email ? self.email : (self.model.email ? self.model.email : @"")
                       };
    
    __weakSelf
    [WPHelpTool postWithURL:WPUserChangeInforURL parameters:parameters success:^(id success)
     {
         NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
         if ([type isEqualToString:@"1"])
         {
             [weakSelf getUserInforData];
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
