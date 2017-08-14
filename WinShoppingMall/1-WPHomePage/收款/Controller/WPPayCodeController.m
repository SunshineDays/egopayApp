//
//  WPPayCodeController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/6.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPPayCodeController.h"

#import "Header.h"
#import "SGQRCodeTool.h"
#import "WPTabBarController.h"
#import "WPMerchantUploadController.h"

@interface WPPayCodeController ()

@property (nonatomic, strong) UILabel *stateLabel;

@property (nonatomic, strong) UIImageView *codeImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImage *userAvaterImage;

@property (nonatomic, copy) NSString *payTypeString;

@property (nonatomic, strong) UIImage *centerImage;



@end

@implementation WPPayCodeController


#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"二维码";
    
    self.codeUrl = self.codeUrl ? self.codeUrl : self.codeModel.CodeUrl;
    
    switch (self.codeType)
    {
        case 1: //支付二维码
        {
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
            // 禁止右滑返回
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemAction)];
            [self stateLabel];
            [self codeImageView];
            [self titleLabel];
            break;
        }
            
        case 2: //分享二维码
        {
            self.centerImage = [UIImage imageNamed:@"appImage"];
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
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - imageWidth / 2, WPTopY + 100, imageWidth, imageWidth)];
        
        // 设置带logo的二维码
        _codeImageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:self.codeUrl logoImage:self.centerImage logoScaleToSuperView:0.2];
        _codeImageView.userInteractionEnabled = YES;
        [self.view addSubview:_codeImageView];
        
        // 给二维码添加长按保存图片事件
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
        longPressGesture.minimumPressDuration = 0.5f;
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



@end
