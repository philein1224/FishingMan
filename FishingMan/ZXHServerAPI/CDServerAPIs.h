//
//  CDServerAPIs.h
//  PurpleHorse
//
//  Created by zhangxh on 2017/5/22.
//  Copyright © 2017年 ShaobinHuang. All rights reserved.
//
//  方法命名规则：requestXXX
//

#import <Foundation/Foundation.h>
#import "CDHttpsRequest.h"
#import "FMLoginUser.h"
#import "EditViewController.h"

#define Notification_LoginOrLogout        @"Notification_LoginOrLogout"
#define Notification_ShowLoginRegisterVC  @"Notification_ShowLoginRegisterVC"
/*
 *接口请求地址 connectNumber为接口号
 */

#define CD_SERVER_ADDRESS(api_name)  [NSString stringWithFormat:@"https://diaoyuxiehui.cn%@",api_name]

//#define CD_SERVER_ADDRESS(api_name)  [NSString stringWithFormat:@"http://192.168.0.104:8080%@",api_name]


@interface CDServerAPIs : NSObject

+ (CDServerAPIs *)shareAPI;

#pragma mark 网络模块分析检测

+ (BOOL)httpResponse:(id)responseObject showAlert:(BOOL)show DataTask:(NSURLSessionDataTask *) dataTask;
+ (void)httpDataTask:(NSURLSessionDataTask *)dataTask error:(NSError *)error;

- (NSURLSessionDataTask *)POSTRequestOperationWithURL:(NSString *)url
                                        connectNumber:(NSString *)connectNumber
                                           parameters:(id)params
                                              success:(CDHttpSuccess)success
                                              failure:(CDHttpFailure)failure;
#pragma mark 用户登录注册账户模块

/**
 判断手机号是否已经注册
 */
- (NSURLSessionDataTask *)requestWhetherRegisteredPhone:(NSString *)phoneNumber Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;

/**
 登录/user/login4Tel
 */
- (NSURLSessionDataTask *)requestLoginWithPhone:(NSString *)phoneNumber Password:(NSString *)password Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;

/**
 登出/user/logout
 */
- (NSURLSessionDataTask *)requestLoginOutSuccess:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;

/**
 根据操作类型获取短信验证码
 //regist【注册】
 //forgetPwd【忘记密码】
 */
- (NSURLSessionDataTask *)requestSMSCodeForPhone:(NSString *)phoneNumber withType:(NSString *)smsCodeType Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;

/**
 注册手机账号／忘记登录密码
 //regist【注册】
 //forgetPwd【忘记密码】
 */
- (NSURLSessionDataTask *)requestRegisterWithSMSCode:(NSString *)validCode
                                           Phone:(NSString *)phoneNumber
                                        Password:(NSString *)password
                                      InviteCode:(NSString *)inviteCode
                                        withType:(NSString *)registerType
                                         Success:(CDHttpSuccess)success
                                         Failure:(CDHttpFailure)failure;

/**
 个人中心-修改账户密码
 */
- (NSURLSessionDataTask *)requestModifyOldPassword:(NSString *)oldPassword
                                   WithNewPassword:(NSString *)newPassword
                                        WithUserID:(NSString *)userId
                                           Success:(CDHttpSuccess)success
                                           Failure:(CDHttpFailure)failure;

/**
 第三方登录后信息注册
 identifyType: 0：微信、1：QQ、2：微博
 Sex:0男、1女、2未知
 */
- (NSURLSessionDataTask *)requestThirdPartyLoginWithUID:(NSString *)uid
                                             identifier:(NSString *)identifier
                                           identifyType:(int)type
                                                Avartar:(NSString *)avartar
                                               NickName:(NSString *)nickName
                                               Birthday:(NSString *)birthday
                                                    Sex:(int)sex
                                           Success:(CDHttpSuccess)success
                                           Failure:(CDHttpFailure)failure;

/**
 第三方登录后，绑定手机号 /user/bindTel
 telephone: NSString
 */
- (NSURLSessionDataTask *)bindThirdPartyWithTelephoneNum:(NSString *)telephone
                                               ValidCode:(NSString *)validCode
                                                Password:(NSString *)password
                                                 Success:(CDHttpSuccess)success
                                                 Failure:(CDHttpFailure)failure;

/**
 编辑用户信息接口【个人中心-头像-个人资料】
 */
- (NSURLSessionDataTask *)modifyUserInfoWithNikeName:(NSString *)nickname
                                                 sex:(int)sex
                                           avatarUrl:(NSString *)avatarUrl
                                             address:(NSString *)address
                                            birthday:(NSDate *)birthdayDate
                                             success:(CDHttpSuccess)success
                                             failure:(CDHttpFailure)failure;

/**
 获取用户基本信息 user/getUserInfo
 */
- (NSURLSessionDataTask *)requestLoginedUserInfoSuccess:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;


#pragma mark 上传图片
- (NSURLSessionDataTask *)uploadImageBlock:(void(^)(id <AFMultipartFormData> formData))block
                              Success:(CDHttpSuccess)success
                              Failure:(CDHttpFailure)failure;









///**
// 获得理财产品列表数据
// */
//- (NSURLSessionDataTask *)requestProductListSuccess:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;
///**
// 获得理财产品详情页数据
// */
//- (NSURLSessionDataTask *)requestProductDetailWithId:(long)productId Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;
//
///*
// *获得理财产品投资记录数据
// *pages:页数
// *rows:行数
// */
//- (NSURLSessionDataTask *)requestProductRecordsWithProductId:(long)productId andPage:(NSUInteger)page andRows:(NSUInteger)rows Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;
//
///*
// *获得理财产品债券详情数据
// *pages:页数
// *rows:行数
// */
//- (NSURLSessionDataTask *)requestProductBondDetailsWithProductId:(long)productId andPage:(NSUInteger)page andRows:(NSUInteger)rows Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;








@end
