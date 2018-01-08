//
//  FMMultiChooseCell.m
//  FishingMan
//
//  Created by zhangxiaohui on 2017/6/16.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMMultiChooseCell.h"
@interface FMMultiChooseCell ()

@property (weak, nonatomic) IBOutlet UIImageView *selectedIconView;

@end
@implementation FMMultiChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected) {
        self.selectedIconView.image = [UIImage imageNamed:@"choose_selected"];
    }
    else{
        self.selectedIconView.image = [UIImage imageNamed:@"choose_normal"];
    }
}


@end
