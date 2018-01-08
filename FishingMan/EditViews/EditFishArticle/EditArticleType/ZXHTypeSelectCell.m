//
//  ZXHTypeSelectCell.m
//  ZiMaCaiHang
//
//  Created by maoqian on 16/9/6.
//  Copyright © 2016年 fightper. All rights reserved.
//

#import "ZXHTypeSelectCell.h"

@implementation ZXHTypeSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _iconLeftConstant.constant = 10 * ZXHRatioWithReal375;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
