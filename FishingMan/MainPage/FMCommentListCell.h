//
//  FMCommentListCell.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/20.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMArticleCommentModel.h"

typedef NS_OPTIONS(NSUInteger, CommentActionType) {
    CommentActionTypeOpenUserPage = 0,
    CommentActionTypePraise =1,
    CommentActionTypeReplay = 2
};

@interface FMCommentListCell : UITableViewCell

@property (nonatomic, copy) void (^actionBlock)(CommentActionType type, id info);

@property (nonatomic, strong) FMArticleCommentModel * commentModel;

- (void)reloadData;

@end
