//
//  FMCommonMainPageBaseCell.m
//  FishingMan
//
//  Created by zhangxh on 2017/5/17.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMCommonMainPageBaseCell.h"

@implementation FMCommonMainPageBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIViewController*)getFirstViewController{
    
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    
    return nil;
}

@end
