//
//  FMSiteHomeInfoCell.h
//  FishingMan
//
//  Created by zhangxh on 2017/5/17.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMCommonMainPageBaseCell.h"

@class FMFishSiteModel;
@interface FMSiteHomeInfoCell : FMCommonMainPageBaseCell
@property (strong, nonatomic) FMFishSiteModel * siteModel;
- (void)reloadData;
@end
