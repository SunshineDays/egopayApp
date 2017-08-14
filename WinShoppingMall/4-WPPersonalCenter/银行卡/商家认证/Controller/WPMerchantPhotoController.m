//
//  WPMerchantPhotoController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/2.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMerchantPhotoController.h"
#import "Header.h"
#import "WPSelectListPopupController.h"
#import "WPMerchantPhotoView.h"

@interface WPMerchantPhotoController ()<UIScrollViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (nonatomic, strong) WPMerchantPhotoView *photoView;

//  店铺类别
@property (nonatomic, copy) NSString *shopTypeString;

//  记录选择了哪一张图片
@property (nonatomic, assign) NSInteger selectedPic;

@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation WPMerchantPhotoController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"上传照片";
    
    [self photoView];
}

- (NSMutableDictionary *)shopInforDic
{
    if (!_shopInforDic) {
        _shopInforDic = [NSMutableDictionary dictionary];
    }
    return _shopInforDic;
}

- (NSMutableArray *)imageArray
{
    if (!_imageArray) {
        _imageArray = [NSMutableArray arrayWithArray:@[@"", @"", @"", @"", @""]];
    }
    return _imageArray;
}

- (WPMerchantPhotoView *)photoView
{
    if (!_photoView) {
        _photoView = [[WPMerchantPhotoView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        [_photoView.busilicenceCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        
        [_photoView.classifyCell.button addTarget:self action:@selector(shopTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.photoView.shopDescripTextView.delegate = self;
        
        for (int i = 0; i < 5; i++)
        {
            WPSelectImageButton *imageButon = _photoView.picView.subviews[i];
            imageButon.tag = i;
            [imageButon addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [_photoView.postButton addTarget:self action:@selector(postButtonClick) forControlEvents:UIControlEventTouchUpInside];

        
        [self.view addSubview:_photoView];
    }
    return _photoView;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入店铺描述(不少于20字儿)"])
    {
        textView.text = @"";
    }
    textView.textColor = [UIColor blackColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0)
    {
        textView.text = @"请输入店铺描述(不少于20字儿)";
        textView.textColor = [UIColor placeholderColor];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.photoView.numberLabel.text = [NSString stringWithFormat:@"%ld/200", (unsigned long)textView.text.length];
    [self changeButtonSurface];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    for (int i = 0; i < 5; i++)
    {
        WPSelectImageButton *imageButton = self.photoView.picView.subviews[i];
        if (self.selectedPic == i)
        {
            [imageButton setImage:image forState:UIControlStateNormal];
            if (i > 1) {
                NSString *imageString = [WPPublicTool imageToString:image];
                [self.imageArray replaceObjectAtIndex:i withObject:imageString];
            }
            else {
                [self.imageArray replaceObjectAtIndex:i withObject:[WPPublicTool imageToString:image]];
            }
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action

- (void)imageButtonClick:(WPSelectImageButton *)sender
{
    self.selectedPic = sender.tag;
    [self alertControllerWithPhoto:YES];
}

- (void)changeButtonSurface
{
    [WPPublicTool buttonWithButton:self.photoView.postButton userInteractionEnabled:(self.photoView.busilicenceCell.textField.text.length > 6 && self.photoView.shopDescripTextView.text.length >= 3) ? YES : NO];
}

- (void)shopTypeButtonClick:(UIButton *)button
{
    WPSelectListPopupController *vc = [[WPSelectListPopupController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.type = 2;
    vc.navigationItem.title = @"选择类别";
    vc.selectCategoryBlock = ^(WPMerchantCityListModel *model)
    {
        self.shopTypeString = [NSString stringWithFormat:@"%ld", model.id];
        [self.photoView.classifyCell.button setTitle:model.name forState:UIControlStateNormal];
        [self.photoView.classifyCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    };
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}


- (void)postButtonClick
{
    if (self.photoView.busilicenceCell.textField.text.length < 6)
    {
        [WPProgressHUD showInfoWithStatus:@"请输入正确的营业执照编号"];
    }
    else if ([self.photoView.classifyCell.button.titleLabel.text isEqualToString:@"请选择店铺分类"])
    {
        [WPProgressHUD showInfoWithStatus:@"请选择店铺分类"];
    }
    else if (self.photoView.shopDescripTextView.text.length < 20)
    {
        [WPProgressHUD showInfoWithStatus:@"店铺描述不能少于20字儿"];
    }
    else if ([self.imageArray[0] length] == 0 || [self.imageArray[2] length] == 0 || [self.imageArray[3] length] == 0 || [self.imageArray[4] length] == 0)
    {
        [WPProgressHUD showInfoWithStatus:@"请完善照片"];
    }
    else
    {
        [self postShopInforData];
    }
}

#pragma mark - Data

- (void)postShopInforData
{
    NSDictionary *parameters = @{
                                 @"busilicenceNo" : [WPPublicTool base64EncodeString:self.photoView.busilicenceCell.textField.text],
                                 @"categoryId" : self.shopTypeString,
                                 @"shopDescription" : self.photoView.shopDescripTextView.text,
                                 @"busilicenceImg" : self.imageArray[0],
                                 @"permitsImg" : self.imageArray[1],
                                 @"shopCoverImg" : self.imageArray[2],
                                 @"shopInsideImg_1" : self.imageArray[3],
                                 @"shopInsideImg_2" : self.imageArray[4],
                                 };
    [self.shopInforDic addEntriesFromDictionary:parameters];

    __weakSelf
    [WPHelpTool postWithURL:WPSubmitShopCertURL parameters:self.shopInforDic success:^(id success)
    {
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"])
        {
            [WPProgressHUD showSuccessWithStatus:@"提交成功"];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error)
    {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
