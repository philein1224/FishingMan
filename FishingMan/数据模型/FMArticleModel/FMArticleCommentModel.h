//
//  FMArticleCommentModel.h
//  FishingMan
//
//  Created by zhangxh on 2017/10/24.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "ZXHBaseModel.h"

@interface FMArticleCommentModel : ZXHBaseModel

@property (assign, nonatomic) long     ID;         //评论ID
@property (assign, nonatomic) long     topicId;    //文章ID
@property (assign, nonatomic) int      topicType;  //文章类型
@property (copy, nonatomic) NSString * content;       //评论内容

@property (assign, nonatomic) long     created;       //创建时间
@property (assign, nonatomic) long     modified;      //修改时间

@property (assign, nonatomic) long     fromUserId;
@property (copy, nonatomic) NSString * fromUserName;
@property (copy, nonatomic) NSString * fromUserAvtor;
@property (copy, nonatomic) NSString * city;
@property (copy, nonatomic) NSString * lat;
@property (copy, nonatomic) NSString * lng;
@property (copy, nonatomic) NSString * level;

@property (assign, nonatomic) long     toUserId;
@property (copy, nonatomic) NSString * toUserName;
@property (copy, nonatomic) NSString * toUserAvtor;
@property (copy, nonatomic) NSString * toContent;

@end
