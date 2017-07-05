//
//  WPUserInfor.m
//  WinShoppingMall
//
//  Created by 易购付 on 2017/3/28.
//  Copyright © 2017年 易购付. All rights reserved.
//

#import "WPUserInfor.h"

@implementation WPUserInfor

Single_Implementation(WPUserInfor)

- (void)updateUserInfor
{
    [WPUserInfor sharedWPUserInfor].clientId = self.clientId;
        
    [WPUserInfor sharedWPUserInfor].approvePassType = self.approvePassType;
    
    [WPUserInfor sharedWPUserInfor].payPasswordType = self.payPasswordType;
    
    [WPUserInfor sharedWPUserInfor].shopPassType = self.shopPassType;
    
    [WPUserInfor sharedWPUserInfor].userPhone = self.userPhone;
    
    [WPUserInfor sharedWPUserInfor].threeTouch = self.threeTouch;
    
    [WPUserInfor sharedWPUserInfor].userInfoDict = self.userInfoDict;
    
    [WPUserInfor sharedWPUserInfor].needTouchID = self.needTouchID;
        
    [WPUserInfor sharedWPUserInfor].registerTouchID = self.registerTouchID;
    
    [WPUserInfor sharedWPUserInfor].payTouchID = self.payTouchID;
        
    [WPUserInfor sharedWPUserInfor].isSubAccount = self.isSubAccount;
                
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    [userDefault setObject:self.clientId forKey:WPUserDefaultClientId];
    
    [userDefault setObject:self.approvePassType forKey:WPUserApprovePass];
    
    [userDefault setObject:self.payPasswordType forKey:WPUserHasPayPassword];
    
    [userDefault setObject:self.shopPassType forKey:WPUserShopPass];
    
    [userDefault setObject:self.userPhone forKey:WPUserPhone];
        
    [userDefault setObject:self.threeTouch forKey:@"threeTouch"];
    
    [userDefault setObject:self.userInfoDict forKey:@"userInfoDict"];
    
    [userDefault setObject:self.needTouchID forKey:WPNeedTouchID];
    
    [userDefault setObject:self.registerTouchID forKey:WPRegisterTouchID];
    
    [userDefault setObject:self.payTouchID forKey:WPPayTouchID];
            
    [userDefault setObject:self.isSubAccount forKey:WPIsSubAccount];
        
    [userDefault synchronize];
}


@end
