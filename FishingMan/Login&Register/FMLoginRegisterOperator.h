//
//  FMLoginRegisterOperator.h
//  FishingMan
//
//  Created by zxh on 2017/7/4.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FMLoginRegisterOperator : NSObject
//获取验证码
+ (void)APIForGettingSmsCodeForPhone:(NSString *)phoneNumber withType:(NSString *)type callback:(void (^)(NSDictionary * responseObject)) callback;
@end
