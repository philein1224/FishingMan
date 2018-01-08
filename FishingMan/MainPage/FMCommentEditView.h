//
//  FMCommentEditView.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/19.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMArticleDetailViewController.h"

typedef void (^CommentEditViewStatusBlock) (BOOL show);
typedef void (^CommentEditViewSendBlock) (NSString * content);

@interface FMCommentEditView : UIView

@property (copy, nonatomic) CommentEditViewStatusBlock commentEditViewStatusBlock;
@property (copy, nonatomic) CommentEditViewSendBlock commentEditViewSendBlock;

@property (strong, nonatomic) id supper;
@property (weak, nonatomic) IBOutlet UITextView *commentTextField;

+ (instancetype)shareCommentViewWithTarget:(id)target
                                  callback:(CommentEditViewStatusBlock) statusBlock
                                  callback:(CommentEditViewSendBlock) sendBlock;

@end
