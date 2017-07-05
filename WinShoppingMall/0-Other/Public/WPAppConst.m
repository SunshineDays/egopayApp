#import <UIKit/UIKit.h>


/********************************  UI相关常量  ************************************/
#pragma mark - UI相关常量

CGFloat const WPNavigationHeight = 64;  //导航栏高低

CGFloat const WPLeftMargin = 17.5;  //控件距屏幕左边的距离

CGFloat const WPLeftMarginField = WPLeftMargin + 90;  

CGFloat const WPTopMargin = WPNavigationHeight + 10;

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

/********************************  通知 ************************************/
#pragma mark - 通知

NSString * const WPNotificationPayPasswordImportEnd = @"WPNotificationPayPasswordImportEnd";

NSString * const WPNotificationChangeUserInfor = @"WPNotificationChangeUserInfor";

NSString * const WPNotificationAddCardSuccess = @"WPNotificationAddCardSuccess";

NSString * const WPNotificationReceiveSuccess = @"WPNotificationReceiveSuccess";

NSString * const WPNotificationSubAccountAddSuccess = @"WPNotificationSubAccountAddSuccess";

NSString * const WPNotificationUserLogout = @"WPNotificationUserLogout";

/********************************  静态参数 ************************************/
#pragma mark - 静态参数

NSString * const WPUserDefaultClientId = @"WPUserDefaultClientId";

NSString * const WPUserDefaultCardId = @"WPUserDefaultCardId";

NSString * const WPUserHasPayPassword = @"WPUserHasPayPassword";

NSString * const WPUserApprovePass = @"WPUserApprovePass";

NSString * const WPUserShopPass = @"WPUserShopPass";

NSString * const WPUserPhone = @"WPUserPhone";

NSString * const WPCodeUrl = @"WPCodeUrl";

NSString * const WPNeedTouchID = @"WPNeedTouchID";

NSString * const WPRegisterTouchID = @"WPRegisterTouchID";

NSString * const WPPayTouchID = @"WPPayTouchID";

NSString * const WPIsSubAccount = @"WPIsSubAccount";

NSString * const kUserPayPassword = @"com.wintopay.ios.userpaypassword";

NSString * const kUserPhone = @"com.wintopay.ios.userphone";

NSString * const kUserPayPassword_Phone = @"com.wintopay.ios.userpaypasswordphone";



/********************************  统一的URL ************************************/
#pragma mark - 统一的URL

NSString * const WPBaseURL = @"http://www.egoopay.com";

//NSString * const WPBaseURL = @"http://192.168.1.21:8080";

/*** H5 ***/

NSString * const WPUserProtocolWebURL = @"html/agreement.html";

NSString * const WPAboutOurWebURL = @"html/about/about.html";

NSString * const WPUserHelpWebURL = @"html/help.html";

NSString * const WPDelegateAgentWebURL = @"html/agent.html";

NSString * const WPTouchIDWebURL = @"html/touchid.html";

/***/

NSString * const WPRegisterURL = @"client_login";

NSString * const WPGetMessageURL = @"client_ver";

NSString * const WPConfirmEnrollURL = @"client_regedit";

NSString * const WPRechargeURL = @"client_rechargeAction";

NSString * const WPUserApproveIDCardURL = @"client_authenticateA";

NSString * const WPUserApproveIDCardPhotoURL = @"client_authenticateB";

NSString * const WPUserApproveIDCardPassURL = @"client_authenticate_detailAction";

NSString * const WPUserApproveBankCardPhotoURL = @"client_cardPicAction";

NSString * const WPUserAddCardURL = @"client_bandBankCardAction";

NSString * const WPUserDeleteCardURL = @"client_delCard";

NSString * const WPChangePasswordURL = @"client_changePassword";

NSString * const WPSetPayPasswordURL = @"client_setuppayPasswordAction";

NSString * const WPAddTouchIDPayPasswordURL = @"client_checkPayPwd";

NSString * const WPUserLogoutURL = @"client_logout";

NSString * const WPUserBanCardURL = @"client_merCard";

NSString * const WPUserHasCardURL = @"client_issetpwdAction";

NSString * const WPUserInforURL = @"client_detailedInfo";

NSString * const WPUserChangeAvatarURL = @"client_uploadHead";

NSString * const WPUserChangeInforURL = @"client_saveDetailInfo";

NSString * const WPTransferAccountsURL = @"client_p2p_transfer";

NSString * const WPWithdrawURL = @"client_extractCashApplyAction";

NSString * const WPProfitWithdrawURL = @"client_agExtraCash";

NSString * const WPBillURL = @"client_queryTradeDetail";

NSString * const WPCheckBillURL = @"client_qrCheckBill";

NSString * const WPDelegateURL = @"client_agent_home";

NSString * const WPProfitDetailURL = @"client_beneDetails";

NSString * const WPMerchantGradeURL = @"client_upUserlvAction";

NSString * const WPDelegateGradeURL = @"client_upagentLvAction";

NSString * const WPGatheringCodeURL = @"client_createPayQr";

NSString * const WPBankListURL = @"client_getBanks";

NSString * const WPCreditChargeURL = @"client_creditPay";

NSString * const WPCycleScrollURL = @"client_getBanner";

NSString * const WPGetCategoryURL = @"client_getCategory";

NSString * const WPSubmitShopCertURL = @"client_submitShopCert";

NSString * const WPQueryShopStatusURL = @"client_queryShopStatus";

NSString * const WPShowMerShopsURL = @"client_showMerShops";

NSString * const WPMerShopDetailURL = @"client_shopInfos";

NSString * const WPMessageURL = @"client_pullSysMsg";

NSString * const WPCityListURL = @"client_getCities";

NSString * const WPShowAgUpgradeURL = @"client_showAgUpgrade";

NSString * const WPShowMerUpgradeURL = @"client_showMerUpgrade";

NSString * const WPTodayQrIncomeURL = @"client_todayQrIncome";

NSString * const WPMyRefersURL = @"client_myRefers";

NSString * const WPUserFeedBackURL = @"client_feedback";

NSString * const WPUserToReportURL = @"client_usreport";

NSString * const WPShareToAppURL = @"client_share";

NSString * const WPPoundageURL = @"client_getTransRate";

NSString * const WPBillNotificationURL = @"client_pushedInfos";

NSString * const WPSubAccountInforURL = @"client_getClerkInfo";

NSString * const WPSubAccountListURL = @"client_clerkList";

NSString * const WPSubAccountAddURL = @"client_createClerk";

NSString * const WPSubAccountSettingURL = @"client_assignPerms";

NSString * const WPSubAccountJurisdictionURL = @"client_getClerkPerm";

NSString * const WPSubAccountDeleteURL = @"client_deleteClerk";

NSString * const WPSubAccountAvatarURL = @"client_uploadClerkImg";

NSString * const WPSubAccountChangePasswordURL = @"client_retClerkPwd";

