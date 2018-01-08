//
//  FMLoginUser.m
//  FishingMan
//
//  Created by zhangxh on 2017/7/18.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMLoginUser.h"
#import "FMLoginRegisterViewController.h"

@implementation FMLoginUser

MJExtensionCodingImplementation

- (id)init{
    self = [super init];
    if (self) {
        
        _userId = @"";
        _point = @"";
        _tel = @"";
        
        _address = @"";
        _avatarUrl = @"";
        _nickName = @"";
        _orderFieldNextType = @"";
        _sex = 0;
    }
    return self;
}

//转换id的名称
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"userId":@"id"};
}

//缓存用户基本信息
+ (void)setCacheUserInfo:(FMLoginUser *)user{
    
    if([ZXHTool isNilNullObject:user]){
        return;
    }
    
    NSData * userObject = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:userObject forKey:@"FMLoginUserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//读取用户登录信息
+ (FMLoginUser *)getCacheUserInfo{
    
    NSData * userObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"FMLoginUserInfo"];
    FMLoginUser * user = [NSKeyedUnarchiver unarchiveObjectWithData:userObject];
    
    if([ZXHTool isNilNullObject:user]){
        return nil;
    }
    return user;
}

//清除缓存
+ (void)removeCacheUserInfo{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FMLoginUserInfo"];
}
//但存判断是否处于登录状态
+ (BOOL)isLogin{
    
    FMLoginUser * loginUser = [FMLoginUser getCacheUserInfo];
    if(loginUser != nil) {
        return YES;
    }
    else{
        return NO;
    }
}
//判断是否处于登录状态,并提示用户，要求重新登录
+ (BOOL)isLoginAndAlert{
    
    FMLoginUser * loginUser = [FMLoginUser getCacheUserInfo];
    if(loginUser != nil) {
        return YES;
    }
    else{
        
        [ZXHViewTool addAlertWithTitle:@"温馨提示"
                               message:@"请重新登录！"
                           withTartget:[[[UIApplication sharedApplication] keyWindow] rootViewController]
                       leftActionStyle:UIAlertActionStyleDefault
                      rightActionStyle:UIAlertActionStyleDestructive
                     leftActionHandler:^(UIAlertAction *action) {
                         CLog(@"登录取消");
                     }
                    rightActionHandler:^(UIAlertAction *action) {
                        CLog(@"登录确定，自动调用登录界面");
                        
                        FMLoginRegisterViewController * loginVC = [[FMLoginRegisterViewController alloc] initWithNibName:@"FMLoginRegisterViewController" bundle:nil];
                        loginVC.loginRegisterViewMode = FMLoginRegisterViewMode_PhoneNumCheck;
                        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:loginVC animated:YES completion:^{
                        }];
                    }];
        
        return NO;
    }
}
+ (BOOL)isLoginWithoutAlert{
    
    FMLoginUser * loginUser = [FMLoginUser getCacheUserInfo];
    if(loginUser != nil) {
        return YES;
    }
    else{
        FMLoginRegisterViewController * loginVC = [[FMLoginRegisterViewController alloc] initWithNibName:@"FMLoginRegisterViewController" bundle:nil];
        loginVC.loginRegisterViewMode = FMLoginRegisterViewMode_PhoneNumCheck;
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:loginVC animated:YES completion:^{
        }];
        return NO;
    }
}

#pragma mark 参数值的转换方法
//性别转换：如0->男
+ (NSString *)sexConverter:(int)sexType{
    
    NSString * sexStr = @"男";
    switch (sexType) {
        case 0:
            sexStr = @"男";
            break;
        case 1:
            sexStr = @"女";
            break;
        case 2:
            sexStr = @"保密";
            break;
        default:
            break;
    }
    return sexStr;
}
//生日转换：如128312736127->1983-12-24
+ (NSString *)birthdayConverter:(long)timeStamp{
    
    NSDate * date = [[NSDate alloc] initWithTimeIntervalSince1970:timeStamp / 1000];
//    NSDate * date = [NSDate dateWithTimeIntervalSince1970: timeStamp / 1000];
    NSString * dateStr = [ZXHTool dateStringFromDate:date];
    return dateStr;
}

+ (NSString *)levelConvertFromType:(int)levelType{
    
    NSString * levelName = @"小仙";
    switch (levelType) {
        case 0:
            levelName = @"小仙";
            break;
        case 1:
            levelName = @"大仙";
            break;
        case 2:
            levelName = @"天尊";
            break;
        case 3:
            levelName = @"玉皇大帝";
            break;
        default:
            break;
    }
    
    return levelName;
}

+ (NSString *)sexNameConvertFromType:(int)sexType{
    NSString * sexName = @"男";
    switch (sexType) {
        case 0:
            sexName = @"男";
            break;
        case 1:
            sexName = @"女";
            break;
        case 3:
            sexName = @"保密";
            break;
        default:
            break;
    }
    
    return sexName;
}
+ (int)sexTypeConvertFromName:(NSString *)sexName{
    int sexFlag = 0;
    if([sexName isEqualToString:@"男"]){
        sexFlag = 0;
    } else if ([sexName isEqualToString:@"女"]){
        sexFlag = 1;
    } else if ([sexName isEqualToString:@"保密"]){
        sexFlag = 2;
    }
    return sexFlag;
}
@end
