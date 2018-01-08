//
//  FMLoginRegisterViewController.h
//  FishingMan
//
//  Created by zhangxh on 2017/5/4.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FMLoginRegisterViewMode){
    
    FMLoginRegisterViewMode_PhoneNumCheck = 0,     //手机号码校验
    FMLoginRegisterViewMode_LoginWithPWD = 1,      //登录使用登录密码
    FMLoginRegisterViewMode_Register = 2,          //注册
    FMLoginRegisterViewMode_Forget = 3,            //忘记登录密码
};

@interface FMLoginRegisterViewController : UIViewController

@property (assign, nonatomic) FMLoginRegisterViewMode loginRegisterViewMode;

@end
