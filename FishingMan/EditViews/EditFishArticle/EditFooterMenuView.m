//
//  EditFooterMenuView.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/12.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "EditFooterMenuView.h"

@interface EditFooterMenuView()

@property (weak, nonatomic) IBOutlet UIButton *modifyButton;   //调整按钮

@end

@implementation EditFooterMenuView

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)updateStatus:(NSInteger)count editing:(BOOL)isEditing{
    
    if(count == 0){
        self.modifyButton.selected = NO;
        self.modifyButton.hidden = YES;
    }
    else{
        self.modifyButton.selected = isEditing;
        self.modifyButton.hidden = NO;
    }
}

-(IBAction)editMenuAction:(UIButton *)button{
    
    if(button == self.modifyButton){
        
        button.selected = button.selected ? NO : YES;
    }
    
    if(self.editFooterMenuViewCallback){
        self.editFooterMenuViewCallback(button.tag);
    }
}

@end
