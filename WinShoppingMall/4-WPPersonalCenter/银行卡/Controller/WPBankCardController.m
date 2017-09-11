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
#import "Header.h"
#import "WPApproveLoadPhotoController.h"
#import "WPUserEnrollController.h"
#import "WPSelectController.h"

static NSString *const WPBankCardCellID = @"WPBankCardCellID";

@interface WPBankCardController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *cardArray;

@property (nonatomic, assign) NSInteger indexNumber;

@property (nonatomic, strong) WPBankCardModel *deleteModel;

@property (nonatomic, assign) BOOL showApprove;

@property (nonatomic, copy) NSString *cardID;


@end

@implementation WPBankCardController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡";
    self.view.backgroundColor = [UIColor tableViewColor];
    
    if (![WPJudgeTool isSubAccount])
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_jia_content_n"] style:UIBarButtonItemStylePlain target:self action:@selector(getUserInforTypeData)];
    }
    [self getUserCardData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCardSuccess:) name:WPNotificationAddCardSuccess object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.showApprove) {
        self.showApprove = NO;
        __weakSelf
        [WPHelpTool alertControllerTitle:@"银行卡绑定成功" confirmTitle:@"去认证" confirm:^(UIAlertAction *alertAction) {
            WPApproveLoadPhotoController *vc = [[WPApproveLoadPhotoController alloc] init];
            vc.navigationItem.title = @"认证银行卡信息";
            vc.cardId = [NSString stringWithFormat:@"%@", weakSelf.cardID];
            __weakSelf
            vc.loadApproveBlock = ^(float approveState)
            {
                [weakSelf getUserCardData];
            };
    
            [self.navigationController pushViewController:vc animated:YES];
            
        } cancel:nil];
    }
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

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(6, WPTopY, kScreenWidth - 12, kScreenHeight - WPNavigationHeight) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
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
    if ([WPJudgeTool isSubAccount])
    {
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
    return 15;
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
    if (![WPJudgeTool isSubAccount])
    {
        WPBankCardModel *model = [[WPBankCardModel alloc]init];
        model = self.cardArray[indexPath.section];
        if ([self.showCardType isEqualToString:@"1"])
        {
            //  未认证，认证失败
            if (model.auditStatus == 0 || model.auditStatus == 2)
            {
                WPApproveLoadPhotoController *vc = [[WPApproveLoadPhotoController alloc] init];
                vc.navigationItem.title = @"认证银行卡信息";
                vc.cardId = [NSString stringWithFormat:@"%ld", (long)model.id];
                __weakSelf
                vc.loadApproveBlock = ^(float approveState)
                {
                    [weakSelf getUserCardData];
                };
                
                [self.navigationController pushViewController:vc animated:YES];
            }
            //  认证中
            else if (model.auditStatus == 4)
            {
                
            }
            else
            {
                __weakSelf
                [WPHelpTool alertControllerTitle:nil rowOneTitle:@"解除绑定" rowTwoTitle:nil rowOne:^(UIAlertAction *alertAction)
                {
                    [WPHelpTool alertControllerTitle:@"确定解绑该银行卡" confirmTitle:@"确定" confirm:^(UIAlertAction *alertAction)
                    {
                        weakSelf.deleteModel = weakSelf.cardArray[indexPath.section];
                        weakSelf.indexNumber = indexPath.section;

                        [WPPayTool payWithTitle:@"解绑银行卡" password:^(id password) {
                            [weakSelf postDeleteCardDataWithPassword:password];
                        }];
                    } cancel:nil];
                } rowTwo:nil];
            }
        }
        else
        {
            if (self.cardInfoBlock)
            {
                self.cardInfoBlock(model);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)addCardSuccess:(NSNotification *)notific {
    self.cardID = notific.userInfo[@"cardId"];
    self.showApprove = YES;
    
    [self getUserCardData];
}


#pragma mark - Data

- (void)getUserCardData
{
    NSDictionary *parameters = @{
                                 @"clitype" : [NSString stringWithFormat:@"%@", self.showCardType],
                                 };
    __weakSelf

    [WPHelpTool getWithURL:WPUserBanKCardURL parameters:parameters success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            [weakSelf.cardArray removeAllObjects];
            [weakSelf.cardArray addObjectsFromArray:[WPBankCardModel mj_objectArrayWithKeyValuesArray:result[@"cardList"]]];
        }

        [WPHelpTool endRefreshingOnView:weakSelf.tableView array:result[@"cardList"] noResultLabel:weakSelf.noResultLabel title:@"没有符合条件的卡"];
        
    } failure:^(NSError *error)
    {
        
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
    [WPHelpTool postWithURL:WPUserDeleteCardURL parameters:parameters success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"])
        {
            [weakSelf.cardArray removeObjectAtIndex:weakSelf.indexNumber];
            [weakSelf.tableView reloadData];
            [WPProgressHUD showSuccessWithStatus:@"解除绑定成功"];
        }
    } failure:^(NSError *error)
    {
        
    }];
}

- (void)getUserInforTypeData
{
    if ([WPJudgeTool isIDCardApprove])
    {
        if ([WPJudgeTool isPayPassword])
        {
            WPSelectController *vc = [[WPSelectController alloc] init];
            vc.selectType = 2;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            WPPasswordController *vc = [[WPPasswordController alloc] init];
            vc.isFirstPassword = YES;
            vc.navigationItem.title = @"设置支付密码";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        [WPProgressHUD showInfoWithStatus:@"请您先完成实名认证"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
