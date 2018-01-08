//
//  FMFishStoreModel.m
//  FishingMan
//
//  Created by zhangxh on 2017/10/24.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMFishStoreModel.h"

@implementation FMFishStoreModel
MJExtensionCodingImplementation

- (id)init{
    self = [super init];
    if (self) {
        
        _title = @"";
        _address = @"";
        
        _introduce = @"";
        _lng = @"";
        _lat = @"";
        _pic0 = @"";
        _pic1 = @"";
        _pic2 = @"";
        _pic3 = @"";
        
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
