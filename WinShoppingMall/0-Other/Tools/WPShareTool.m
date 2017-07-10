//
//  WPShareTool.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/6/12.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPShareTool.h"
#import "UMSocialQQHandler.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "SGQRCodeTool.h"
#import "WXApi.h"
#import "WPProgressHUD.h"

@implementation WPShareTool


- (void)shareWithUrl:(NSString *)url title:(NSString *)title description:(NSString *)description appType:(NSString *)appType
{
    for (NSInteger i = 0 ; i < [[WPUserTool shareWayArray] count]; i++) {
        if ([appType isEqualToString:[WPUserTool shareWayArray][i]]) {
            [self shareWayWithUrl:url title:title description:description shareType:i];
        }
    }
}

- (void)shareWayWithUrl:(NSString *)url title:(NSString *)title description:(NSString *)description shareType:(NSInteger)shareType
{
    switch (shareType) {
        case 0:  //微信好友
            [self shareToWeiXinWithUrl:url title:title description:description shareType:0];
            break;
            
        case 1:  //微信朋友圈
            [self shareToWeiXinWithUrl:url title:title description:description shareType:1];
            break;
            
        case 2:  //QQ好友
            [self shareToQQWithUrl:url title:title description:description shareType:0];
            break;
            
        case 3:  //QQ空间
            [self shareToQQWithUrl:url title:title description:description shareType:1];
            break;
            
        case 4:  //Safari中打开
            [self shareToSafariWithUrl:url];
            break;
            
        case 5:  //复制链接
            [self shareToCopyWithUrl:url];
            break;
            
        default:
            break;
    }
}


- (void)shareToWeiXinWithUrl:(NSString *)url title:(NSString *)title description:(NSString *)description shareType:(int)shareType {
    if ([WXApi isWXAppInstalled]) {
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;
        sendReq.scene = shareType;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = title;
        urlMessage.description = description;
        [urlMessage setThumbImage:[UIImage imageNamed:@"share_wintopay"]];

        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = url;
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;

        [WXApi sendReq:sendReq];
    }
    else {
        [WPProgressHUD showInfoWithStatus:@"您还没有安装微信"];
    }
}

- (void)shareToQQWithUrl:(NSString *)url title:(NSString *)title description:(NSString *)description shareType:(int)shareType {
    if ([TencentOAuth iphoneQQInstalled]) {
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description:description previewImageURL:nil];
        switch (shareType) {
            case 0: {
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
                [QQApiInterface sendReq:req];
            }
                break;
                
            case 1: {
                [newsObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
                SendMessageToQQReq *rep = [SendMessageToQQReq reqWithContent:newsObj];
                [QQApiInterface SendReqToQZone:rep];
            }
                break;
                
            default:
                break;
        }
    }
    else {
        [WPProgressHUD showInfoWithStatus:@"您还没有安装QQ"];
    }
}

- (void)shareToSinaWithUrl:(NSString *)url title:(NSString *)title description:(NSString *)description {
    
}

- (void)shareToSafariWithUrl:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)shareToCopyWithUrl:(NSString *)url {
    UIPasteboard *pastedboard = [UIPasteboard generalPasteboard];
    pastedboard.string = url;
    [WPProgressHUD showInfoWithStatus:@"已复制到剪切板"];
}


@end
