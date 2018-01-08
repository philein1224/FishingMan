//
//  FMFishStoreModel.h
//  FishingMan
//
//  Created by zhangxh on 2017/10/24.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "ZXHBaseModel.h"

@interface FMFishStoreModel : ZXHBaseModel

@property (assign, nonatomic) long        ID;        //钓点ID
@property (copy, nonatomic) NSString * title;        //钓点名称
@property (copy, nonatomic) NSString * address;      //地址
@property (assign, nonatomic) long        created;   //创建时间
@property (assign, nonatomic) long        modified;  //修改时间
@property (copy, nonatomic) NSString * introduce;    //详细介绍
@property (copy, nonatomic) NSString * lng;      //经度
@property (copy, nonatomic) NSString * lat;      //纬度
@property (copy, nonatomic) NSString * pic0;      //图片地址
@property (copy, nonatomic) NSString * pic1;      //图片地址
@property (copy, nonatomic) NSString * pic2;      //图片地址
@property (copy, nonatomic) NSString * pic3;      //图片地址
@property (copy, nonatomic) NSString * sitePhone;      //钓点联系电话
@property (assign, nonatomic) long        userId;  //用户id

@property (copy, nonatomic) NSString * orderFieldNextType;      //ASC排序方式
@property (assign, nonatomic) long        yn;      //是否已经软删除

@end
