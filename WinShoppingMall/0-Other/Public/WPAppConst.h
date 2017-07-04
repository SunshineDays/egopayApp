#import <UIKit/UIKit.h>

/********************************  UI相关常量  ************************************/
#pragma mark - UI相关常量

/** 导航控制器的高度 */
UIKIT_EXTERN CGFloat const WPNavigationHeight;

/** 控件的左边间距 */
UIKIT_EXTERN CGFloat const WPLeftMargin;

/** 输入框的左边间距 */
UIKIT_EXTERN CGFloat const WPLeftMarginField;

/** 控件的上边间距 */
UIKIT_EXTERN CGFloat const WPTopMargin;

/** 行高 */
UIKIT_EXTERN CGFloat const WPRowHeight;

/** 圆角大小 */
UIKIT_EXTERN CGFloat const WPCornerRadius;

/** 分割线的高度 */
UIKIT_EXTERN CGFloat const WPLineHeight;

/** 底部按钮的高度 */
UIKIT_EXTERN CGFloat const WPButtonHeight;

/** 默认文字大小 */
UIKIT_EXTERN CGFloat const WPFontDefaultSize;


/********************************  App常量 ************************************/
#pragma mark - App常量

/** 获取验证码时间周期 */
UIKIT_EXTERN NSTimeInterval const getVerificationCodeTime;

/** 电话号码 */
UIKIT_EXTERN NSString * const WPAppTelNumber;


/********************************  通知  ************************************/
#pragma mark - 通知

UIKIT_EXTERN NSString * const WPNotificationPayPasswordImportEnd;

UIKIT_EXTERN NSString * const WPNotificationChangeUserInfor;

UIKIT_EXTERN NSString * const WPNotificationAddCardSuccess;

UIKIT_EXTERN NSString * const WPNotificationReceiveSuccess;

UIKIT_EXTERN NSString * const WPNotificationSubAccountAddSuccess;

UIKIT_EXTERN NSString * const WPNotificationUserLogout;


/******************************  静态参数  ***********************************/
#pragma mark - 静态参数

UIKIT_EXTERN NSString * const WPUserDefaultClientId;

UIKIT_EXTERN NSString * const WPUserDefaultCardId;

UIKIT_EXTERN NSString * const WPUserHasPayPassword;

UIKIT_EXTERN NSString * const WPUserApprovePass;

UIKIT_EXTERN NSString * const WPUserShopPass;

UIKIT_EXTERN NSString * const WPUserPhone;

UIKIT_EXTERN NSString * const WPCodeUrl;

UIKIT_EXTERN NSString * const WPNeedTouchID;

UIKIT_EXTERN NSString * const WPIsSubAccount;

UIKIT_EXTERN NSString * const kUserPayPassword;

UIKIT_EXTERN NSString * const kUserPhone;

UIKIT_EXTERN NSString * const kUserPayPassword_Phone;



/******************************* 统一的URL **********************************/
#pragma mark - 统一的URL

/*** baseURL ***/
UIKIT_EXTERN NSString * const WPBaseURL;

/*** H5 ***/

UIKIT_EXTERN NSString * const WPUserProtocolWebURL;

UIKIT_EXTERN NSString * const WPAboutOurWebURL;

UIKIT_EXTERN NSString * const WPUserHelpWebURL;

UIKIT_EXTERN NSString * const WPDelegateAgentWebURL;

UIKIT_EXTERN NSString * const WPTouchIDWebURL;

/***/

UIKIT_EXTERN NSString * const WPRegisterURL;

UIKIT_EXTERN NSString * const WPGetMessageURL;

UIKIT_EXTERN NSString * const WPConfirmEnrollURL;

UIKIT_EXTERN NSString * const WPRechargeURL;

UIKIT_EXTERN NSString * const WPUserApproveIDCardURL;

UIKIT_EXTERN NSString * const WPUserApproveIDCardPhotoURL;

UIKIT_EXTERN NSString * const WPUserApproveBankCardPhotoURL;

UIKIT_EXTERN NSString * const WPUserApproveIDCardPassURL;

UIKIT_EXTERN NSString * const WPUserAddCardURL;

UIKIT_EXTERN NSString * const WPUserDeleteCardURL;

UIKIT_EXTERN NSString * const WPChangePasswordURL;

UIKIT_EXTERN NSString * const WPSetPayPasswordURL;

UIKIT_EXTERN NSString * const WPAddTouchIDPayPasswordURL;

UIKIT_EXTERN NSString * const WPUserLogoutURL;

UIKIT_EXTERN NSString * const WPUserBanCardURL;

UIKIT_EXTERN NSString * const WPUserHasCardURL;

UIKIT_EXTERN NSString * const WPUserInforURL;

UIKIT_EXTERN NSString * const WPUserChangeAvatarURL;

UIKIT_EXTERN NSString * const WPUserChangeInforURL;

UIKIT_EXTERN NSString * const WPTransferAccountsURL;

UIKIT_EXTERN NSString * const WPWithdrawURL;

UIKIT_EXTERN NSString * const WPProfitWithdrawURL;

UIKIT_EXTERN NSString * const WPBillURL;

UIKIT_EXTERN NSString * const WPCheckBillURL;

UIKIT_EXTERN NSString * const WPDelegateURL;

UIKIT_EXTERN NSString * const WPProfitDetailURL;

UIKIT_EXTERN NSString * const WPMerchantGradeURL;

UIKIT_EXTERN NSString * const WPDelegateGradeURL;

UIKIT_EXTERN NSString * const WPGatheringCodeURL;

UIKIT_EXTERN NSString * const WPBankListURL;

UIKIT_EXTERN NSString * const WPCreditChargeURL;

UIKIT_EXTERN NSString * const WPCycleScrollURL;

UIKIT_EXTERN NSString * const WPGetCategoryURL;

UIKIT_EXTERN NSString * const WPSubmitShopCertURL;

UIKIT_EXTERN NSString * const WPQueryShopStatusURL;

UIKIT_EXTERN NSString * const WPShowMerShopsURL;

UIKIT_EXTERN NSString * const WPMerShopDetailURL;

UIKIT_EXTERN NSString * const WPMessageURL;

UIKIT_EXTERN NSString * const WPCityListURL;

UIKIT_EXTERN NSString * const WPShowAgUpgradeURL;

UIKIT_EXTERN NSString * const WPShowMerUpgradeURL;

UIKIT_EXTERN NSString * const WPTodayQrIncomeURL;

UIKIT_EXTERN NSString * const WPMyRefersURL;

UIKIT_EXTERN NSString * const WPUserFeedBackURL;

UIKIT_EXTERN NSString * const WPUserToReportURL;

UIKIT_EXTERN NSString * const WPShareToAppURL;

UIKIT_EXTERN NSString * const WPPoundageURL;

UIKIT_EXTERN NSString * const WPBillNotificationURL;

UIKIT_EXTERN NSString * const WPSubAccountInforURL;

UIKIT_EXTERN NSString * const WPSubAccountListURL;

UIKIT_EXTERN NSString * const WPSubAccountAddURL;

UIKIT_EXTERN NSString * const WPSubAccountSettingURL;

UIKIT_EXTERN NSString * const WPSubAccountJurisdictionURL;

UIKIT_EXTERN NSString * const WPSubAccountDeleteURL;

UIKIT_EXTERN NSString * const WPSubAccountAvatarURL;

UIKIT_EXTERN NSString * const WPSubAccountChangePasswordURL;
