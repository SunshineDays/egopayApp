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
    if ([appType isEqualToString:@"微信好友"]) {
        [self shareToWeiXinWithUrl:url title:title description:description shareType:0];
    }
    else if ([appType isEqualToString:@"微信朋友圈"]) {
        [self shareToWeiXinWithUrl:url title:title description:description shareType:1];
    }
    else if ([appType isEqualToString:@"QQ好友"]) {
        [self shareToQQWithUrl:url title:title description:description shareType:0];
    }
    else if ([appType isEqualToString:@"QQ空间"]) {
        [self shareToQQWithUrl:url title:title description:description shareType:1];
    }
    else if ([appType isEqualToString:@"新浪微博"]) {
        [self shareToSinaWithUrl:url title:title description:description];
    }
    else if ([appType isEqualToString:@"Safari中打开"]) {
        [self shareToSafariWithUrl:url];
    }
    else if ([appType isEqualToString:@"复制链接"]) {
        [self shareToCopyWithUrl:url];
    }
}


- (void)shareToWeiXinWithUrl:(NSString *)url title:(NSString *)title description:(NSString *)description shareType:(int)shareType {
    if ([WXApi isWXAppInstalled]) {
        //创建发送对象实例
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;//不使用文本信息
        sendReq.scene = shareType;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        //创建分享内容对象
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = title;//分享标题
        urlMessage.description = description;//分享描述
        [urlMessage setThumbImage:[UIImage imageNamed:@"share_wintopay"]];//分享图片
        //创建多媒体对象
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = url;//分享链接
        //完成发送对象实例
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        //发送分享信息
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
