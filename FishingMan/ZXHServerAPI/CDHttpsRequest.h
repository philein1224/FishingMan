//
//  CDHttpsRequest.h
//  PurpleHorse
//
//  Created by zhangxh on 2017/5/22.
//  Copyright © 2017年 andy dufresne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface CDHttpError : NSObject

@property(nonatomic, assign) NSInteger errorCode;
@property(nonatomic, strong) NSString *errorMessage;
@property(nonatomic, strong) NSError *error;

@end

typedef void (^CDHttpSuccess)(NSURLSessionDataTask *dataTask, id responseObject);
typedef void (^CDHttpFailure)(NSURLSessionDataTask *dataTask, CDHttpError *error);

@interface CDHttpsRequest : NSObject

+ (CDHttpsRequest *)manager;

//适用普通的请求
- (NSURLSessionDataTask *)POST:(NSString *)url
                    parameters:(NSDictionary *)params
                 connectNumber:(NSString *)apiName
                       success:(CDHttpSuccess)success
                       failure:(CDHttpFailure)failure;

//适用于图片上传
- (NSURLSessionDataTask *)POST:(NSString *)url
                    parameters:(NSDictionary *)params
                 connectNumber:(NSString *)apiName
     constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                       success:(CDHttpSuccess)success
                       failure:(CDHttpFailure)failure;

@end
