//
//  FMIndexBannerCell.m
//  FishingMan
//
//  Created by zhangxh on 2017/3/22.
//  Copyright © 2017年 HongFan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CDSlideView.h"

@interface FMIndexBannerCell : UITableViewCell

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) CDSlideView *slideView;
@property (strong, nonatomic) UIView *lineView;

@property (copy, nonatomic) void (^ cellClickedCallBack)(id info);

+ (double)realHeight;

- (void)reloadData;

@end
