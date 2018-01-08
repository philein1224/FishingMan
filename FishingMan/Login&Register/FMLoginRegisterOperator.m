//
//  FMLoginRegisterOperator.m
//  FishingMan
//
//  Created by zxh on 2017/7/4.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMLoginRegisterOperator.h"

@implementation FMLoginRegisterOperator

+ (void)APIForGettingSmsCodeForPhone:(NSString *)phoneNumber withType:(NSString *)type callback:(void (^)(NSDictionary * responseObject)) callback{
    
    [[CDServerAPIs shareAPI] requestSMSCodeForPhone:phoneNumber withType:type Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        
    }];
}


@end
