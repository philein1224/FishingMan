//
//  FMStoreHomeHeaderView.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/23.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FMFishStoreModel;

@interface FMStoreHomeHeaderView : UIView
@property (strong, nonatomic) FMFishStoreModel * storeModel;
- (void)reloadData;
@end
