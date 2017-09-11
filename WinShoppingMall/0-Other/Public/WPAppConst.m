#import <UIKit/UIKit.h>


/********************************  UI相关常量  ************************************/
#pragma mark - UI相关常量

CGFloat const WPNavigationHeight = 64;  //导航栏高低

CGFloat const WPLeftMargin = 15;  //控件距屏幕左边的距离

CGFloat const WPLeftMarginField = WPLeftMargin + 90;  

CGFloat const WPTopY = 0;  //当navigationBar.translucent = NO时，（0，0）为（64， 0）

CGFloat const WPTopMargin = WPTopY + 10;

CGFloat const WPRowHeight = 50;  //行高

CGFloat const WPCornerRadius = 6;  //圆角

CGFloat const WPLineHeight = 0.5f;  //分割线高度

CGFloat const WPButtonHeight = 40;  //按钮高度

CGFloat const WPFontDefaultSize = 15;  //默认文字大小



/********************************  App常量 ************************************/
#pragma mark - App常量

/** 获取验证码时间 */
NSTimeInterval const getVerificationCodeTime = 120;

/** 电话号码 */
NSString * const WPAppTelNumber = @"400-8536696";



/********************************  静态参数 ************************************/
#pragma mark - 静态参数

//  Client ID
NSString * const WPUserDefaultClientId = @"WPUserDefaultClientId";

//  默认银行卡
NSString * const WPUserDefaultCardId = @"WPUserDefaultCardId";

//  是否设置支付密码
NSString * const WPUserHasPayPassword = @"WPUserHasPayPassword";

//  是否通过实名认证
NSString * const WPUserApprovePass = @"WPUserApprovePass";

//  是否通过商家认证
NSString * const WPUserShopPass = @"WPUserShopPass";

//  登录电话号码／子账户ID
NSString * const WPUserPhone = @"WPUserPhone";

//  是否使用指纹登录
NSString * const WPRegisterTouchID = @"WPRegisterTouchID";

//  是否使用指纹支付
NSString * const WPPayTouchID = @"WPPayTouchID";

//  提醒用户开通指纹支付
NSString * const WPIsRemindTouchID = @"WPIsRemindTouchID";

//  判断是否是子账户
NSString * const WPIsSubAccount = @"WPIsSubAccount";

//  保存到钥匙串
NSString * const kUserPayPassword = @"com.wintopay.ios.userpaypassword";

NSString * const kUserPayPassword_Infor = @"com.wintopay.ios.userpaypasswordInfor";



/********************************  通知 ************************************/
#pragma mark - 通知

//  修改头像／个人信息成功
NSString * const WPNotificationChangeUserInfor = @"WPNotificationChangeUserInfor";

//  添加银行卡成功
NSString * const WPNotificationAddCardSuccess = @"WPNotificationAddCardSuccess";

//  推送信息
NSString * const WPNotificationReceiveSuccess = @"WPNotificationReceiveSuccess";

//  添加子账户成功
NSString * const WPNotificationSubAccountAddSuccess = @"WPNotificationSubAccountAddSuccess";

//  用户掉线重新登录
NSString * const WPNotificationUserLogout = @"WPNotificationUserLogout";




/********************************  URL ************************************/
#pragma mark - URL

NSString * const WPBaseURL = @"http://www.egoopay.com";

//NSString * const WPBaseURL = @"http://192.168.1.39:8080";

/***  H5 ***/

//  用户协议
NSString * const WPUserProtocolWebURL = @"html/agreement.html";

//  关于我们
NSString * const WPAboutOurWebURL = @"html/about/about.html";

//  用户帮助
NSString * const WPUserHelpWebURL = @"html/help.html";

//  代理协议
NSString * const WPDelegateProtocolWebURL = @"html/protocol.html";

//  代理介绍
NSString * const WPDelegateAgentWebURL = @"html/agent.html";

//  指纹登录／支付协议
NSString * const WPTouchIDWebURL = @"html/touchid.html";

/*****************/

//  登录
NSString * const WPRegisterURL = @"client_login";

//  注册
NSString * const WPConfirmEnrollURL = @"client_regedit";

//  用户退出登录
NSString * const WPUserLogoutURL = @"client_logout";

//  获取验证码
NSString * const WPGetMessageURL = @"client_ver";

//  充值费率
NSString * const WPPoundageURL = @"client_getTransRate";

//  充值
NSString * const WPRechargeURL = @"client_rechargeAction";

//  国际信用卡充值
NSString * const WPCreditChargeURL = @"client_creditPay";

//  转账
NSString * const WPTransferAccountsURL = @"client_p2p_transfer";

//  提现
NSString * const WPWithdrawURL = @"client_extractCashApplyAction";

//  分润余额提现
NSString * const WPProfitWithdrawURL = @"client_agExtraCash";

//  红包
NSString * const WPRedPacketURL = @"client_reward";

//  提交身份证信息
NSString * const WPUserApproveIDCardURL = @"client_authenticateA";

//  提交身份证照片认证
NSString * const WPUserApproveIDCardPhotoURL = @"client_authenticateB";

//  获取身份证审核信息
NSString * const WPUserApproveIDCardPassURL = @"client_authenticate_detailAction";

//  提交银行卡照片认证
NSString * const WPUserApproveBankCardPhotoURL = @"client_cardPicAction";

//  提交商家认证信息
NSString * const WPSubmitShopCertURL = @"client_submitShopCert";

//  获取商家认证状态
NSString * const WPQueryShopStatusURL = @"client_queryShopStatus";

//  用户银行卡信息
NSString * const WPUserBanKCardURL = @"client_merCard";

//  添加银行卡
NSString * const WPUserAddCardURL = @"client_bandBankCardAction";

//  删除银行卡
NSString * const WPUserDeleteCardURL = @"client_delCard";

//  修改密码
NSString * const WPChangePasswordURL = @"client_changePassword";

//  设置支付密码
NSString * const WPSetPayPasswordURL = @"client_setuppayPasswordAction";

//  判断支付密码是否正确
NSString * const WPAddTouchIDPayPasswordURL = @"client_checkPayPwd";

//  判断用户是否设置支付密码／通过实名认证
NSString * const WPUserJudgeInforURL = @"client_issetpwdAction";

//  获取用户信息
NSString * const WPUserInforURL = @"client_detailedInfo";

//  修改用户头像
NSString * const WPUserChangeAvatarURL = @"client_uploadHead";

//  修改用户信息
NSString * const WPUserChangeInforURL = @"client_saveDetailInfo";

//  账单
NSString * const WPBillURL = @"client_queryTradeDetail";

//  账单消息
NSString * const WPBillNotificationURL = @"client_pushedInfos";

//  对账／二维码账单
NSString * const WPCheckBillURL = @"client_qrCheckBill";

//  代理信息
NSString * const WPAgencyURL = @"client_agent_home";

//  分润明细
NSString * const WPProfitDetailURL = @"client_beneDetails";

//  获取代理产品
NSString * const WPShowAgUpgradeURL = @"client_showAgUpgrade";

//  获取会员产品
NSString * const WPShowMerUpgradeURL = @"client_showMerUpgrade";

//  会员升级
NSString * const WPMerchantGradeURL = @"client_upUserlvAction";

//  代理升级
NSString * const WPAgencyGradeURL = @"client_upagentLvAction";

//  收款码
NSString * const WPGatheringCodeURL = @"client_createPayQr";

//  消息信息
NSString * const WPMessageURL = @"client_pullSysMsg";

//  今日收入
NSString * const WPTodayQrIncomeURL = @"client_todayQrIncome";

//  邀请的人
NSString * const WPMyRefersURL = @"client_myRefers";

//  银行列表
NSString * const WPBankListURL = @"client_getBanks";

//  城市列表
NSString * const WPCityListURL = @"client_getCities";

//  类别列表
NSString * const WPGetCategoryURL = @"client_getCategory";

//  轮播图
NSString * const WPCycleScrollURL = @"client_getBanner";

//  商家搜索
NSString * const WPShowMerShopsURL = @"client_showMerShops";

//  商家详情
NSString * const WPMerShopDetailURL = @"client_shopInfos";

//  用户反馈
NSString * const WPUserFeedBackURL = @"client_feedback";

//  用户举报
NSString * const WPUserToReportURL = @"client_usreport";

//  分享内容链接
NSString * const WPShareToAppURL = @"client_share";

//  子账户信息
NSString * const WPSubAccountInforURL = @"client_getClerkInfo";

//  子账户列表
NSString * const WPSubAccountListURL = @"client_clerkList";

//  添加子账户
NSString * const WPSubAccountAddURL = @"client_createClerk";

//  设置子账户权限
NSString * const WPSubAccountSettingURL = @"client_assignPerms";

//  获取子账户权限信息
NSString * const WPSubAccountJurisdictionURL = @"client_getClerkPerm";

//  删除子账户
NSString * const WPSubAccountDeleteURL = @"client_deleteClerk";

//  修改子账户头像
NSString * const WPSubAccountAvatarURL = @"client_uploadClerkImg";

//  修改子账户密码
NSString * const WPSubAccountChangePasswordURL = @"client_retClerkPwd";

