//
//  CDServerAPIs.m
//  PurpleHorse
//
//  Created by zhangxh on 2017/5/22.
//  Copyright © 2017年 ShaobinHuang. All rights reserved.
//

#import "CDServerAPIs.h"

static CDServerAPIs *shareServerAPIs;

@interface CDServerAPIs ()
{
    NSOperationQueue        *mainCurrentQueue;
    NSString                *currentOperators;
}
@end

@implementation CDServerAPIs

+ (CDServerAPIs *)shareAPI{
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        shareServerAPIs = [[self alloc] init];
    });
    
    return shareServerAPIs;
}

- (id)init{
    
    self = [super init];
    
    if(self){
        
        //队列
        mainCurrentQueue = [[NSOperationQueue alloc] init];
        mainCurrentQueue.maxConcurrentOperationCount = 1;
        [mainCurrentQueue setSuspended:NO];      //设置是否暂停
        
        currentOperators = @"";
    }
    return self;
}

- (NSURLSessionDataTask *)POSTRequestOperationWithURL:(NSString *)url
                                          connectNumber:(NSString *)connectNumber
                                             parameters:(id)params
                                                success:(CDHttpSuccess)success
                                                failure:(CDHttpFailure)failure {
    
    return [[CDHttpsRequest manager] POST:url parameters:params connectNumber:connectNumber success:success failure:failure];
}

- (NSURLSessionDataTask *)POSTRequestOperationWithURL:(NSString *)url
                                        connectNumber:(NSString *)connectNumber
                                           parameters:(id)params
                            constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                              success:(CDHttpSuccess)success
                                              failure:(CDHttpFailure)failure{
    
    return [[CDHttpsRequest manager] POST:url parameters:params connectNumber:connectNumber constructingBodyWithBlock:block success:success failure:failure];
}

//清除掉所有的登录记录
+ (void)clearCache{
}

#pragma mark 网络请求接口数据校验处理

//http成功返回值处理
+ (BOOL)httpResponse:(id)responseObject showAlert:(BOOL)show DataTask:(NSURLSessionDataTask *) dataTask {
    
    BOOL success = YES;
    int code = [responseObject[@"code"] intValue];
    
    if(code != 1000) {
        
        CLog(@"---server fail resquest url---:%@",dataTask.response.URL.absoluteString);
        CLog(@"---server fail resquest url---:%@",dataTask.currentRequest.URL.absoluteString);
        
        success = NO;
        if (code == 9999) {
            
            if(IS_LOGIN) {
                
                //设置登录状态
                [CDServerAPIs clearCache];
                
                if ([ZXHTool isEmptyString:responseObject[@"message"]]) {
                    
                    [ZXHViewTool addAlertWithTitle:@"温馨提示"
                                           message:@"登陆失效，请重新登录！"
                                       withTartget:[[[UIApplication sharedApplication] keyWindow] rootViewController]
                                   leftActionStyle:UIAlertActionStyleDefault
                                  rightActionStyle:UIAlertActionStyleDestructive
                                 leftActionHandler:^(UIAlertAction *action) {
                                     
                                 }
                                rightActionHandler:^(UIAlertAction *action) {
                                    
                                }];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LoginOrLogout object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ShowLoginRegisterVC object:nil];
                }else {
                    
                    [ZXHViewTool alertViewTitle:@"温馨提醒"
                                        Tartget:[[[UIApplication sharedApplication] keyWindow] rootViewController]
                                        Message:responseObject[@"message"]
                                     ActionName:@"确认"
                                    ActionStyle:UIAlertActionStyleDefault
                                  ActionHandler:^(UIAlertAction *action) {
                                      
                                  }];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LoginOrLogout object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ShowLoginRegisterVC object:nil];
                }
                
            }
        }
        else if (show) {
            if(![ZXHTool isEmptyString:responseObject[@"message"]]){
                [CDTopAlertView showMsg:[NSString stringWithFormat:@"%@", responseObject[@"message"]] isErrorState:YES];
            }
        }
    }
    
    return success;
}
//http失败返回处理
+ (void)httpDataTask:(NSURLSessionDataTask *)dataTask error:(NSError *)error {
    
    CLog(@"\n%@, \n%ld, \n%@, \n%@, \n%@, \n%@, \n%@",
         dataTask.originalRequest.URL,
         ((NSHTTPURLResponse *)(dataTask.response)).statusCode,
         error.localizedDescription,
         error.localizedFailureReason,
         dataTask.taskDescription,
         dataTask.response,
         dataTask.response.URL.absoluteString);
    
    if (error && [error code] != NSURLErrorCancelled) {
        
        NSString *testDebugMessage = @"";
#ifdef DEBUG
        testDebugMessage = [NSString stringWithFormat:@" ---%@ %ld: \n error code:%ld \n URL:%@", error.localizedDescription, ((NSHTTPURLResponse *)(dataTask.response)).statusCode, error.code, dataTask.originalRequest.URL];
#endif
        
        if ([error code] == NSURLErrorTimedOut) {
            
            [CDTopAlertView showMsg:[NSString stringWithFormat:@"请求超时%@",testDebugMessage] isErrorState:YES];
            
        }else if ([error code] == NSURLErrorNotConnectedToInternet) {
            
            [CDTopAlertView showMsg:[NSString stringWithFormat:@"已断开与互联网的连接%@",testDebugMessage] isErrorState:YES];
            
        }else if ([error code] == NSURLErrorCannotConnectToHost) {
            
            [CDTopAlertView showMsg:[NSString stringWithFormat:@"不能连接到服务器%@",testDebugMessage] isErrorState:YES];
            
        }else if ([error code] == NSURLErrorBadServerResponse) {//404
            
            [CDTopAlertView showMsg:[NSString stringWithFormat:@"响应失败%@",testDebugMessage] isErrorState:YES];
            
        }else if ([error code] == NSURLErrorCannotFindHost) {//未能找到使用指定主机名的服务器
            
            [CDTopAlertView showMsg:[NSString stringWithFormat:@"请切换网络后重试%@",testDebugMessage] isErrorState:YES];
        }else if ([error code] == NSURLErrorNetworkConnectionLost) {//网络连接已中断
            
            [CDTopAlertView showMsg:[NSString stringWithFormat:@"网络连接已中断%@",testDebugMessage] isErrorState:YES];
        }
        else {
            
#ifdef DEBUG
            [CDTopAlertView showMsg:[NSString stringWithFormat:@"网络错误%@",testDebugMessage] isErrorState:YES];
#endif
        }
        
//        [CDOtherUtil ZMHttpFail:httpOperation error:error];
    }
}

#pragma mark 用户登录注册账户模块

- (NSURLSessionDataTask *)requestWhetherRegisteredPhone:(NSString *)phoneNumber Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/user/validTelIsExist";
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:phoneNumber forKey:@"tel"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

- (NSURLSessionDataTask *)requestLoginWithPhone:(NSString *)phoneNumber Password:(NSString *)password Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/user/login4Tel";
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:phoneNumber forKey:@"tel"];
    [requestDic setObject:password forKey:@"password"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

- (NSURLSessionDataTask *)requestSMSCodeForPhone:(NSString *)phoneNumber withType:(NSString *)smsCodeType Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    //register【注册】
    //forgetPwd【忘记密码】
    
    NSString *APIName;
    if([smsCodeType isEqualToString:@"register"]){
        APIName = @"/user/getValidCode";
    }
    else if ([smsCodeType isEqualToString:@"forgetPwd"]){
        APIName = @"/user/getValidCodeforget";
    }
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:phoneNumber forKey:@"tel"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

- (NSURLSessionDataTask *)requestRegisterWithSMSCode:(NSString *)validCode
                                           Phone:(NSString *)phoneNumber
                                        Password:(NSString *)password
                                      InviteCode:(NSString *)inviteCode
                                        withType:(NSString *)requestType
                                         Success:(CDHttpSuccess)success
                                         Failure:(CDHttpFailure)failure{
    
    //regist【注册】
    //forgetPwd【忘记密码】
    
    NSString *APIName;
    if([requestType isEqualToString:@"register"]){
        APIName = @"/user/regist";
    }
    else if ([requestType isEqualToString:@"forgetPwd"]){
        APIName = @"/user/forgetPwd";
    }
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:phoneNumber forKey:@"tel"];
    [requestDic setObject:validCode forKey:@"validCode"];
    [requestDic setObject:password forKey:@"password"];
    
    if(![ZXHTool isEmptyString:inviteCode]){
        [requestDic setObject:inviteCode forKey:@"inviteCode"];
    }
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

/**
 个人中心-修改账户密码
 */
- (NSURLSessionDataTask *)requestModifyOldPassword:(NSString *)oldPassword
                                   WithNewPassword:(NSString *)newPassword
                                        WithUserID:(NSString *)userId
                                           Success:(CDHttpSuccess)success
                                           Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/user/changePwd";
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:userId forKey:@"id"];
    [requestDic setObject:oldPassword forKey:@"oldPwd"];
    [requestDic setObject:newPassword forKey:@"newPwd"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

/**
 第三方登录后信息注册
 */
- (NSURLSessionDataTask *)requestThirdPartyLoginWithUID:(NSString *)uid
                                             identifier:(NSString *)identifier
                                           identifyType:(int)type
                                                Avartar:(NSString *)avartar
                                               NickName:(NSString *)nickName
                                               Birthday:(NSString *)birthday
                                                    Sex:(int)sex
                                                Success:(CDHttpSuccess)success
                                                Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/user/login4ThirdPart";
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    [requestDic setObject:identifier forKey:@"credential"];
    [requestDic setObject:identifier forKey:@"identifier"];
    [requestDic setObject:[NSString stringWithFormat:@"%d", type] forKey:@"identityType"];
    
    [requestDic setObject:avartar forKey:@"avartar"];
    [requestDic setObject:nickName forKey:@"nickName"];
    [requestDic setObject:birthday forKey:@"birthday"];

    [requestDic setObject:[NSNumber numberWithInt:sex] forKey:@"sex"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

- (NSURLSessionDataTask *)modifyUserInfoWithUserId:(NSString *)userId
                                          nikeName:(NSString *)nickname
                                               sex:(int)sex
                                         avatarUrl:(NSString *)avatarUrl
                                           address:(NSString *)address
                                          birthday:(NSDate *)birthdayDate
                                           success:(CDHttpSuccess)success
                                           failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/user/editUserInfo";
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:userId forKey:@"id"];
    [requestDic setObject:nickname forKey:@"nikeName"];
    [requestDic setObject:[NSNumber numberWithInt:sex] forKey:@"sex"];
    NSString * dateString = [ZXHTool millisecondStringFromDate:birthdayDate];
    [requestDic setObject:dateString forKey:@"birthday"];
    [requestDic setObject:avatarUrl forKey:@"avatarUrl"];
    [requestDic setObject:address forKey:@"address"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

#pragma mark 上传图片

- (NSURLSessionDataTask *)uploadImageBlock:(void(^)(id <AFMultipartFormData> formData))block
                                   Success:(CDHttpSuccess)success
                                   Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/articalFish/uploadImgFile";
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic constructingBodyWithBlock:block success:success failure:failure];
}




@end
