//
//  ZXHTypeSelectView.h
//  ZiMaCaiHang
//
//  Created by maoqian on 16/8/17.
//  Copyright © 2016年 fightper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXHTypeSelectView : UIView

// YES 已经显示 NO 没有显示
@property (assign, nonatomic) BOOL isDisplay;

// 背景
@property (nonatomic,strong) UIView *backGroundView;

//选择的回调
@property (copy, nonatomic) void(^selectTypeCallback)(NSInteger type, NSString * typeName);

// 当前选中的
@property (assign, nonatomic) NSInteger currentIndex;

+ (void)show:(NSMutableArray *)allTypeArray withSelected:(NSInteger)selectedType callback:(void(^)(NSInteger type, NSString * typeName))callback;
@end
