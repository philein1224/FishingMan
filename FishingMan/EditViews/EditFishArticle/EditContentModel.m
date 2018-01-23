//
//  EditContentModel.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/13.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "EditContentModel.h"

@implementation EditContentModel

- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        _image = nil;
        _imageName = @"";
        _imageUrl = @"";
        _text = @"";
        _placeholderText = @"";
    }
    return self;
}
@end
