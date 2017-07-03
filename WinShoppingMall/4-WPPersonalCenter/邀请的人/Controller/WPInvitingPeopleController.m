//
//  WPInvitingPeopleController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/23.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPInvitingPeopleController.h"
#import "WPInvitingPeopleModel.h"
#import "Header.h"
#import "WPMessagesCell.h"

static NSString * const WPMessageCellID = @"WPMessageCellID";

@interface WPInvitingPeopleController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WPInvitingPeopleController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"邀请的人";
    
    [self getInvitingPeopleData];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPMessagesCell class]) bundle:nil] forCellReuseIdentifier:WPMessageCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WPMessagesCell *cell = [_tableView dequeueReusableCellWithIdentifier:WPMessageCellID];
    WPInvitingPeopleModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = [WPPublicTool stringWithStarString:[NSString stringWithFormat:@"%@", model.phone] headerIndex:3 footerIndex:4];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


}

#pragma mark - Data

- (void)getInvitingPeopleData {

    __weakSelf
    [WPHelpTool getWithURL:WPMyRefers parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            
            [weakSelf.dataArray addObjectsFromArray:[WPInvitingPeopleModel mj_objectArrayWithKeyValuesArray:result[@"myRefers"]]];
            [weakSelf.tableView reloadData];
        }
        [WPHelpTool wp_endRefreshWith:weakSelf.tableView array:result[@"myRefers"] noResultLabel:weakSelf.noResultLabel title:@"您还没有邀请的人哦"];
    } failure:^(NSError *error) {
        
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
