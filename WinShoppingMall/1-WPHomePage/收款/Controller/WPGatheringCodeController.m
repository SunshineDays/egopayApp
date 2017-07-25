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
#import "WPMerchantUploadController.h"
#import "WPStateController.h"

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
    
    self.codeUrl = self.codeUrl ? self.codeUrl : self.codeModel.CodeUrl;
    
    NSArray *codeArray = @[@"2", @"3", @"6"];
    NSArray *titleArray = @[@"微信", @"支付宝", @"QQ"];
    NSArray *imageArray = @[@"weChat", @"alipay", @"qq1"];
    
    for (int i = 0 ; i < codeArray.count; i++)
    {
        if ([[NSString stringWithFormat:@"%ld", (long)self.codeModel.method] isEqualToString:codeArray[i]])
        {
            self.payTypeString = titleArray[i];
            self.centerImage = [UIImage imageNamed:imageArray[i]];
        }
    }

    switch (self.codeType)
    {
        case 1: //支付二维码
        {
            // 禁止右滑返回
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
            [self stateLabel];
            [self codeImageView];
            [self titleLabel];
            break;
        }
            
        case 2: //我的收款码
        {
            [self getGatheringCodeData];
            break;
        }
        case 3: //分享二维码
        {
            [self codeImageView];
            [self titleLabel];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Init

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
        
        // 绘制个人收款码logo
        UIImage *backgroundImage = [self addWatemarkImageWithLogoImage:[UIImage imageNamed:@"background"] watemarkImage:self.centerImage logoImageRect:CGRectMake(0, 0, imageWidth * 0.2, imageWidth * 0.2) watemarkImageRect:CGRectMake(3, 3, imageWidth * 0.2 - 6, imageWidth * 0.2 - 6)];
        self.centerImage = self.codeType == 2 ? backgroundImage : self.centerImage;
        
        // 设置带logo的二维码
        _codeImageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:self.codeUrl logoImage:self.centerImage logoScaleToSuperView:0.2];
        _codeImageView.userInteractionEnabled = YES;
        [self.view addSubview:_codeImageView];
        
        // 给二维码添加长按保存图片事件
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

#pragma mark - Action

- (void)longPressGesture:(UILongPressGestureRecognizer *)longPressGesture
{
    if (longPressGesture.state == UIGestureRecognizerStateEnded)
    {
        __weakSelf
        [WPHelpTool alertControllerTitle:nil rowOneTitle:@"保存到相册" rowTwoTitle:nil rowOne:^(UIAlertAction *alertAction)
        {
            [weakSelf saveImageToPhotos:self.codeImageView.image];
        } rowTwo:nil];
    }
}

- (void)saveImageToPhotos:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    
    if(error != NULL)
    {
        [WPProgressHUD showInfoWithStatus:@"二维码保存失败"];
    }
    else
    {
        [WPProgressHUD showInfoWithStatus:@"二维码保存成功"];
    }
}

- (void)rightBarButtonItemAction
{
    // 开启右滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 给图片添加logo
- (UIImage *)addWatemarkImageWithLogoImage:(UIImage *)logoImage watemarkImage:(UIImage *)watemarkImage logoImageRect:(CGRect)logoImageRect watemarkImageRect:(CGRect)watemarkImageRect
{
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


#pragma mark - Data

// 获取个人二维码
- (void)getGatheringCodeData
{
    __weakSelf
    [WPHelpTool getWithURL:WPGatheringCodeURL parameters:nil success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        
        if ([type isEqualToString:@"1"])
        {
            weakSelf.codeUrl = result[@"qr_url"];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:result[@"picurl"]]];
            weakSelf.centerImage = [UIImage imageWithData:data];
            [weakSelf codeImageView];
            [weakSelf titleLabel];
        }
        else if ([type isEqualToString:@"2"])
        {
            __weakSelf
            [WPHelpTool alertControllerTitle:@"只有通过商家认证才能获取收款码" confirmTitle:@"去认证" confirm:^(UIAlertAction *alertAction)
            {
                [weakSelf getStateData];
            } cancel:^(UIAlertAction *alertAction)
            {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
        }
    } failure:^(NSError *error)
    {
        
    }];
}

// 获取商家认证状态
- (void)getStateData
{
    __weakSelf
    [WPHelpTool getWithURL:WPQueryShopStatusURL parameters:nil success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"])
        {
            // 1 成功 2 失败 3 认证中
            NSString *status = [NSString stringWithFormat:@"%@",result[@"status"]];
            if ([status isEqualToString:@"1"])
            {
                [WPUserInfor sharedWPUserInfor].shopPassType = @"YES";
                [[WPUserInfor sharedWPUserInfor] updateUserInfor];
            }
            WPMerchantUploadController *merVc = [[WPMerchantUploadController alloc] init];
            merVc.failureString = result[@"msg"];
            
            WPStateController *stateVc = [[WPStateController alloc] init];
            stateVc.status = status;
            
            [weakSelf.navigationController pushViewController:[status isEqualToString:@"2"] ? merVc : stateVc animated:YES];
        }
        else
        {
            WPMerchantUploadController *vc = [[WPMerchantUploadController alloc] init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    } failure:^(NSError *error) {
        
    }];
}




@end
