//
//  FMFishSiteModel.h
//  FishingMan
//
//  Created by zhangxh on 2017/10/24.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "ZXHBaseModel.h"

@interface FMFishSiteModel : ZXHBaseModel

@property (assign, nonatomic) long        ID;        //钓点ID
@property (copy, nonatomic) NSString * title;        //钓点名称
@property (copy, nonatomic) NSString * address;      //地址
@property (assign, nonatomic) BOOL        canPark;   //停车
@property (assign, nonatomic) BOOL        canEat;    //吃饭
@property (assign, nonatomic) BOOL        canHotel;  //住宿
@property (assign, nonatomic) BOOL        canNight;  //夜钓
@property (assign, nonatomic) long        created;   //创建时间
@property (assign, nonatomic) long        modified;  //修改时间
@property (copy, nonatomic) NSString * introduce;    //详细介绍

@property (copy, nonatomic) NSString * lng;      //经度
@property (copy, nonatomic) NSString * lat;      //纬度

@property (copy, nonatomic) NSString * pic0;      //图片地址
@property (copy, nonatomic) NSString * pic1;      //图片地址
@property (copy, nonatomic) NSString * pic2;      //图片地址
@property (copy, nonatomic) NSString * pic3;      //图片地址

@property (copy, nonatomic) NSString * siteType;      //钓点类型
@property (copy, nonatomic) NSString * siteFeeType;   //收费类型
@property (copy, nonatomic) NSString * siteFishType;  //主要鱼种
@property (copy, nonatomic) NSString * sitePhone;     //钓点联系电话

@property (assign, nonatomic) int      publishType;//发布类型（钓友、场主、平台）
@property (assign, nonatomic) long     userId;     //用户id（发布者的userId）

@property (copy, nonatomic) NSString * orderFieldNextType;      //ASC排序方式
@property (assign, nonatomic) long        yn;      //是否已经软删除

#pragma mark 扩展数据
@property (assign, nonatomic) int      score;      //推荐指数
@property (assign, nonatomic) BOOL     liked;      //是否已经被点赞推荐
@property (assign, nonatomic) BOOL     collectioned;  //是否已经被收藏：YES已经收藏／NO未收藏



@end
