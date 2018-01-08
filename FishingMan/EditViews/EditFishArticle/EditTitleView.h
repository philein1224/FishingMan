//
//  EditTitleView.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/12.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"

@interface EditTitleView : UIView
@property (copy, nonatomic) void (^moreMaterialShowAndHide)(BOOL isShow);
@property (copy, nonatomic) void (^closeKeyboardBlock)();
@property (assign, nonatomic) FMArticleType articleType;

@property (assign, nonatomic) BOOL allItemsShowed;              //所有元素显示

@property (weak, nonatomic) IBOutlet UITextField *articleTitleTextField;   //文章标题

@property (weak, nonatomic) IBOutlet UIButton *fishTimeBtn;     //钓鱼时间
@property (weak, nonatomic) IBOutlet UIButton *fishWaterBtn;    //水域
@property (weak, nonatomic) IBOutlet UIButton *fishFoodBtn;     //鱼饵
@property (weak, nonatomic) IBOutlet UIButton *fishTypeBtn;     //鱼种类

@property (weak, nonatomic) IBOutlet UIButton *fishFuncBtn;     //钓法
@property (weak, nonatomic) IBOutlet UIButton *fishLinesBtn;    //线组
@property (weak, nonatomic) IBOutlet UIButton *fishPoleLengthBtn;//鱼竿长度
@property (weak, nonatomic) IBOutlet UIButton *fishPoleBrandBtn; //鱼竿品牌

//关闭输入框
- (void)closeKeyboard;

@end
