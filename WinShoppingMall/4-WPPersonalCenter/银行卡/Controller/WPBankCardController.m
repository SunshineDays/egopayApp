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

@property (nonatomic, assign) NSInteger page;

@end

@implementation WPBankCardController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"银行卡";
    self.page = 1;
    if (![[WPUserInfor sharedWPUserInfor].isSubAccount isEqualToString:@"YES"]) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem  WP_itemWithTarget:self action:@selector(getUserInforTypeData) image:[UIImage imageNamed:@"icon_jia_content_n"] highImage:nil];
    }
    [self getUserCardData];
    
    __weakSelf
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getUserCardData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getUserCardData];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addCardSucess:) name:WPNotificationAddCardSuccess object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cardArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WPBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:WPBankCardCellID];
    cell.model = self.cardArray[indexPath.row];
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
    longPressGesture.minimumPressDuration = 1.0f;
    [cell addGestureRecognizer:longPressGesture];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WPBankCardModel *model = [[WPBankCardModel alloc]init];
    model = self.cardArray[indexPath.row];
    if ([self.showCardType isEqualToString:@"1"]) {
        //  未认证，认证失败
        if (model.auditStatus == 0 || model.auditStatus == 2) {
            WPUserLoadPhotoDetailController *vc = [[WPUserLoadPhotoDetailController alloc] init];
            vc.navigationItem.title = @"认证银行卡信息";
            vc.cardId = [NSString stringWithFormat:@"%ld", (long)model.id];
            __weakSelf
            vc.loadApproveBlock = ^(float approveState) {
//                model.auditStatus = approveState;
//                [weakSelf.cardArray replaceObjectAtIndex:indexPath.row withObject:model];
//                [weakSelf.tableView reloadData];
                [weakSelf.tableView.mj_header beginRefreshing];
            };
            
            [self.navigationController pushViewController:vc animated:YES];
        }
        //  认证中
        else if (model.auditStatus == 4) {
            
        }
    }
    else {
        if (self.cardInfoBlock) {
            self.cardInfoBlock(model);
        }
        [self.navigationController popViewControllerAnimated:YES];
//        //  储蓄卡
//        if (model.cardType == 2 && self.isOnlyBankCard) {
//            if (self.cardInfoBlock) {
//                self.cardInfoBlock(model);
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//        //  信用卡
//        else if (model.cardType == 1 && !self.isOnlyBankCard ) {
//            if (self.cardInfoBlock) {
//                self.cardInfoBlock(model);
//            }
//            [self.navigationController popViewControllerAnimated:YES];
//        }
    }
}

- (void)createPayPopupView
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

#pragma mark - Action

- (void)longPressGesture:(UILongPressGestureRecognizer *)longPressGesture
{
    NSIndexPath *indexPath;
    if (longPressGesture.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [longPressGesture locationInView:self.tableView];
        indexPath = [self.tableView indexPathForRowAtPoint:point];
        self.indexNumber = indexPath.row;
    }
    if (longPressGesture.state == UIGestureRecognizerStateEnded) {
        __weakSelf
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                       {
                                           weakSelf.deleteModel = weakSelf.cardArray[self.indexNumber];
                                           if ([[WPUserInfor sharedWPUserInfor].needTouchID isEqualToString:@"1"] || [[WPUserInfor sharedWPUserInfor].needTouchID isEqualToString:@"3"]) {
                                               [WPHelpTool payWithTouchIDsuccess:^(id touchIDSuccess) {
                                                   [weakSelf postDeleteCardDataWithPassword:touchIDSuccess];
                                                   
                                               } failure:^(NSError *error) {
                                                   [weakSelf createPayPopupView];
                                               }];
                                           }
                                           else {
                                               [weakSelf createPayPopupView];
                                           }
                                       }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertControl addAction:deleteAction];
        [alertControl addAction:cancelAction];
        [self presentViewController:alertControl animated:YES completion:nil];
    }
}

- (void)addCardSucess:(NSNotification *)notification
{
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - Data

- (void)getUserCardData
{
    NSDictionary *parameters = @{
                                 @"clitype" : [NSString stringWithFormat:@"%@", self.showCardType],
                                 };
    __weakSelf

    [WPHelpTool getWithURL:WPUserBanCardURL parameters:parameters success:^(id success) {
        if (weakSelf.page == 1) {
            [weakSelf.cardArray removeAllObjects];
        }
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.cardArray addObjectsFromArray:[WPBankCardModel mj_objectArrayWithKeyValuesArray:result[@"cardList"]]];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
        [WPHelpTool wp_endRefreshWith:weakSelf.tableView array:result[@"cardList"] noResultLabel:weakSelf.noResultLabel title:@"没有符合条件的卡"];
        
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
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
        [WPProgressHUD dismiss];
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [weakSelf.cardArray removeObjectAtIndex:weakSelf.indexNumber];
            [weakSelf.tableView reloadData];
            [WPProgressHUD showSuccessWithStatus:@"删除成功"];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
    } failure:^(NSError *error) {
        [WPProgressHUD dismiss];
    }];
}

- (void)getUserInforTypeData
{
    if ([[WPUserInfor sharedWPUserInfor].approvePassType isEqualToString:@"YES"]) {
        if ([[WPUserInfor sharedWPUserInfor].payPasswordType isEqualToString:@"YES"]) {
//            WPAddCardController *vc = [[WPAddCardController alloc] init];
            WPSelectController *vc = [[WPSelectController alloc] init];
            vc.selectType = 2;
            [self.navigationController pushViewController:vc animated:YES];
            [WPUserInfor sharedWPUserInfor].popType = @"1";
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
