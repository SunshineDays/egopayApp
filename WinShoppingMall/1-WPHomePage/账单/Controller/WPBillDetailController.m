//
//  WPBillDetailController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/4/17.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPBillDetailController.h"

#import "Header.h"
#import "SGQRCodeTool.h"

@interface WPBillDetailController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIImageView *codeImageView;

@property (nonatomic, strong) UIImage *centerImage;

@property (nonatomic, strong) UILabel *imageTitleLabel;

@property (nonatomic, assign) BOOL isShowCode;


@end

@implementation WPBillDetailController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"账单详情";
    
    NSArray *codeArray = @[@"2", @"3", @"6"];
//    NSArray *titleArray = @[@"微信", @"支付宝", @"QQ"];
    NSArray *imageArray = @[@"weChat", @"alipay", @"qq1"];
    
    for (int i = 0 ; i < codeArray.count; i++)
    {
        if ([[NSString stringWithFormat:@"%ld", (long)self.model.paychannelid] isEqualToString:codeArray[i]])
        {
            self.centerImage = [UIImage imageNamed:imageArray[i]];
        }
    }
    
    [self titleLabel];
    [self contentLabel];
    [self lineView];
}

#pragma mark - Init

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, WPTopY, kScreenWidth, kScreenHeight - WPNavigationHeight)];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        NSArray *titleArray = self.model.counterFee > 0 ? @[@"付款金额", @"手续费", @"可提现金额", @"当前状态", @"交易类型", @"支付方式", @"创建时间", @"账单编号", @"备        注"] : @[@"付款金额", @"当前状态", @"交易类型", @"支付方式", @"支付时间", @"账单编号", @"备        注"];
        for (int i = 0; i < titleArray.count; i++) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, 10 + 40 * i, 80, 40)];
            _titleLabel.text = titleArray[i];
            _titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
            _titleLabel.textColor = [UIColor darkGrayColor];
            [self.scrollView addSubview:_titleLabel];
        }
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        NSString *moneyString = [NSString stringWithFormat:@"%.2f", self.model.amount];
        
        NSString *poundageString = [NSString stringWithFormat:@"%.2f", self.model.counterFee];
        
        NSString *trueMoneyString = [NSString stringWithFormat:@"%.2f", self.model.avl_amount];

        NSString *stateString = [WPUserTool billTypeStateWithModel:self.model];
        
        self.isShowCode = [stateString isEqualToString:@"待支付"] ? YES : NO;
        
        NSString *typeString = [WPUserTool billTypePurposeWithModel:self.model];
        
        NSString *wayString = [WPUserTool billTypeWayWithModel:self.model];

        NSString *dateString = [WPPublicTool stringToDateString:[NSString stringWithFormat:@"%@", self.model.createDate ? self.model.createDate : self.model.finishDate]];
        NSString *numberString = [NSString stringWithFormat:@"%@", self.model.orderno];
        NSString *remarkString = self.model.remark ? self.model.remark : @"无";
                
        NSArray *contentArray = self.model.counterFee > 0 ? @[moneyString, poundageString, trueMoneyString, stateString, typeString, wayString, dateString, numberString, remarkString] : @[moneyString, stateString, typeString, wayString, dateString, numberString, remarkString];
        
        //  动态设置备注高度
        float height = [WPPublicTool textHeightFromTextString:remarkString width:kScreenWidth - WPLeftMarginField - WPLeftMargin miniHeight:40 fontSize:15];
        
        for (int i = 0; i < contentArray.count; i++)
        {
            _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMarginField, 10 + 40 * i, kScreenWidth - WPLeftMarginField - WPLeftMargin, i == contentArray.count - 1 ? height : 40)];
            _contentLabel.text = contentArray[i];
            _contentLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
            _contentLabel.textColor = [UIColor grayColor];
            _contentLabel.textAlignment = NSTextAlignmentRight;
            _contentLabel.numberOfLines = 0;
            [self.scrollView addSubview:_contentLabel];
        }
        if (self.isShowCode) {
            [self codeImageView];
        }
        else {
            self.scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(_contentLabel.frame) + 20);
        }
    }
    return _contentLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.contentLabel.frame) + 10, kScreenWidth - WPLeftMargin, WPLineHeight)];
        _lineView.backgroundColor = [UIColor lineColor];
        [self.scrollView addSubview:_lineView];
    }
    return _lineView;
}

- (UILabel *)imageTitleLabel
{
    if (!_imageTitleLabel) {
        _imageTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.lineView.frame), kScreenWidth - 2 * WPLeftMargin, WPRowHeight)];
        _imageTitleLabel.text = @"长按图片可以保存二维码";
        _imageTitleLabel.numberOfLines = 0;
        _imageTitleLabel.textColor = [UIColor grayColor];
        _imageTitleLabel.textAlignment = NSTextAlignmentCenter;
        _imageTitleLabel.font = [UIFont systemFontOfSize:13];
        [self.scrollView addSubview:_imageTitleLabel];
        
        [self codeImageView];
    }
    return _imageTitleLabel;
}

- (UIImageView *)codeImageView
{
    if (!_codeImageView) {
        float imageWidth = 250;
        _codeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - imageWidth / 2, CGRectGetMaxY(self.imageTitleLabel.frame), imageWidth, imageWidth)];
        
        // 设置带logo的二维码
        _codeImageView.image = [SGQRCodeTool SG_generateWithLogoQRCodeData:self.model.codeUrl logoImage:self.centerImage logoScaleToSuperView:0.2];
        _codeImageView.userInteractionEnabled = YES;
        
        // 给二维码添加长按保存图片事件
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressGesture:)];
        longPressGesture.minimumPressDuration = 1.0f;
        [_codeImageView addGestureRecognizer:longPressGesture];
        
        [self.scrollView addSubview:_codeImageView];
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(_codeImageView.frame) + 20);

    }
    return _codeImageView;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
