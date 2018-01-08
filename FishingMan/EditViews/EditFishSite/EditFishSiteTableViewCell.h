//
//  EditFishSiteTableViewCell.h
//  FishingMan
//
//  Created by zhangxh on 2017/11/1.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditFishSiteTableViewCell : UITableViewCell

@property (copy, nonatomic) void (^moreMaterialShowOrHide)(BOOL isShow);

@end
