//
//  WPBankCardController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/23.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBankCardController.h"

#import "WPAddCardController.h"
#import "WPUserEnrollController.h"
#import "WPBankCardCell.h"
#import "WPBankCardModel.h"
#import "WPPayPopupController.h"
#import "Header.h"
#import "WPUserLoadPhotoDetailController.h"
#import "WPUserEnrollController.h"
#import "WPSelectController.h"

static NSString *const WPBankCardCellID = @"WPBankCardCellID";

@interface WPBankCardController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *cardArray;

@property (nonatomic, assign) NSInteger indexNumber;

@property (nonatomic, strong) WPBankCardModel *deleteModel;

@end

@implementation WPBankCardController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡";
    if (![WPAppTool isSubAccount]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_jia_content_n"] style:UIBarButtonItemStylePlain target:self action:@selector(getUserInforTypeData)];
    }
    [self getUserCardData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserCardData) name:WPNotificationAddCardSuccess object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Init

- (NSMutableArray *)cardArray
{
    if (!_cardArray) {
        _cardArray = [NSMutableArray array];
    }
    return _cardArray;
}

- (void)initPayPopupView
{
    WPPayPopupController *vc = [[WPPayPopupController alloc] init];
    vc.titleString = @"解绑银行卡";
    vc.modalPresentationStyle = UIModalPresentationCustom;
    __weakSelf
    vc.payPasswordBlock = ^(NSString *payPassword) {
        [weakSelf postDeleteCardDataWithPassword:payPassword];
    };
    vc.forgetPasswordBlock = ^{
        WPPasswordController *vc = [[WPPasswordController alloc] init];
        vc.passwordType = @"2";
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(6, WPNavigationHeight, kScreenWidth - 12, kScreenHeight - WPNavigationHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([WPBankCardCell class]) bundle:nil] forCellReuseIdentifier:WPBankCardCellID];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cardArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:WPBankCardCellID];
    cell.model = self.cardArray[indexPath.section];
    if ([WPAppTool isSubAccount]) {
        cell.userInteractionEnabled = NO;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (![WPAppTool isSubAccount]) {
        WPBankCardModel *model = [[WPBankCardModel alloc]init];
        model = self.cardArray[indexPath.section];
        if ([self.showCardType isEqualToString:@"1"]) {
            //  未认证，认证失败
            if (model.auditStatus == 0 || model.auditStatus == 2) {
                WPUserLoadPhotoDetailController *vc = [[WPUserLoadPhotoDetailController alloc] init];
                vc.navigationItem.title = @"认证银行卡信息";
                vc.cardId = [NSString stringWithFormat:@"%ld", (long)model.id];
                __weakSelf
                vc.loadApproveBlock = ^(float approveState) {
                    [weakSelf getUserCardData];
                };
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            //  认证中
            else if (model.auditStatus == 4) {
                
            }
            else {
                __weakSelf
                [WPHelpTool alertControllerTitle:@"" rowOneTitle:@"解除绑定" rowTwoTitle:nil rowOne:^(UIAlertAction *alertAction) {
                    weakSelf.deleteModel = weakSelf.cardArray[indexPath.row];
                    weakSelf.indexNumber = indexPath.row;
                    if ([WPAppTool isPayTouchID]) {
                        [WPHelpTool payWithTouchIDsuccess:^(id success) {
                            [weakSelf postDeleteCardDataWithPassword:success];
                            
                        } failure:^(NSError *error) {
                            [weakSelf initPayPopupView];
                        }];
                    }
                    else {
                        [weakSelf initPayPopupView];
                    }
                } rowTwo:nil];
            }
        }
        else {
            if (self.cardInfoBlock) {
                self.cardInfoBlock(model);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - Data

- (void)getUserCardData
{
    NSDictionary *parameters = @{
                                 @"clitype" : [NSString stringWithFormat:@"%@", self.showCardType],
                                 };
    __weakSelf

    [WPHelpTool getWithURL:WPUserBanCardURL parameters:parameters success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.cardArray removeAllObjects];
            [weakSelf.cardArray addObjectsFromArray:[WPBankCardModel mj_objectArrayWithKeyValuesArray:result[@"cardList"]]];
        }

        [WPHelpTool wp_endRefreshWith:weakSelf.tableView array:result[@"cardList"] noResultLabel:weakSelf.noResultLabel title:@"没有符合条件的卡"];
        
    } failure:^(NSError *error) {
    }];
}

- (void)postDeleteCardDataWithPassword:(NSString *)password
{
    [WPProgressHUD showProgressIsLoading];
    NSDictionary *parameters = @{
                                 @"cardId" : [NSString stringWithFormat:@"%ld", (long)self.deleteModel.id],
                                 @"payPassword" : [WPPublicTool base64EncodeString:password]
                                 };
    
    __weakSelf
    [WPHelpTool postWithURL:WPUserDeleteCardURL parameters:parameters success:^(id success) {
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.cardArray removeObjectAtIndex:weakSelf.indexNumber];
            [weakSelf.tableView reloadData];
            [WPProgressHUD showSuccessWithStatus:@"解除绑定成功"];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)getUserInforTypeData
{
    if ([WPAppTool isPassIDCardApprove]) {
        if ([WPAppTool isHavePayPassword]) {
            WPSelectController *vc = [[WPSelectController alloc] init];
            vc.selectType = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else {
            WPPasswordController *vc = [[WPPasswordController alloc] init];
            vc.isFirstPassword = YES;
            vc.navigationItem.title = @"设置支付密码";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else  {
        [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
