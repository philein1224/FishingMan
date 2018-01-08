//
//  FMPickerChooseMenu.h
//  FishingMan
//
//  Created by zxh on 2017/6/20.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PickerChooseMenuCallback) (NSMutableArray * arrayOfDic);

@interface FMPickerChooseMenu : UIView

@property (copy, nonatomic) PickerChooseMenuCallback callback;

+ (instancetype)shareWithTarget:(id)target
                          array:(NSArray *)array
                       callback:(PickerChooseMenuCallback) callback;

+ (instancetype)shareWithTarget:(id)target
                     wholeArray:(NSArray<NSArray *> *)array   //分组的队列
                     kindTitles:(NSArray *)titles
                       callback:(PickerChooseMenuCallback) callback;

- (void)show;
- (void)dismiss;

@end
