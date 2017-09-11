//
//  WPShareTool.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/12.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPShareTool.h"
#import "SGQRCodeTool.h"

#import "OpenShareHeader.h"
#import <MessageUI/MessageUI.h>

#import "WPProgressHUD.h"

@implementation WPShareTool


+ (void)shareWithModel:(WPShareModel *)model appType:(NSString *)appType
{
    NSArray *typeArray = @[@"微信好友", @"微信朋友圈", @"QQ好友", @"QQ空间", @"Safari中打开", @"复制链接", @"二维码"];
    
    for (NSInteger i = 0 ; i < typeArray.count; i++)
    {
        if ([appType isEqualToString:typeArray[i]]) // 判断用户点击的app类型
        {
            switch (i)
            {
                case 0:  //微信好友
                    [self shareToWeiXinFriendWithModel:model];
                    break;
                    
                case 1:  //微信朋友圈
                    [self shareToWeiXinCircleWithModel:model];
                    break;
                    
                case 2:  //QQ好友
                    [self shareToQQFriendWithModel:model];
                    break;
                    
                case 3:  //QQ空间
                    [self shareToQQQzoneWithModel:model];
                    break;
                    
                case 4:  //Safari中打开
                    [self shareToSafariWithUrl:model.webpageUrl];
                    break;
                    
                case 5:  //复制链接
                    [self shareToCopyWithUrl:model.webpageUrl];
                    break;
                    
                default:
                    break;
            }
        }
    }
}


+ (OSMessage *)shareMessageWithModel:(WPShareModel *)model
{
    OSMessage *message = [[OSMessage alloc] init];
    message.title = model.title;
    message.desc = model.share_despt;
    message.image = UIImagePNGRepresentation([UIImage imageNamed:@"appImage"]);
    message.link = model.webpageUrl;
    return message;
}

+ (void)shareToWeiXinFriendWithModel:(WPShareModel *)model
{
    OSMessage *message = [self shareMessageWithModel:model];
    [OpenShare shareToWeixinSession:message Success:^(OSMessage *message) {
        //...
    } Fail:^(OSMessage *message, NSError *error) {
        //...
    }];
}

+ (void)shareToWeiXinCircleWithModel:(WPShareModel *)model
{
    OSMessage *message = [self shareMessageWithModel:model];
    [OpenShare shareToWeixinTimeline:message Success:^(OSMessage *message) {
        //...
    } Fail:^(OSMessage *message, NSError *error) {
        //...
    }];
}

+ (void)shareToQQFriendWithModel:(WPShareModel *)model
{
    OSMessage *message = [self shareMessageWithModel:model];
    [OpenShare shareToQQFriends:message Success:^(OSMessage *message) {
        //...
    } Fail:^(OSMessage *message, NSError *error) {
        //...
    }];
    
}

+ (void)shareToQQQzoneWithModel:(WPShareModel *)model
{
    OSMessage *message = [self shareMessageWithModel:model];
    [OpenShare shareToQQZone:message Success:^(OSMessage *message) {
        //...
    } Fail:^(OSMessage *message, NSError *error) {
        //...
    }];
}

+ (void)shareToSinaWithModel:(WPShareModel *)model
{

}

+ (void)shareToSafariWithUrl:(NSString *)url
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

+ (void)shareToCopyWithUrl:(NSString *)url
{
    UIPasteboard *pastedboard = [UIPasteboard generalPasteboard];
    pastedboard.string = url;
    [WPProgressHUD showInfoWithStatus:@"已复制到剪切板"];
}


@end
