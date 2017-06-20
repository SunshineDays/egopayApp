//
//  WPUserLoadPhotoDetailController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/23.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserLoadPhotoDetailController.h"

#import "Header.h"
#import "WPImageButton.h"

@interface WPUserLoadPhotoDetailController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) WPButton *confirmLoadButton;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, assign) float imageHeight;

@property (nonatomic, strong) NSArray *titleArray;

//  记录用户点击了哪一行
@property (nonatomic, assign) NSInteger selectedLine;

//  保存图片的数组
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation WPUserLoadPhotoDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageHeight = kScreenWidth * 0.4f;
    self.titleArray = self.isIDCard ? @[@"身份证正面照", @"身份证背面照", @"手持身份证"] : @[@"银行卡正面照"];
    
    [self initPhotoButton];
    [self confirmLoadButton];
}

#pragma mark - Init

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [[NSMutableArray alloc] initWithArray:@[@"", @"", @""]];
    }
    return _imageArray;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight)];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (self.imageHeight + 10) * self.titleArray.count)];
        _backgroundView.backgroundColor = [UIColor clearColor];
        _backgroundView.userInteractionEnabled = YES;
        [self.scrollView addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (void)initPhotoButton
{
    for (int i = 0; i < self.titleArray.count; i++) {
        WPImageButton *imageButton = [[WPImageButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - self.imageHeight / 2, 10 + (self.imageHeight + 10) * i, self.imageHeight, self.imageHeight)];
        imageButton.tag = i;
        [imageButton addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        imageButton.label.text = self.titleArray[i];
        [self.backgroundView addSubview:imageButton];
    }
}


- (WPButton *)confirmLoadButton {
    if (!_confirmLoadButton) {
        _confirmLoadButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.backgroundView.frame) + 30, kScreenWidth - 2 * WPLeftMargin, 40)];
        [_confirmLoadButton setTitle:@"提交认证" forState:UIControlStateNormal];
        [_confirmLoadButton addTarget:self action:@selector(confirmLoadButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:_confirmLoadButton];
        self.scrollView.contentSize = CGSizeMake(kScreenWidth, CGRectGetMaxY(_confirmLoadButton.frame) + 10);
    }
    return _confirmLoadButton;
}

#pragma mark - Action

- (void)imageButtonClick:(WPImageButton *)sender
{
    self.selectedLine = sender.tag;
    [self createAlertControl];
    
}

- (void)confirmLoadButtonClick {
    
    if (self.isIDCard) {
        
        if ([self.imageArray[0] length] == 0 || [self.imageArray[1] length] == 0 || [self.imageArray[2] length] == 0) {
            [WPProgressHUD showInfoWithStatus:@"请完善照片"];
        }
        else {
            [self pushUserIDCardPhotoData];
        }
    }
    else {
        if ([self.imageArray[0] length] == 0) {
            [WPProgressHUD showInfoWithStatus:@"请完善照片"];
        }
        else {
            [self pushBankCardPhotoData];
        }
    }
}

#pragma mark - 选取照片
- (void)createAlertControl {
    [self presentViewController:self.alertCameraSheet animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    for (int i = 0; i < self.titleArray.count; i++) {
        WPImageButton *imageButton = self.backgroundView.subviews[i];
        if (self.selectedLine == i) {
            [imageButton setImage:image forState:UIControlStateNormal];
            self.imageArray[i] = [self imageToString:image];
        }
    }

//    SEL selectorToCall = @selector(image:didFinishSavingWithError:contextInfo:);
//    UIImageWriteToSavedPhotosAlbum(image, self, selectorToCall, NULL);
}

#pragma mark - UIImage转NSString
- (NSString *)imageToString:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 0.1f);
    NSString *imageString = [data base64EncodedStringWithOptions:0];
    return imageString;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error == nil){
//        NSLog(@"Image was saved successfully.");
    } else {
//        NSLog(@"An error happened while saving the image.");
//        NSLog(@"Error = %@", error);
    }
}


#pragma mark - 解析数据

#pragma mark - 上传身份证照片
- (void)pushUserIDCardPhotoData {
    [WPProgressHUD showProgressWithStatus:@"提交中..."];
    NSDictionary *parameters = @{
                                 @"fileA" : self.imageArray[0],
                                 @"fileB" : self.imageArray[1],
                                 @"fileC" : self.imageArray[2]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPUserApproveIDCardPhotoURL parameters:parameters success:^(id success) {
        [WPProgressHUD dismiss];

        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [WPProgressHUD showSuccessWithStatus:@"提交认证成功"];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
        
    } failure:^(NSError *error) {
        [WPProgressHUD dismiss];
    }];
}

#pragma mark - 上传银行卡照片
- (void)pushBankCardPhotoData {
    [WPProgressHUD showProgressWithStatus:@"提交中..."];
    
    NSDictionary *parameters = @{
                                 @"fileA" : self.imageArray[0],
                                 @"cardId" : [NSString stringWithFormat:@"%@", self.cardId]
                                 };
    __weakSelf
    [WPHelpTool postWithURL:WPUserApproveBankCardPhotoURL parameters:parameters success:^(id success) {
        [WPProgressHUD dismiss];

        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        NSDictionary *result = success[@"result"];
        if ([type isEqualToString:@"1"]) {
            [WPProgressHUD showSuccessWithStatus:@"提交认证成功"];
            
            if (weakSelf.loadApproveBlock) {
                weakSelf.loadApproveBlock(4);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        else {
            [WPProgressHUD showInfoWithStatus:result[@"err_msg"]];
        }
        
    } failure:^(NSError *error) {
        [WPProgressHUD dismiss];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
