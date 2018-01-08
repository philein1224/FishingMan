//
//  EditContentTableViewCell.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/12.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditContentModel.h"

typedef NS_OPTIONS(NSInteger, EditContentType) {
    EditContentTypeText           = 0,
    EditContentTypeImage          = 1,
    EditContentTypeVideo          = 2,
};

@interface EditContentTableViewCell : UITableViewCell

@property (strong, nonatomic) EditContentModel *editModel;

- (void)reloadData;

+ (float)cellHeight:(float)height;

- (BOOL)closeKeyboard;

@end
