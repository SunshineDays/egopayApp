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
#import <UMengSocial/WXApi.h>
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
                    [self shareToWeChatWithModel:model shareType:0];
                    break;
                    
                case 1:  //微信朋友圈
                    [self shareToWeChatWithModel:model shareType:1];
                    break;
                    
                case 2:  //QQ好友
                    [self shareToQQWithModel:model shareType:0];
                    break;
                    
                case 3:  //QQ空间
                    [self shareToQQWithModel:model shareType:1];
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

+ (void)shareToWeChatWithModel:(WPShareModel *)model shareType:(int)shareType
{
    if ([WXApi isWXAppInstalled])
    {
        SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
        sendReq.bText = NO;
        sendReq.scene = shareType;//0 = 好友列表 1 = 朋友圈 2 = 收藏
        WXMediaMessage *urlMessage = [WXMediaMessage message];
        urlMessage.title = model.title;
        urlMessage.description = model.share_despt;
        [urlMessage setThumbImage:[UIImage imageNamed:@"share_wintopay"]];
        
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = model.webpageUrl;
        urlMessage.mediaObject = webObj;
        sendReq.message = urlMessage;
        
        [WXApi sendReq:sendReq];
    }
    else
    {
        [WPProgressHUD showInfoWithStatus:@"您还没有安装微信"];
    }
}

+ (void)shareToQQWithModel:(WPShareModel *)model shareType:(int)shareType
{
    if ([TencentOAuth iphoneQQInstalled])
    {
        QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:model.webpageUrl] title:model.title description:model.share_despt previewImageURL:nil];
        switch (shareType)
        {
            case 0:  //QQ
            {
                SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
                [QQApiInterface sendReq:req];
                break;
            }
                
            case 1:  //QQ空间
            {
                [newsObj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
                SendMessageToQQReq *rep = [SendMessageToQQReq reqWithContent:newsObj];
                [QQApiInterface SendReqToQZone:rep];
                break;
            }
                
            default:
                break;
        }
    }
    else
    {
        [WPProgressHUD showInfoWithStatus:@"您还没有安装QQ"];
    }
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
