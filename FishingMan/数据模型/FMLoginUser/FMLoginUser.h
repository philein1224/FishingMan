//
//  FMLoginUser.h
//  FishingMan
//
//  Created by zhangxh on 2017/7/18.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "ZXHBaseModel.h"

//但存判断是否处于登录状态
#define IS_LOGIN              [FMLoginUser isLogin]
//判断是否处于登录状态,并提示用户，要求重新登录
#define IS_LOGIN_WITH_ALERT       [FMLoginUser isLoginAndAlert]
#define IS_LOGIN_WITHOUT_ALERT    [FMLoginUser isLoginWithoutAlert]

@interface FMLoginUser : ZXHBaseModel

@property (strong, nonatomic) NSString * userId;      //user id
@property (assign, nonatomic) int        level;       //等级
@property (strong, nonatomic) NSString * point;       //积分
@property (strong, nonatomic) NSString * tel;         //手机号

#pragma mark 更多个人信息
@property (strong, nonatomic) NSString * address;     //用户地址
@property (strong, nonatomic) NSString * avatarUrl;   //用户头像地址
@property (assign, nonatomic) long       birthday;    //用户生日时间戳(1970距离生日的时间)
@property (strong, nonatomic) NSString * nickName;    //用户昵称
@property (assign, nonatomic) int        sex;         //用户性别
@property (strong, nonatomic) NSString * orderFieldNextType;   //用户头像地址

/*
 address = string;
 avatarUrl = "http://diaoyudaxian01.b0.upaiyun.com/asd";
 created = 1509375597000;
 id = 1;
 level = 0;
 modified = 1515681916000;
 nickName = haha;
 orderFieldNextType = ASC;
 point = 0;
 tel = 18782420424;
 yn = 1;
 */

//缓存用户基本信息
+ (void)setCacheUserInfo:(FMLoginUser *)user;
//读取用户登录信息
+ (FMLoginUser *)getCacheUserInfo;
//清除缓存
+ (void)removeCacheUserInfo;
//但存判断是否处于登录状态
+ (BOOL)isLogin;
//判断是否处于登录状态,并提示用户，要求重新登录
+ (BOOL)isLoginAndAlert;
+ (BOOL)isLoginWithoutAlert;

//性别转换：如0->男
+ (NSString *)sexConverter:(int)sexType;
//生日转换：如128312736127->1983-12-24
+ (NSString *)birthdayConverter:(long)timeStamp;
//等级转换成等级名称
+ (NSString *)levelConvertFromType:(int)levelType;
//性别类型转成性别名
+ (NSString *)sexNameConvertFromType:(int)sexType;
//性别名转成性别类型
+ (int)sexTypeConvertFromName:(NSString *)sexName;
@end
