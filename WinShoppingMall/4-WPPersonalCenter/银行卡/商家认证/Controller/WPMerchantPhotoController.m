//
//  WPMerchantPhotoController.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/5/2.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPMerchantPhotoController.h"
#import "Header.h"
#import "WPSelectListController.h"
#import "WPImageButton.h"

@interface WPMerchantPhotoController ()<UIScrollViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (nonatomic, assign) float picHeight;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) WPRowTableViewCell *busilicenceCell;

@property (nonatomic, strong) WPImageButton *busilicenceButton;

@property (nonatomic, strong) WPRowTableViewCell *classifyCell;

@property (nonatomic, strong) UITextView *shopDescripTextView;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) WPImageButton *shopCoverButton;

@property (nonatomic, strong) WPButton *postButton;

@property (nonatomic, assign) int selectedLine;

@property (nonatomic, copy) NSString *busilicenceString;

@property (nonatomic, copy) NSString *shopString;

@property (nonatomic, copy) NSString *shopTypeString;

@end

@implementation WPMerchantPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"上传照片";
    
    self.picHeight = kScreenWidth * 0.4f;
    
    [self postButton];
    
}

- (NSMutableDictionary *)shopInforDic
{
    if (!_shopInforDic) {
        _shopInforDic = [NSMutableDictionary dictionary];
    }
    return _shopInforDic;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, WPNavigationHeight, kScreenWidth, kScreenHeight - WPNavigationHeight)];
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (WPRowTableViewCell *)busilicenceCell
{
    if (!_busilicenceCell) {
        _busilicenceCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, 10, kScreenWidth, WPRowHeight);
        [_busilicenceCell tableViewCellTitle:@"营业执照编号" placeholder:@"请输入营业执照编号" rectMake:rect];
        [_busilicenceCell.titleLabel setFrame:CGRectMake(WPLeftMargin, 0, 100, WPRowHeight)];
        [_busilicenceCell.textField setFrame:CGRectMake(CGRectGetMaxX(_busilicenceCell.titleLabel.frame) + 10, 0, kScreenWidth - CGRectGetMaxX(_busilicenceCell.titleLabel.frame) - WPLeftMargin, WPRowHeight)];
        _busilicenceCell.textField.keyboardType = UIKeyboardTypeNumberPad;
        [_busilicenceCell.textField addTarget:self action:@selector(changeButtonSurface) forControlEvents:UIControlEventEditingChanged];
        [_busilicenceCell.textField becomeFirstResponder];
        [self.scrollView addSubview:_busilicenceCell];
    }
    return _busilicenceCell;
}


- (WPImageButton *)busilicenceButton
{
    if (!_busilicenceButton) {
        _busilicenceButton = [[WPImageButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - self.picHeight / 2, CGRectGetMaxY(self.busilicenceCell.frame) + 5, self.picHeight, self.picHeight)];
        [_busilicenceButton addTarget:self action:@selector(busilicenceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _busilicenceButton.label.text = @"营业执照照片";
        [self.scrollView addSubview:_busilicenceButton];
        
    }
    return _busilicenceButton;
}

- (WPRowTableViewCell *)classifyCell {
    if (!_classifyCell) {
        _classifyCell = [[WPRowTableViewCell alloc] init];
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.busilicenceButton.frame) + 10, kScreenWidth, WPRowHeight);
        [_classifyCell tableViewCellTitle:@"店铺分类" buttonTitle:@"请选择店铺分类" rectMake:rect];
        [_classifyCell.button addTarget:self action:@selector(shopTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:_classifyCell];
    }
    return _classifyCell;
}

- (UITextView *)shopDescripTextView
{
    if (!_shopDescripTextView) {
        _shopDescripTextView = [[UITextView alloc] initWithFrame:CGRectMake(WPLeftMarginField, CGRectGetMaxY(self.classifyCell.frame) + 5, kScreenWidth - WPLeftMarginField - WPLeftMargin, 150)];
        _shopDescripTextView.backgroundColor = [UIColor whiteColor];
        _shopDescripTextView.delegate = self;
        _shopDescripTextView.layer.masksToBounds = YES;
        _shopDescripTextView.layer.borderColor = [UIColor lineColor].CGColor;
        _shopDescripTextView.layer.borderWidth = 1.0f;
        _shopDescripTextView.layer.cornerRadius = WPCornerRadius;
        _shopDescripTextView.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _shopDescripTextView.text = @"请输入店铺描述(不少于100字儿)";
        _shopDescripTextView.textColor = [UIColor placeholderColor];
        
        _shopDescripTextView.scrollEnabled = YES;
        [self.scrollView addSubview:_shopDescripTextView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.classifyCell.frame), 80, WPRowHeight)];
        titleLabel.text = @"店铺描述";
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        [self.scrollView addSubview:titleLabel];
        [self numberLabel];
    }
    return _shopDescripTextView;
}

- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.shopDescripTextView.frame.size.width - 60, 130, 60, 20)];
        _numberLabel.text = @"0/500";
        _numberLabel.textColor = [UIColor grayColor];
        _numberLabel.font = [UIFont systemFontOfSize:WPFontDefaultSize];
        _numberLabel.textAlignment = NSTextAlignmentRight;
        [self.shopDescripTextView addSubview:_numberLabel];
    }
    return _numberLabel;
}

- (WPImageButton *)shopCoverButton
{
    if (!_shopCoverButton) {
        _shopCoverButton = [[WPImageButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - self.picHeight / 2, CGRectGetMaxY(self.shopDescripTextView.frame) + 5, self.picHeight, self.picHeight)];
        [_shopCoverButton addTarget:self action:@selector(shopCoverButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _shopCoverButton.label.text = @"店铺照片";
        [self.scrollView addSubview:_shopCoverButton];
    }
    return _shopCoverButton;
}

- (WPButton *)postButton
{
    if (!_postButton) {
        _postButton = [[WPButton alloc] initWithFrame:CGRectMake(WPLeftMargin, CGRectGetMaxY(self.shopCoverButton.frame) + 30, kScreenWidth - WPLeftMargin * 2, WPRowHeight)];
        [_postButton setTitle:@"提交认证" forState:UIControlStateNormal];
        [_postButton addTarget:self action:@selector(postButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:_postButton];
        
        self.scrollView.contentSize = CGSizeMake(kScreenSize.width, CGRectGetMaxY(self.postButton.frame) + 3);
    }
    return _postButton;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"请输入店铺描述(不少于100字儿)"]) {
        textView.text = @"";
    }
    textView.textColor = [UIColor blackColor];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        textView.text = @"请输入店铺描述(不少于100字儿)";
        textView.textColor = [UIColor placeholderColor];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/500", (unsigned long)textView.text.length];
    [self changeButtonSurface];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    switch (self.selectedLine) {
        case 1:
        {
            [self.busilicenceButton setImage:image forState:UIControlStateNormal];
            self.busilicenceString = [WPPublicTool imageToString:image];
        }
            break;
        case 2:
        {
            [self.shopCoverButton setImage:image forState:UIControlStateNormal];
            self.busilicenceString = [WPPublicTool imageToString:image];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Action

- (void)changeButtonSurface
{
    [WPPublicTool buttonWithButton:self.postButton userInteractionEnabled:(self.busilicenceCell.textField.text.length > 10 && self.shopDescripTextView.text.length >= 20) ? YES : NO];
}

- (void)busilicenceButtonClick:(UIButton *)button
{
    self.selectedLine = 1;
    [self alertControllerWithPhoto:YES];
}

- (void)shopTypeButtonClick:(UIButton *)button
{
    WPSelectListController *vc = [[WPSelectListController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.type = 2;
    vc.navigationItem.title = @"选择类别";
    vc.selectCategoryBlock = ^(WPMerchantCityListModel *model) {
        self.shopTypeString = [NSString stringWithFormat:@"%ld", model.id];
        [self.classifyCell.button setTitle:model.name forState:UIControlStateNormal];
        [self.classifyCell.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    };
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (void)shopCoverButtonClick:(UIButton *)button
{
    self.selectedLine = 2;
    [self alertControllerWithPhoto:YES];
}

- (void)postButtonClick:(UIButton *)button
{
    if (self.busilicenceCell.textField.text.length < 13 || self.busilicenceCell.textField.text.length > 20) {
        [WPProgressHUD showInfoWithStatus:@"请输入正确的营业执照编号"];
    }
    else if ([self.classifyCell.button.titleLabel.text isEqualToString:@"请选择店铺分类"]) {
        [WPProgressHUD showInfoWithStatus:@"请选择店铺分类"];
    }
    else if (self.shopDescripTextView.text.length < 100) {
        [WPProgressHUD showInfoWithStatus:@"店铺描述不能少于100字儿"];
    }
    else if (self.busilicenceString.length == 0) {
        [WPProgressHUD showInfoWithStatus:@"请选择营业执照照片"];
    }
    else if (self.shopString.length == 0) {
        [WPProgressHUD showInfoWithStatus:@"请选择店铺照片"];
    }
    else {
        [self postShopInforData];
    }
}

#pragma mark - Data

- (void)postShopInforData
{
    NSDictionary *parameters = @{
                                 @"busilicenceNo" : [WPPublicTool base64EncodeString:self.busilicenceCell.textField.text],
                                 @"busilicenceImg" : self.busilicenceString,
                                 @"categoryId" : self.shopTypeString,
                                 @"shopDescription" : self.shopDescripTextView.text,
                                 @"shopCoverImg" : self.shopString
                                 };
    [self.shopInforDic addEntriesFromDictionary:parameters];

    __weakSelf
    [WPHelpTool postWithURL:WPSubmitShopCertURL parameters:self.shopInforDic success:^(id success) {
        
        NSString *type = [NSString stringWithFormat:@"%@", success[@"type"]];
        if ([type isEqualToString:@"1"]) {
            [WPProgressHUD showSuccessWithStatus:@"提交成功"];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
