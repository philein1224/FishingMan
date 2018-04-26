//
//  FMThanksTableViewCell.h
//  FishingMan
//
//  Created by zhangxh on 2017/3/23.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMBaseUserTableViewCell.h"

@interface FMThanksTableViewCell : FMBaseUserTableViewCell

@property (nonatomic, strong) FMLoginUser * userInfo;

- (void)reloadData;

@end
