//
//  CDHttpsRequest.m
//  PurpleHorse
//
//  Created by zhangxh on 2017/5/22.
//  Copyright © 2017年 andy dufresne. All rights reserved.
//

#import "CDHttpsRequest.h"

@implementation CDHttpError
@end

@interface CDHttpsRequest ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;//AFURLSessionManager

@property (nonatomic, assign) BOOL JSON_MODE; //yes:json模式，no:表单模式

@end

@implementation CDHttpsRequest

+ (CDHttpsRequest *)manager {
    
    static CDHttpsRequest *httpsRequest;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        httpsRequest = [[CDHttpsRequest alloc] init];
    });
    
    return httpsRequest;
}

- (id)init {
    
    self = [super init];
    if (self) {
        
        self.JSON_MODE = YES;
        [self initConfigSessionManager];
    }
    return self;
}

- (void)initConfigSessionManager {
    
    //https相关的证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"diaoyuxiehui" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]; //AFSSLPinningModeCertificate
    if (certData) {
        NSSet *set = [NSSet setWithObjects:certData, nil];
        securityPolicy.pinnedCertificates = set;
    }
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO; //YES
    
    
    _sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    _sessionManager.securityPolicy = securityPolicy;
    
    // 设置超时时间
//    _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [_sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    _sessionManager.requestSerializer.timeoutInterval = 15.0f;
//    [_sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
//    [_sessionManager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//    [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", @"multipart/form-data", @"boundary=AaB03x", nil];
}

//公共数据部分
- (AFJSONRequestSerializer *)commonDataInHttpHeader:(AFJSONRequestSerializer *)request{
    
        //1、app版本号
    [request setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"version"];
    
        //2、登录用户的userId
    FMLoginUser * user = [FMLoginUser getCacheUserInfo];
    if (![ZXHTool isNilNullObject:user]) {
        [request setValue:[NSString stringWithFormat:@"%@", user.userId] forHTTPHeaderField:@"userId"];
    }
    
    return request;
}

//上传图片
- (NSURLSessionDataTask *)POST:(NSString *)url
                    parameters:(NSDictionary *)params
                 connectNumber:(NSString *)apiName
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(CDHttpSuccess)success
                       failure:(CDHttpFailure)failure {
    
    __block NSURLSessionDataTask *dataTask = nil;
    _sessionManager.operationQueue.maxConcurrentOperationCount = 1;
    
    NSMutableDictionary *finalParameters = [NSMutableDictionary dictionary];
    if (params != nil) {
        [finalParameters addEntriesFromDictionary:params];
    }
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = nil;
    
    if (block) {
        
        if(self.JSON_MODE){
            
//            NSString * jsonContent = [ZXHTool dataToJsonString:finalParameters];
//            CLog(@"jsonContent %@", jsonContent);
            
            request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:finalParameters error:nil];
        }
        else{
            request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:finalParameters error:&serializationError];
        }
    }
    else{
        NSString * jsonContent = [ZXHTool dataToJsonString:finalParameters];
        CLog(@"jsonContent %@", jsonContent);
        request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSData *body = [jsonContent dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:body];
    }
    
    
    
    /*
     uploadTaskWithRequest:(NSURLRequest *)request
     fromData:(nullable NSData *)bodyData
     progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock
     completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject, NSError * _Nullable error))completionHandler;
     */
    
    dataTask = [_sessionManager POST:url
                          parameters:finalParameters
           constructingBodyWithBlock:block
                            progress:nil
                             success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *jsonObject = [ZXHTool jsonObjectFromJsonString:jsonString];
        CLog(@"接口名：%@ \n jsonString:%@ \njsonObject:%@",apiName,jsonString,jsonObject);
        
        success(task, jsonObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        CLog(@"failure 打印数据:%@",error);
        CDHttpError *httpError = [[CDHttpError alloc] init];
        httpError.error = error;
        httpError.errorCode = error.code;
        CLog(@"CDHttpError.errorCode:%ld,msg:%@,error:%@",httpError.errorCode, httpError.errorMessage,error);
        failure(dataTask, httpError);
    }];
    
//    [dataTask resume];
    
    return dataTask;
}

//普通接口
- (NSURLSessionDataTask *)POST:(NSString *)url
                    parameters:(NSDictionary *)params
                 connectNumber:(NSString *)apiName
                       success:(CDHttpSuccess)success
                       failure:(CDHttpFailure)failure {
    
    CLog(@"普通接口 API(%@): 最终请求参数:%@", apiName, params);
    
    NSMutableDictionary *finalParameters = [NSMutableDictionary dictionary];
    if (params != nil) {
        [finalParameters addEntriesFromDictionary:params];
    }
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = nil;
    
//    if (self.JSON_MODE) {
//        NSString * jsonContent = [ZXHTool dataToJsonString:finalParameters];
//        CLog(@"jsonContent %@", jsonContent);
//
//        request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
//
//        [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//
//        NSData *body = [jsonContent dataUsingEncoding:NSUTF8StringEncoding];
//        [request setHTTPBody:body];
//    }
//    else{
//        request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:finalParameters error:&serializationError];
//    }
    
    NSString * jsonContent = [ZXHTool dataToJsonString:finalParameters];
    CLog(@"jsonContent %@", jsonContent);
    
    request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:nil error:nil];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSData *body = [jsonContent dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:body];
    
    
    if (serializationError) {//序列化失败
        
        if (failure) {
            
            CDHttpError *httpError = [[CDHttpError alloc] init];
            httpError.error = serializationError;
            httpError.errorCode = 999;
            httpError.errorMessage = @"cdHttpRequest serializationError";
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                failure(nil, httpError);
            });
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    _sessionManager.operationQueue.maxConcurrentOperationCount = 5;
    
    /*
    dataTask = [_sessionManager dataTaskWithRequest:request
                                     uploadProgress:nil
                                   downloadProgress:nil
                                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                         
                                     }];
    */
    
    dataTask = [_sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        if (error) {
            
            CDHttpError *httpError = [[CDHttpError alloc] init];
            httpError.error = error;
            httpError.errorCode = error.code;
            CLog(@"CDHttpError.errorCode:%ld,msg:%@,error:%@",httpError.errorCode, httpError.errorMessage,error);
            failure(dataTask, httpError);
            
        } else {
            
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *jsonObject = [ZXHTool jsonObjectFromJsonString:jsonString];
            CLog(@"接口名(%@): \n jsonString:%@",apiName,jsonObject);
            success(dataTask, jsonObject);
        }
    }];
    
    [dataTask resume];
    
    return dataTask;
}


/*
 
 NSError *serializationError = nil;
 NSMutableURLRequest *request = nil;
 
 //    if (block) {
 //
 //        request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:finalParameters constructingBodyWithBlock:block error:&serializationError];
 //    }
 //    else {
 //
 //        request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:finalParameters error:&serializationError];
 //    }
 
 //    CLog(@"原来的：header = %@; Content-Type = %@",request.allHTTPHeaderFields, [request valueForHTTPHeaderField:@"Content-Type"]);
 
 //    [request setValue:@"application/json;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
 
 //    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
 //    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
 
 //    [request addValue:@"Application/json" forHTTPHeaderField:@"Content-Type"];
 //    [request addValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
 //    [request addValue:@"text/json" forHTTPHeaderField:@"Content-Type"];
 
 //    [request addValue:@"text/javascript" forHTTPHeaderField:@"Content-Type"];
 //
 //    CLog(@"新的：header = %@; Content-Type = %@",request.allHTTPHeaderFields, [request valueForHTTPHeaderField:@"Content-Type"]);
 
 
 if (serializationError) {//序列化失败
 
 if (failure) {
 
 CDHttpError *httpError = [[CDHttpError alloc] init];
 httpError.error = serializationError;
 httpError.errorCode = 999;
 httpError.errorMessage = @"cdHttpRequest serializationError";
 
 dispatch_async(dispatch_get_main_queue(), ^{
 
 failure(nil, httpError);
 });
 }
 return nil;
 }
 
 //    dataTask = [_sessionManager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
 //        CLog(@"CDHttpError.errorCod = %@", responseObject);
 //    }];
 
 
 //    dataTask = [_sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
 //
 //        if (error) {
 //
 //            CDHttpError *httpError = [[CDHttpError alloc] init];
 //            httpError.error = error;
 //            httpError.errorCode = error.code;
 //            CLog(@"CDHttpError.errorCode:%ld,msg:%@,error:%@",httpError.errorCode, httpError.errorMessage,error);
 //            failure(dataTask, httpError);
 //
 //        } else {
 //
 //            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
 //            NSDictionary *jsonObject = [ZXHTool jsonObjectFromJsonString:jsonString];
 //            CLog(@"接口名：%@ \n jsonString:%@ \njsonObject:%@",apiName,jsonString,jsonObject);
 //            success(dataTask, jsonObject);
 //        }
 //    }];
 
 */
@end
