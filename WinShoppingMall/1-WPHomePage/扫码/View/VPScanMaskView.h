//
//  VPScanMaskView.h
//  qrCodeDemo
//
//  Created by vernepung on 15/11/16.
//  Copyright © 2015年 vernepung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VPScanMaskView : UIView
@property (assign,nonatomic,readonly) CGFloat maskLeft;
@property (assign,nonatomic,readonly) CGFloat maskTop;
@property (assign,nonatomic,readonly) CGFloat maskWidth;
@property (copy,nonatomic) UIColor* borderColor;
- (instancetype)initWithFrame:(CGRect)frame scanViewWidth:(CGFloat)width;
- (void)stopAnimation;
@end
