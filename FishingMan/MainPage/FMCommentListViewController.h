//
//  FMCommentListViewController.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/20.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMArticleModel;

@interface FMCommentListViewController : UIViewController

@property (nonatomic, copy) void (^replyActionBlock)(id info);
@property (nonatomic, strong) FMArticleModel * articleModel;//文章模块

@end
