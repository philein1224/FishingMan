//
//  FMWeatherDataModel.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/1.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMWeatherDataModel.h"
#import "FMWeatherFutureModel.h"

@implementation FMWeatherDataModel

MJExtensionCodingImplementation

- (instancetype)init{
    
    self = [super init];
    
    if(self){
        
        _coldIndex = @"";
        _week = @"";
        _province = @"";
        _city = @"";
        _distrct = @"";
        _humidity = @"";
        
        _sunrise = @"";
        _sunset = @"";
        _date = @"";
        
        _time = @"";
        _wind = @"";
        _temperature = @"";
        _pollutionIndex = @"";
        _updateTime = @"";
        _weather = @"";
        _airCondition = @"";
        _washIndex = @"";
        _exerciseIndex = @"";
        _dressingIndex = @"";
    }
    
//    [FMWeatherDataModel mj_setupObjectClassInArray:^NSDictionary *{
//        return @{
//                 @"future" : @"FMWeatherFutureModel"
////                  @"future" : [Status class],
//                 };
//    }];
    
    return self;
}

+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"future" : @"FMWeatherFutureModel"
             };
}
@end
