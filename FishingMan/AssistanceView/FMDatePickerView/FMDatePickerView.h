//
//  FMDatePickerView.h
//  FishingMan
//
//  Created by zxh on 2017/6/20.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FMDatePickerViewCallback) (NSDate * date);

@interface FMDatePickerView : UIView

@property (copy, nonatomic) FMDatePickerViewCallback callback;

+ (instancetype)shareWithTarget:(id)target mode:(UIDatePickerMode)mode callback:(FMDatePickerViewCallback) callback;
- (void)show;
- (void)dismiss;

@end
