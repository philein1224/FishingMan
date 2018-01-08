//
//  FMWeatherFutureModel.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/1.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMWeatherFutureModel.h"

@implementation FMWeatherFutureModel

MJExtensionCodingImplementation

- (instancetype)init{
    
    self = [super init];
    
    if(self){
        
        _date = @"";
        _dayTime = @"";
        _night = @"";
        _temperature = @"";
        _week = @"";
        _wind = @"";
        
    }
    
    return self;
}
@end
