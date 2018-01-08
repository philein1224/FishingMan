//
//  FishVideoCell.h
//  ZXHTools
//
//  Created by zhangxh on 2016/11/16.
//  Copyright © 2016年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMArticleModel;

@interface FishVideoCell : UITableViewCell

@property(strong, nonatomic) FMArticleModel * articleModel;
- (void)reloadData;

@end
