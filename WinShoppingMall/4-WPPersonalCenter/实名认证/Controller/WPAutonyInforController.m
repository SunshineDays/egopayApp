//
//  WPAutonyInforController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/8/3.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPAutonyInforController.h"
#import "Header.h"
#import "WPSelectListCell.h"

@interface WPAutonyInforController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *contentArray;

@end

static NSString * const WPSelectListCellID = @"WPSelectListCellID";

@implementation WPAutonyInforController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor tableViewColor];
    self.navigationItem.title = @"实名认证";
    
    self.titleArray = @[@"真实姓名", @"证件号码"];
    self.contentArray = @[[WPPublicTool stringStarWithString:self.model.fullName headerIndex:1 footerIndex:0], [WPPublicTool stringStarWithString:[WPPublicTool base64DecodeString:self.model.identityCard] headerIndex:3 footerIndex:2]];
    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPTopY + 15, kScreenWidth, kScreenHeight - WPNavigationHeight - 15) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor tableViewColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPSelectListCell class]) bundle:nil] forCellReuseIdentifier:WPSelectListCellID];
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
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPSelectListCell *cell = [tableView dequeueReusableCellWithIdentifier:WPSelectListCellID];
    cell.cityName.text = self.titleArray[indexPath.row];
    cell.contentLabel.text = self.contentArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
