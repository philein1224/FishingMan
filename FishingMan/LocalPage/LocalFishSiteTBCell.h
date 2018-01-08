//
//  LocalFishSiteTBCell.h
//  FishingMan
//
//  Created by zhangxh on 2017/3/22.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMFishSiteModel.h"

@interface LocalFishSiteTBCell : UITableViewCell

@property (strong, nonatomic) FMFishSiteModel *model;

- (void)reloadData;

@end
