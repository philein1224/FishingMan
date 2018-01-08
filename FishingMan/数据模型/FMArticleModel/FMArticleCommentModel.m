//
//  FMArticleCommentModel.m
//  FishingMan
//
//  Created by zhangxh on 2017/10/24.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMArticleCommentModel.h"

@implementation FMArticleCommentModel
MJExtensionCodingImplementation

- (id)init{
    self = [super init];
    if (self) {
        
        _content = @"";
        
        _fromUserName = @"";
        _fromUserAvtor = @"";
        
        _toUserName = @"";
        _toUserAvtor = @"";
        
        _city = @"";
        _level = @"";
        _toContent = @"";
        _lat = @"0";
        _lat = @"0";
    }
    return self;
}
//转换id的名称
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"ID":@"id"};
}


@end
