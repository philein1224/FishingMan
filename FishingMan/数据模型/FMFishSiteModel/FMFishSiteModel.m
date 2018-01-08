//
//  FMFishSiteModel.m
//  FishingMan
//
//  Created by zhangxh on 2017/10/24.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMFishSiteModel.h"

@implementation FMFishSiteModel
MJExtensionCodingImplementation

- (id)init{
    self = [super init];
    if (self) {
        
        _title = @"";
        _address = @"";
        
        _canPark = YES;
        _canEat = YES;
        _canHotel = NO;
        _canNight = NO;
        
        _introduce = @"";
        _lng = @"";
        _lat = @"";
        _pic0 = @"";
        _pic1 = @"";
        _pic2 = @"";
        _pic3 = @"";
        
        _siteType = @"";
        _siteFeeType = @"";
        _siteFishType = @"";
        
        _sitePhone = @"";
        _userId = 0;
        
        _orderFieldNextType = @"";
    }
    return self;
}
//转换id的名称
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID":@"id"};
}


@end
