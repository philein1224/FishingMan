//
//  FMSiteHomeHeaderView.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/23.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FMFishSiteModel;

@interface FMSiteHomeHeaderView : UIView
@property (strong, nonatomic) FMFishSiteModel * siteModel;
- (void)reloadData;
@end
