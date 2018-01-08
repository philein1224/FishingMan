//
//  FMWeatherDataModel.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/1.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "ZXHBaseModel.h"

@interface FMWeatherDataModel : ZXHBaseModel

@property (strong, nonatomic) NSMutableArray *future;        //预约列表
@property (strong, nonatomic) NSString       *coldIndex;   //感冒指数
@property (strong, nonatomic) NSString       *week;
@property (strong, nonatomic) NSString       *province;
@property (strong, nonatomic) NSString       *city;
@property (strong, nonatomic) NSString       *distrct;
@property (strong, nonatomic) NSString       *humidity;      //:湿度：53%
@property (strong, nonatomic) NSString       *sunrise;
@property (strong, nonatomic) NSString       *sunset;
@property (strong, nonatomic) NSString       *date;          //:2017-03-28",
@property (strong, nonatomic) NSString       *time;          //:22:20
@property (strong, nonatomic) NSString       *wind;          //:南风2级
@property (strong, nonatomic) NSString       *temperature;   //:10℃
@property (strong, nonatomic) NSString       *pollutionIndex;//污染指数:88
@property (strong, nonatomic) NSString       *updateTime;    //更新时间:20170328223409
@property (strong, nonatomic) NSString       *weather;       //:晴
@property (strong, nonatomic) NSString       *airCondition;  //空气质量:良

@property (strong, nonatomic) NSString       *washIndex;     //洗车指数:非常适宜
@property (strong, nonatomic) NSString       *exerciseIndex; //运动指数:不适宜
@property (strong, nonatomic) NSString       *dressingIndex; //穿衣指数:毛衣类

@end
