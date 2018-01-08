//
//  ZXHTool.h
//  ZXHTools
//
//  Created by zhangxh on 2016/10/13.
//  Copyright © 2016年 HongFan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZXHTool : NSObject

#pragma mark 计算类公共方法

//银行家算法
+ (NSDecimalNumber *)keepDecimalWithPrice:(double)Price numberOfDecimalDigits:(int)Scale;

#pragma mark 标示类公共方法

//获取网络的运营商
+ (NSString *)currentNetworkOperators;

#pragma mark 数据转换类公共方法

//16进制颜色转换相应的UIColor颜色对象
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert withAlpha:(float)alpha;

#pragma mark 视图类公共方法
//快速创建一个按钮
+ (UIButton *)buttonFrame:(CGRect)frame
                    image:(UIImage *)image
           highlightImage:(UIImage *)image2
                addTarget:(id)target
                   action:(SEL)action;
//导航栏返回按钮
+ (UIBarButtonItem *)barBackButtonItemWithTitle:(NSString *)title
                                          color:(UIColor *)color
                                          image:(UIImage *)image
                                      addTarget:(id)target
                                         action:(SEL)action;

#pragma mark 数据检测类公共方法
+ (NSString *)stringByTrimmingWhitespaceAndNewline:(NSString *)string;
//如果为空,返回YES
+ (BOOL)isEmptyString:(NSString *)string;
//如果为空对象,返回YES
+ (BOOL)isNilNullObject:(id)object;
+ (NSString *)URLEncodingWithString:(NSString *)string;

//JSON转换
+ (id)jsonObjectFromJsonString:(NSString *)jsonString;
+ (NSString *)jsonStringFromObject:(id)jsonObject;


//NSDate转换成：yyyy/MM/dd
+ (NSString *)dateStringFromDate:(NSDate *)date;
//NSDate转换成：yyyy/MM/dd-HH:mm:ss
+ (NSString *)dateAndTimeStringFromDate:(NSDate *)date;
//NSDate转换成：yyyy/MM/dd-HH:mm
+ (NSString *)dateAndTimeToMinuteStringFromDate:(NSDate *)date;
+ (NSString *)millisecondStringFromNow;   //从1970年1月1日开始的时间间隔【毫秒】
+ (NSString *)millisecondStringFromDate:(NSDate *)date;
+ (NSString *)millisecondStringFromDateString:(NSString *)dateStr; //格式 2017/10/10
+ (NSString *)millisecondStringFromDateString2:(NSString *)dateStr; //格式 2017/10/10-HH:mm

#pragma mark 来自服务器的时间转换成用户能看明白的

//将时间段转换成表示日期NSDate
+ (NSDate *)dateFromTimeInterval:(long)timeInterval;
//将时间段转换成表示日期字符串
+ (NSString *)dateTimeStringFromTimeInterval:(long)timeInterval;
+ (NSString *)compareCurrentTimeWithDate:(NSDate *)compareDate;


//初判断是否是手机号码
+(BOOL)isPhoneNumber:(NSString *)number;
//手机号码转换 136 8060 758
+(NSString *)phoneNumberFormat:(NSString *)number;
+(NSString *)phoneNumberHiddenFormat:(NSString *)number;

//两个经纬度之间的距离（单位：千米）
+ (double)distanceFromLat1:(double)lat1 Lng1:(double)lng1 ToLat2:(double)lat2 Lng2:(double)lng2;
+ (NSString *)distanceStringFromLat1:(double)lat1 Lng1:(double)lng1 ToLat2:(double)lat2 Lng2:(double)lng2;

//NSDictionary 转为json字符串
+ (NSString*)dataToJsonString:(id)object;
+ (NSArray *)dataConvertFromJsonString:(NSString *)jsonString;

#pragma mark 文本段落计算高度
+ (CGFloat)heightWithText:(NSString *)text labelFont:(UIFont *)font labelWidth:(CGFloat)width;
@end
