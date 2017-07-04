//
//  WPGatheringCodeController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/6.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPGatheringCodeController.h"

#import "Header.h"
#import "SGQRCodeTool.h"
#import "WPTabBarController.h"
#import "WPTouchIDShowController.h"

@interface WPGatheringCodeController ()

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UIImageView *codeImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImage *userAvaterImage;

@property (nonatomic, copy) NSString *payTypeString;

@property (nonatomic, strong) UIImage *centerImage;

@end

@implementation WPGatheringCodeController


#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.codeType == 2 ? @"我的收款码" : @"二维码";
    switch (self.payType) {
        case 1: {
            self.payTypeString = @"微信";
            self.centerImage = [UIImage imageNamed:@"weChat"];
        }
            break;
            
        case 2: {
            self.payTypeString = @"支付宝";
            self.centerImage = [UIImage imageNamed:@"alipay"];
        }
            break;
            
        case 3: {
            self.payTypeString = @"QQ";
            self.centerImage = [UIImage imageNamed:@"qq1"];
        }
            break;
            
        default:
            break;
    }

    switch (self.codeType) {
        case 1: {  //支付二维码
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(confrimButtonClick:)];
            [self stateLabel];
            [self codeImageView];
            [self titleLabel];
        }
            break;
            
        case 2: {  //我的收款码
            if ([WPUserInfor sharedWPUserInfor].codeUrl.length > 0) {
                self.codeString= [WPUserInfor sharedWPUserInfor].codeUrl;
                [self codeImageView];
                [self titleLabel];
            }
            else {
                [self getGatheringCodeData];
            }
        }
            break;
            
        case 3: {  //分享二维码
            [self codeImageView];
            [self titleLabel];
        }
            break;
            
        default:
            break;
    }
}

- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, WPTopMargin, kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
        _stateLabel.text = [NSString stringWithFormat:@"请先保存二维码图片，在%@中扫描支付", self.payTypeString];
        _stateLabel.numberOfLines = 0;
        _stateLabel.textColor = [UIColor blackColor];
        _stateLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        [self.view addSubview:_stateLabel];
    }
    return _stateLabel;
}

- (UIImageView *)codeImageView
{
    if (!_codeImageView) {
        float imageWidth = 250;
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - imageWidth / 2, WPNavigationHeight + 100, imageWidth, imageWidth)];
        _codeImageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:self.codeString logoImage:self.centerImage logoScaleToSuperView:0.2];
        _codeImageView.userInteractionEnabled = YES;
        [self.view addSubview:_codeImageView];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
        longPressGesture.minimumPressDuration = 1.0f;
        [_codeImageView addGestureRecognizer:longPressGesture];
    }
    return _codeImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.codeImageView.frame), kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
        _titleLabel.text = @"长按图片可以保存二维码";
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateEnded) {
        __weakSelf
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf downloadButtonAction];
        }]];
        [alertControl addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertControl animated:YES completion:nil];
    }
}

- (void)downloadButtonAction
{
    [self saveImageToPhotos:self.codeImageView.image];
}


- (void)saveImageToPhotos:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    
    if(error != NULL){
        [WPProgressHUD showInfoWithStatus:@"二维码保存失败"];
    }
    else{
        [WPProgressHUD showInfoWithStatus:@"二维码保存成功"];
    }
}

- (void)confrimButtonClick:(UIButton *)button {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Data

- (void)getGatheringCodeData
{
    __weakSelf
    [WPHelpTool getWithURL:WPGatheringCodeURL parameters:nil success:^(id success) {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        
        if ([type isEqualToString:@"1"]) {
            weakSelf.codeString = result[@"qr_url"];
            [WPUserInfor sharedWPUserInfor].codeUrl = weakSelf.codeString;
            [[WPUserInfor sharedWPUserInfor] updateUserInfor];
            [weakSelf codeImageView];
            [weakSelf titleLabel];
}
        else if ([type isEqualToString:@"2"]) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (UIImage *)addWatemarkImageWithLogoImage:(UIImage *)logoImage watemarkImage:(UIImage *)watemarkImage logoImageRect:(CGRect)logoImageRect watemarkImageRect:(CGRect)watemarkImageRect{
    // 创建一个graphics context来画我们的东西
    UIGraphicsBeginImageContext(logoImageRect.size);
    // graphics context就像一张能让我们画上任何东西的纸。我们要做的第一件事就是把person画上去
    [logoImage drawInRect:CGRectMake(0, 0, logoImageRect.size.width, logoImageRect.size.height)];
    // 然后在把hat画在合适的位置
    [watemarkImage drawInRect:CGRectMake(watemarkImageRect.origin.x, watemarkImageRect.origin.y, watemarkImageRect.size.width, watemarkImageRect.size.height)];
    // 通过下面的语句创建新的UIImage
    UIImage * resultImage = UIGraphicsGetImageFromCurrentImageContext();
    // 最后，我们必须得清理并关闭这个再也不需要的context
    UIGraphicsEndImageContext();
    return resultImage;
}


@end
