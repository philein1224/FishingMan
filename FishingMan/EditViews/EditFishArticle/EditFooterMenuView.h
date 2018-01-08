//
//  EditFooterMenuView.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/12.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditFooterMenuView : UIView
@property (copy, nonatomic) void (^editFooterMenuViewCallback)(NSInteger type);

- (void)updateStatus:(NSInteger)count editing:(BOOL)isEditing;

@end
