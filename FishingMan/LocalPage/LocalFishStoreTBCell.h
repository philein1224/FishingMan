//
//  LocalFishStoreTBCell.h
//  FishingMan
//
//  Created by zhangxh on 2017/3/22.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMFishStoreModel.h"

@interface LocalFishStoreTBCell : UITableViewCell

@property (strong, nonatomic) FMFishStoreModel *model;

- (void)reloadData;

@end
