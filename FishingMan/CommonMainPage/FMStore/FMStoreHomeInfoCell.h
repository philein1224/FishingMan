//
//  FMStoreHomeInfoCell.h
//  FishingMan
//
//  Created by zhangxh on 2017/5/17.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMCommonMainPageBaseCell.h"

@class FMFishStoreModel;

@interface FMStoreHomeInfoCell : FMCommonMainPageBaseCell
@property (strong, nonatomic) FMFishStoreModel * storeModel;
- (void)reloadData;
@end
