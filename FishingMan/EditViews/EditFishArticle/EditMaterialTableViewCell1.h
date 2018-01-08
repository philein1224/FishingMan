//
//  EditMaterialTableViewCell.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/12.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditContentModel.h"

@interface EditMaterialTableViewCell : UITableViewCell

- (void)reloadData;

+ (float)cellHeight:(float)height;
@end
