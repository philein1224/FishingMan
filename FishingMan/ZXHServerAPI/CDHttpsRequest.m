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

@property (nonatomic, strong) AFURLSessionManager *sessionManager;//AFURLSessionManager

@property (nonatomic, assign) BOOL JSON_MODE; //YES:json模式，NO:表单模式

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
    
    
    _sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    _sessionManager.securityPolicy = securityPolicy;
    
    // 设置超时时间
//    _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [_sessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    _sessionManager.requestSerializer.timeoutInterval = 15.0f;
//    [_sessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
//    [_sessionManager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
//    [_sessionManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
//    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", @"multipart/form-data", @"boundary=AaB03x", nil];
    
    AFHTTPResponseSerializer *httpResponseSerializer = [AFHTTPResponseSerializer serializer];
    httpResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript", nil];
    _sessionManager.responseSerializer = httpResponseSerializer;
}

//公共数据部分
- (NSMutableURLRequest *)commonDataInHttpHeader:(NSMutableURLRequest *)request{
    
        //1、app版本号
    [request setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forHTTPHeaderField:@"version"];
    
        //2、登录用户的userId
    FMLoginUser * user = [FMLoginUser getCacheUserInfo];
    if (![ZXHTool isNilNullObject:user]) {
        [request setValue:[NSString stringWithFormat:@"%@", user.userId] forHTTPHeaderField:@"userId"];
    }
    
    return request;
}

//上传图片接口(v2)
- (NSURLSessionDataTask *)POST:(NSString *)url
                    parameters:(NSDictionary *)params
                 connectNumber:(NSString *)apiName
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(CDHttpSuccess)success
                       failure:(CDHttpFailure)failure {
    
    CLog(@"API接口访问(%@): 最终请求参数:%@", apiName, params);
    
    __block NSURLSessionDataTask *dataTask = nil;
    
    NSMutableDictionary *finalParameters = [NSMutableDictionary dictionary];
    if (params != nil) {
        [finalParameters addEntriesFromDictionary:params];
    }
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = nil;
    NSTimeInterval timeoutInterval = 25;
    
    if (block) {
        _sessionManager.operationQueue.maxConcurrentOperationCount = 1;
        timeoutInterval = 60;
        
        if(self.JSON_MODE){
            
            request = [[AFJSONRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                 URLString:url
                                                                                parameters:finalParameters
                                                                 constructingBodyWithBlock:block
                                                                                     error:&serializationError];
        }
        else{
            
            request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                 URLString:url
                                                                                parameters:finalParameters
                                                                 constructingBodyWithBlock:block
                                                                                     error:&serializationError];
        }
    }
    else{
        _sessionManager.operationQueue.maxConcurrentOperationCount = 5;
        timeoutInterval = 25;
        
        if(self.JSON_MODE){
            
            request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:finalParameters error:&serializationError];
        }
        else{
            
            request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:finalParameters error:&serializationError];
        }
    }

    //序列化失败
    if (serializationError) {
        
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
    
    //请求超时的时间（秒）
    request.timeoutInterval = timeoutInterval;
    
    //请求的header公共参数
//    request = [self commonDataInHttpHeader:request];
    
    //执行请求
    dataTask = [_sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            
            CDHttpError *httpError = [[CDHttpError alloc] init];
            httpError.error = error;
            httpError.errorCode = error.code;
            CLog(@"接口名(%@): \n errorCode:%ld, \n msg:%@, \n error:%@",apiName,httpError.errorCode,httpError.errorMessage,error);
            failure(dataTask, httpError);
            
        } else {
            
            NSString *jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *jsonObject = [ZXHTool jsonObjectFromJsonString:jsonString];
            CLog(@"接口名(%@): \n jsonString:%@",apiName,jsonObject);
            success(dataTask, jsonObject);
        }
    }];
    
    //开始
    [dataTask resume];
    
    return dataTask;
}

//普通接口(v2)
- (NSURLSessionDataTask *)POST:(NSString *)url
                    parameters:(NSDictionary *)params
                 connectNumber:(NSString *)apiName
                       success:(CDHttpSuccess)success
                       failure:(CDHttpFailure)failure {
    
    return [self POST:url parameters:params connectNumber:apiName constructingBodyWithBlock:nil success:success failure:failure];
}
@end
