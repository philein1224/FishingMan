//
//  EditContentModel.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/13.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "ZXHBaseModel.h"

@interface EditContentModel : ZXHBaseModel

@property (assign, nonatomic) NSInteger index;

@property (strong, nonatomic) NSString * imageName;//图片名称
@property (strong, nonatomic) UIImage * image;     //图片对象
@property (strong, nonatomic) NSString * imageUrl; //图片地址

@property (strong, nonatomic) NSString * text;     //文本
@property (strong, nonatomic) NSString * placeholderText;     //文本
@property (assign, nonatomic) float height;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) NSInteger editContentType;

@end
