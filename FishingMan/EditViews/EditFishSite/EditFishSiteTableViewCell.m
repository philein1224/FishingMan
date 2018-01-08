//
//  EditFishSiteTableViewCell.m
//  FishingMan
//
//  Created by zhangxh on 2017/11/1.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "EditFishSiteTableViewCell.h"

@interface EditFishSiteTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreMaterialContainerHeight;
@property (weak, nonatomic) IBOutlet UIView *moreMaterialContainer;

@end

@implementation EditFishSiteTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.moreMaterialContainerHeight.constant = 180;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)moreMaterialShowOrHideButtonAction:(id)sender {
    
    if(self.moreMaterialContainerHeight.constant == 0){
        self.moreMaterialContainerHeight.constant = 180;
        self.moreMaterialContainer.hidden = NO;
        
        if(self.moreMaterialShowOrHide){
            self.moreMaterialShowOrHide(YES);
        }
    }
    else{
        self.moreMaterialContainerHeight.constant = 0;
        self.moreMaterialContainer.hidden = YES;
        if(self.moreMaterialShowOrHide){
            self.moreMaterialShowOrHide(NO);
        }
    }
}

@end
