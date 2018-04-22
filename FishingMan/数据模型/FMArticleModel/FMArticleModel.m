//
//  FMArticleModel.m
//  FishingMan
//
//  Created by zhangxh on 2017/10/24.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMArticleModel.h"

@implementation FMArticleModel
MJExtensionCodingImplementation

- (id)init{
    self = [super init];
    if (self) {
        
        _title = @"";
        _city = @"";
        _bait = @"";
        _waterType = @"";
        _fishingFunc = @"";
        _fishType = @"";
        _fishPoleLength = @"";
        _fishPoleBrand = @"";
        _fishLines = @"";
        
        _lng = @"";
        _lat = @"";
        _locationAddress = @"";
        
        _content = @"";
        _recommends = @"";
        
//        _userId = 0;
//        _orderFieldNextType = @"";
    }
    return self;
}
//转换id的名称
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID":@"id"};
}


@end
