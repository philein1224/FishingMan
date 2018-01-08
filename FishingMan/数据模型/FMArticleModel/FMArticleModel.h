//
//  FMArticleModel.h
//  FishingMan
//
//  Created by zhangxh on 2017/10/24.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "ZXHBaseModel.h"
#import "FMFishUserModel.h"

@interface FMArticleModel : ZXHBaseModel

@property (assign, nonatomic) long     ID;        //文章ID
@property (assign, nonatomic) int      articleType;  //文章类型
@property (copy, nonatomic) NSString * title;        //文章title

@property (assign, nonatomic) long     fishTime;       //出钓时间
@property (copy, nonatomic) NSString * bait;           //饵料
@property (copy, nonatomic) NSString * waterType;      //钓点类型
@property (copy, nonatomic) NSString * fishingFunc;    //钓法
@property (copy, nonatomic) NSString * fishType;       //主要鱼种
@property (copy, nonatomic) NSString * fishPoleLength; //鱼竿长度
@property (copy, nonatomic) NSString * fishPoleBrand;  //鱼竿品牌
@property (copy, nonatomic) NSString * fishLines;      //线组

@property (copy, nonatomic) NSString * lng;      //经度
@property (copy, nonatomic) NSString * lat;      //纬度
@property (copy, nonatomic) NSString * locationAddress;//地址

@property (copy, nonatomic) NSString * content;        //详细介绍
@property (copy, nonatomic) NSString * recommends;     //推荐的三张图片

@property (assign, nonatomic) long        created;   //创建时间
@property (assign, nonatomic) long        modified;  //修改时间
@property (assign, nonatomic) long        userId;    //用户id

@property (copy, nonatomic) NSString * orderFieldNextType;      //ASC排序方式
@property (assign, nonatomic) long        yn;       //是否已经软删除

@property (strong, nonatomic) FMFishUserModel * user; //发布者简单信息
@property (assign, nonatomic) int      likeCount;   //点赞数量
@property (assign, nonatomic) BOOL     liked;       //是否点赞
@property (assign, nonatomic) int      commentCount;   //评论数量
@property (assign, nonatomic) BOOL     collected;      //是否收藏

//内容转换后的生成的
@property (assign, nonatomic) int      imageCount;  //文章包含的图片
@property (copy, nonatomic) NSString * pic0;        //pic0
@property (copy, nonatomic) NSString * pic1;        //pic1
@property (copy, nonatomic) NSString * pic2;        //pic2
@property (copy, nonatomic) NSArray  * contentArray;  //详情介绍之内容

@end
