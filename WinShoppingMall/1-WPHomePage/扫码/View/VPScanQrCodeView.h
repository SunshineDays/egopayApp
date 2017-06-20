//
//  VPScanQrCodeView.h
//  qrCodeDemo
//
//  Created by vernepung on 15/11/16.
//  Copyright © 2015年 vernepung. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol VPScanQrCodeViewDelegate;

@interface VPScanQrCodeView : UIView

@property (weak,nonatomic) id<VPScanQrCodeViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andMaskViewWidth:(CGFloat)width andBorderColor:(UIColor *)color;

@end


@protocol VPScanQrCodeViewDelegate <NSObject>

- (void)vpScanQrCodeCompletedWithResult:(NSString *)result;

@end