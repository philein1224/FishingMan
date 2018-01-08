//
//  CDTopAlertView.h
//  ZiMaCaiHang
//
//  Created by fightper on 16/6/21.
//  Copyright © 2016年 fightper. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, TopAlertViewType) {
    TopAlertViewWarningType = 1,     //警告提醒
    TopAlertViewSuccessType = 2,     //成功提醒
    TopAlertViewFailedType = 3       //错误提醒
};

@interface CDTopAlertView : UIView

+ (CDTopAlertView *)showMsg:(NSString *)message bgColor:(UIColor *)color;

+ (CDTopAlertView *)showMsg:(NSString *)message bgColor:(UIColor *)color andImage:(UIImage *)img;

+ (CDTopAlertView *)showMsg:(NSString *)message isErrorState:(BOOL)isError;

//在present,或者其他非VC视图的情况下使用
+ (CDTopAlertView *)showMsg:(NSString *)message isErrorState:(BOOL)isError inView:(UIView *)view;

//张小辉 自定义方法
+ (CDTopAlertView *)showMsg:(NSString *)message alertType:(TopAlertViewType)type;
@end
