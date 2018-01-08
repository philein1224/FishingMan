//
//  FMWeatherFutureModel.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/1.
//  Copyright © 2017年 HongFan. All rights reserved.
//
//  "date": "2015-09-09",
//  "dayTime": "阵雨",
//  "night": "阴",
//  "temperature": "24°C/18°C",
//  "week": "星期三",
//  "wind": "无持续风向小于3级"
//

#import "ZXHBaseModel.h"

@interface FMWeatherFutureModel : ZXHBaseModel

@property (strong, nonatomic) NSString       *night;        //晴
@property (strong, nonatomic) NSString       *dayTime;      //多云
@property (strong, nonatomic) NSString       *temperature;  //20°C / 6°C
@property (strong, nonatomic) NSString       *week;         //星期三
@property (strong, nonatomic) NSString       *wind;         //南风 小于3级
@property (strong, nonatomic) NSString       *date;         //2017-03-29

@end
