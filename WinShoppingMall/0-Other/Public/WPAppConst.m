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





