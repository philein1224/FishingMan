//
//  FMShareView.h
//  FishingMan
//
//  Created by zhangxh on 2017/3/15.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ArticleReportBlock) (void);

@interface FMShareView : UIView
@property (copy, nonatomic) ArticleReportBlock articleReportBlock;
@end
