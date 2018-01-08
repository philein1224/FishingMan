//
//  FMFishUserModel.h
//  FishingMan
//
//  Created by zhangxh on 2017/10/24.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "ZXHBaseModel.h"

@interface FMFishUserModel : ZXHBaseModel
@property (strong, nonatomic) NSString * userId;      //user id
@property (strong, nonatomic) NSString * avatarUrl;   //用户头像地址
@property (strong, nonatomic) NSString * nickName;    //用户昵称

@property (strong, nonatomic) NSString * name;        //姓名
@property (strong, nonatomic) NSString * sex;         //性别
@property (strong, nonatomic) NSString * address;     //地址
@end
