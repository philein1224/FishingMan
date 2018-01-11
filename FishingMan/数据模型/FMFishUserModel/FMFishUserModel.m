//
//  FMFishUserModel.m
//  FishingMan
//
//  Created by zhangxh on 2017/10/24.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMFishUserModel.h"

@implementation FMFishUserModel
MJExtensionCodingImplementation

- (id)init{
    self = [super init];
    if (self) {
        _userId = @"";      //user id
        _avatarUrl = @"";   //用户头像地址
        _nickName = @"";    //用户昵称
        
        _name = @"";        //姓名
        _sex = @"";         //性别
        _address = @"";     //地址
    }
    return self;
}

    //转换id的名称
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"userId":@"id"};
}


@end
