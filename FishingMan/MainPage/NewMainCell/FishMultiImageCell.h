//
//  FishMultiImageCell.h
//  ZXHTools
//
//  Created by zhangxh on 2016/11/16.
//  Copyright © 2016年 HongFan. All rights reserved.a
//

#import <UIKit/UIKit.h>
@class FMArticleModel;

@interface FishMultiImageCell : UITableViewCell

@property(strong, nonatomic) FMArticleModel * articleModel;
- (void)reloadData;

@end
