//
//  WPMyCodeController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/7/29.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMyCodeController.h"
#import "Header.h"
#import "SGQRCodeTool.h"
#import "WPBillController.h"
#import "WPMerchantUploadController.h"

@interface WPMyCodeController ()

@property (nonatomic, strong) UIView *codeView;

@property (nonatomic, strong) UIView *titleView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *codeImageView;

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UIButton *recodeButton;

@property (nonatomic, strong) UIImage *centerImage;

@property (nonatomic, copy) NSString *codeUrl;

@property (nonatomic, assign) float height;;


@end

@implementation WPMyCodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的收款码";
    self.view.backgroundColor = [UIColor themeColor];
    
    self.height = ((kScreenWidth - 30) / 3 - 30) / 2;

    [self getGatheringCodeData];
}


- (UIView *)codeView
{
    if (!_codeView) {
        _codeView = [[UIView alloc] initWithFrame:CGRectMake(15, WPTopY + 20, kScreenWidth - 30, kScreenWidth - 30)];
        _codeView.backgroundColor = [UIColor whiteColor];
        _codeView.userInteractionEnabled = YES;
        _codeView.layer.borderColor = [UIColor lineColor].CGColor;
        _codeView.layer.borderWidth = WPLineHeight;
        _codeView.layer.cornerRadius = WPCornerRadius;
        _codeView.layer.masksToBounds = YES;
        [self.view addSubview:_codeView];
    }
    return _codeView;
}

- (UIView *)titleView
{
    if (!_titleView) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.codeView.frame), 40)];
        _titleView.backgroundColor = [UIColor cellColor];
        [self.codeView addSubview:_titleView];
        
        UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
        titleImageView.image = [UIImage imageNamed:@"icon_chongzhi_content_n"];
        titleImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.titleView addSubview:titleImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleImageView.frame) + 10, 5, 100, 30)];
        titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.text = @"商户收钱";
        [self.titleView addSubview:titleLabel];
    }
    return _titleView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), CGRectGetWidth(self.codeView.frame), self.height)];
        _titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.text = @"扫一扫，向我付钱";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.codeView addSubview:_titleLabel];
    }
    return _titleLabel;
}


- (UIImageView *)codeImageView
{
    if (!_codeImageView) {
        
        float imageWidth = CGRectGetWidth(self.codeView.frame) / 3 * 2;
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth / 2 / 2, CGRectGetMaxY(self.titleLabel.frame), imageWidth, imageWidth)];
        // 绘制个人收款码logo
        self.centerImage = [self addWatemarkImageWithLogoImage:[UIImage imageNamed:@"background"] watemarkImage:self.centerImage logoImageRect:CGRectMake(0, 0, imageWidth * 0.2, imageWidth * 0.2) watemarkImageRect:CGRectMake(3, 3, imageWidth * 0.2 - 6, imageWidth * 0.2 - 6)];
        
        // 设置带logo的二维码
        _codeImageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:self.codeUrl logoImage:self.centerImage logoScaleToSuperView:0.2];
//        _codeImageView.tintColor = [UIColor themeColor];
//        _codeImageView.image = [SGQRCodeTool SG_generateWithColorQRCodeData:self.codeUrl backgroundColor:[CIColor blueColor] mainColor:[CIColor whiteColor]];
        _codeImageView.userInteractionEnabled = YES;
        [self.codeView addSubview:_codeImageView];
        
        
        // 给二维码添加长按保存图片事件
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
        longPressGesture.minimumPressDuration = 0.5f;
        [_codeImageView addGestureRecognizer:longPressGesture];
    }
    return _codeImageView;
}


- (UILabel *)stateLabel
{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.codeImageView.frame), CGRectGetWidth(self.codeView.frame), self.height)];
        _stateLabel.text = @"长按图片可以保存二维码";
        _stateLabel.textColor = [UIColor grayColor];
        _stateLabel.font = [UIFont systemFontOfSize:13];
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        [self.codeView addSubview:_stateLabel];
        
    }
    return _stateLabel;
}

- (UIButton *)recodeButton
{
    if (!_recodeButton) {
        _recodeButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, kScreenHeight - WPNavigationHeight - 60, 100, 50)];
        [_recodeButton setTitle:@"收款记录" forState:UIControlStateNormal];
        _recodeButton.titleLabel.font = [UIFont systemFontOfSize:17];
        [_recodeButton addTarget:self action:@selector(recodeButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_recodeButton];
    }
    return _recodeButton;
}

#pragma mark - Action

- (void)recodeButtonAction
{
    WPBillController *vc = [[WPBillController alloc] init];
    vc.isCheck = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

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

             dispatch_async(dispatch_get_main_queue(), ^{
                 weakSelf.centerImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:result[@"picurl"]];
                 weakSelf.centerImage = weakSelf.centerImage ? weakSelf.centerImage : [UIImage imageNamed:@"appImage"];
                 [weakSelf stateLabel];
                 [weakSelf recodeButton];
             });
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
             else if ([status isEqualToString:@"2"])
             {
                 WPMerchantUploadController *vc = [[WPMerchantUploadController alloc] init];
                 vc.failureString = result[@"msg"];
                 [weakSelf.navigationController pushViewController:vc animated:YES];
             }
             else if ([status isEqualToString:@"3"])
             {
                 [WPProgressHUD showInfoWithStatus:@"认证中,请耐心等待"];
             }
             else
             {
                 WPMerchantUploadController *vc = [[WPMerchantUploadController alloc] init];
                 [weakSelf.navigationController pushViewController:vc animated:YES];
             }
         }
         else
         {
             WPMerchantUploadController *vc = [[WPMerchantUploadController alloc] init];
             [weakSelf.navigationController pushViewController:vc animated:YES];
         }
     } failure:^(NSError *error) {
         
     }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
