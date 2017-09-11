//
//  WPAboutEgoopayController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/8/11.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPAboutEgoopayController.h"
#import "Header.h"
#import "WPAPPInfo.h"
#import "WPUserInforCell.h"
#import "WPPublicWebViewController.h"
#import "WPNewFeatureViewController.h"

@interface WPAboutEgoopayController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *versionLabel;

@property (nonatomic, strong) UILabel *copyrightLabel;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) WPShareModel *shareModel;


@end

static NSString * const WPUserInforCellID = @"WPUserInforCell";

@implementation WPAboutEgoopayController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"关于";
    self.view.backgroundColor = [UIColor tableViewColor];
    
    self.dataArray = @[@"关于易购付", @"用户协议", @"去评价", @"分享给朋友"];
    
    [self.tableView reloadData];
//    [self copyrightLabel];
    [self getShareData];
}


- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 32, WPTopY + 25, 64, 64)];
        _imageView.image = [UIImage imageNamed:@"share_wintopay"];
        _imageView.layer.borderColor = [UIColor lineColor].CGColor;
        _imageView.layer.borderWidth = WPLineHeight;
        _imageView.layer.cornerRadius = 12;
        _imageView.layer.masksToBounds = YES;
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)versionLabel
{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame), kScreenWidth, 40)];
        _versionLabel.text = [NSString stringWithFormat:@"易购付 Egoopay %@", [WPAPPInfo APPVersion]];
        _versionLabel.textColor = [UIColor colorWithRGBString:@"909090"];
        _versionLabel.font = [UIFont systemFontOfSize:15];
        _versionLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_versionLabel];
    }
    return _versionLabel;
}

- (UILabel *)copyrightLabel
{
    if (!_copyrightLabel) {
        _copyrightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight - WPNavigationHeight - 30, kScreenWidth, 30)];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyy"];
        NSString *year = [formatter stringFromDate:date];
        _copyrightLabel.text = [NSString stringWithFormat:@"Copyright © 2015-%@ WinToPay All Rights Reserved", year];
        _copyrightLabel.textColor = [UIColor grayColor];
        _copyrightLabel.font = [UIFont systemFontOfSize:8];
        _copyrightLabel.textAlignment = NSTextAlignmentCenter;
        _copyrightLabel.numberOfLines = 0;
        [self.view addSubview:_copyrightLabel];
    }
    return _copyrightLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.versionLabel.frame), kScreenWidth, kScreenHeight - CGRectGetMaxY(self.versionLabel.frame) - 30) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPUserInforCell class]) bundle:nil] forCellReuseIdentifier:WPUserInforCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPUserInforCell *cell = [tableView dequeueReusableCellWithIdentifier:WPUserInforCellID];
    cell.titleLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            WPPublicWebViewController *vc = [[WPPublicWebViewController alloc] init];
            vc.navigationItem.title = @"易购付";
            vc.webUrl = [NSString stringWithFormat:@"%@/%@", WPBaseURL, WPAboutOurWebURL];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 1:
        {
            WPPublicWebViewController *vc = [[WPPublicWebViewController alloc] init];
            vc.navigationItem.title = @"用户使用协议";
            vc.webUrl = [NSString stringWithFormat:@"%@/%@", WPBaseURL, WPUserProtocolWebURL];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case 2:
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1240608651&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
            break;
        }
        case 3: //分享
        {
            [WPHelpTool shareToAppWithModel:self.shareModel];
            break;
        }
            
        default:
            break;
    }
}

- (void)getShareData
{
    __weakSelf
    [WPHelpTool getWithURL:WPShareToAppURL parameters:nil success:^(id success)
     {
         NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
         NSDictionary *result = success[@"result"];
         if ([type isEqualToString:@"1"])
         {
             weakSelf.shareModel = [WPShareModel mj_objectWithKeyValues:result];
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
