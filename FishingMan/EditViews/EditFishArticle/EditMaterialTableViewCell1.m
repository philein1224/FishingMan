//
//  EditMaterialTableViewCell.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/12.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "EditMaterialTableViewCell1.h"

@interface EditMaterialTableViewCell()
{
    float cellHeight;
}

@end

@implementation EditMaterialTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}
+ (float)cellHeight:(float)height{
    
    return 557;
}
- (void)reloadData{
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
