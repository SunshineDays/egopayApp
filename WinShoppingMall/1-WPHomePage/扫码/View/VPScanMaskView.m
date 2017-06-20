//
//  VPScanMaskView.m
//  qrCodeDemo
//
//  Created by vernepung on 15/11/16.
//  Copyright © 2015年 vernepung. All rights reserved.
//

#import "VPScanMaskView.h"
#import "VPScanLineView.h"

#define kTimerLength 2.0
@interface VPScanMaskView()
{
    CGFloat _width;
    VPScanLineView *_lineView;
}
@property (weak,nonatomic) NSTimer *lineTimer;
@end
@implementation VPScanMaskView
- (void)dealloc
{
}

- (instancetype)initWithFrame:(CGRect)frame scanViewWidth:(CGFloat)width
{
    self = [super initWithFrame:frame];
    if (self) {
        _width = width;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    _width = _width > 0 ? _width : 240;
    _maskWidth = _width;
    CGSize size = rect.size;
    CGFloat left = _maskLeft = (size.width - _width) / 2;
    CGFloat top = _maskTop = (size.height - _width) / 2;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, left, top);
    CGContextAddLineToPoint(context, left, top + _width);
    CGContextAddLineToPoint(context, left + _width, top + _width);
    CGContextAddLineToPoint(context, left + _width, top);
    CGContextAddLineToPoint(context, left, top);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, size.width, 0);
    CGContextAddLineToPoint(context, size.width, size.height);
    CGContextAddLineToPoint(context, 0, size.height);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0 green:0 blue:0 alpha:.3].CGColor);
    CGContextFillPath(context);
    
    context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, left, top);
    CGContextAddLineToPoint(context, left, top + _width);
    CGContextAddLineToPoint(context, left + _width, top + _width);
    CGContextAddLineToPoint(context, left + _width, top);
    CGContextAddLineToPoint(context, left, top);
    CGContextSetLineWidth(context, 1.0f / [UIScreen mainScreen].scale);
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    
    CGContextStrokePath(context);
    
    context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGPoint addLines[] =
    {
        CGPointMake(left + 11, top + 1),
        CGPointMake(left + 1, top + 1),
        CGPointMake(left + 1, top + 11),
        CGPointMake(left + 1, top + 1),
    };
    CGPoint addLines1[] =
    {
        CGPointMake(left + 1, top + _width - 11),
        CGPointMake(left + 1, top + _width - 1),
        CGPointMake(left + 11, top + _width - 1),
        CGPointMake(left + 1, top + _width - 1),
    };
    CGPoint addLines2[] =
    {
        CGPointMake(left + _width - 11, top + 1),
        CGPointMake(left + _width - 1, top + 1),
        CGPointMake(left + _width - 1, top + 11),
        CGPointMake(left + _width - 1, top + 1),
    };
    CGPoint addLines3[] =
    {
        CGPointMake(left + _width - 1, top + _width - 11),
        CGPointMake(left + _width - 1, top + _width - 1),
        CGPointMake(left + _width - 11, top + _width - 1),
        CGPointMake(left + _width - 1, top + _width - 1),
    };
    CGContextClosePath(context);
    CGContextAddLines(context, addLines, sizeof(addLines)/sizeof(addLines[0]));
    CGContextAddLines(context, addLines1, sizeof(addLines1)/sizeof(addLines1[0]));
    CGContextAddLines(context, addLines2, sizeof(addLines2)/sizeof(addLines2[0]));
    CGContextAddLines(context, addLines3, sizeof(addLines3)/sizeof(addLines3[0]));
    CGContextStrokePath(context);
    
    _lineView = [[VPScanLineView alloc] initWithFrame:CGRectMake(_maskLeft, _maskTop, _maskWidth, 3.0f / [UIScreen mainScreen].scale)];
    _lineView.backgroundColor = [UIColor clearColor];
    [self addSubview:_lineView];
    
    if (!_lineTimer)
    {
        _lineTimer = [NSTimer scheduledTimerWithTimeInterval:kTimerLength target:self selector:@selector(scanningAnimation) userInfo:NULL repeats:YES];
        [_lineTimer fire];
    }
}

- (void)stopAnimation
{
    _lineView.hidden = YES;
    [_lineView removeFromSuperview];
    [_lineTimer invalidate];
}

- (void)scanningAnimation
{
     CGRect rect = _lineView.frame;
     rect.origin.y =  _maskTop;
     _lineView.frame = rect;
     
     rect.origin.y = _maskTop + _width - rect.size.height;
     [UIView beginAnimations:nil context:nil];
     [UIView setAnimationDuration:kTimerLength];
     _lineView.frame = rect;
     [UIView commitAnimations];
}



@end
