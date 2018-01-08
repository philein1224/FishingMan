//
//  ZXHTool.m
//  ZXHTools
//
//  Created by zhangxh on 2016/10/13.
//  Copyright © 2016年 HongFan. All rights reserved.
//

#import "ZXHTool.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreLocation/CoreLocation.h>

#import "sys/utsname.h"

#include <sys/time.h>
#define CDColorRGB(r,g,b,a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]
#define CDColorHEX(c,a)     CDColorRGB((float)((c&0xFF0000)>>16),(float)((c&0xFF00)>>8),(float)(c&0xFF),a)
#define UIColorFromHex(c)   [UIColor colorWithRed:(((c & 0xFF0000) >> 16))/255.0 green:(((c &0xFF00) >>8))/255.0 blue:((c &0xFF))/255.0 alpha:1.0]

@implementation ZXHTool

#pragma mark 基础判断类公共方法


#pragma mark 计算类公共方法
/**
 *  @author zxh, 16-10-10 17:10:53
 *
 *  返回金额按照银行家算法保留的小数位
 *
 *  @param Price 需要保留小数位的全部值
 *  @param Scale 保留小数位数
 *
 *  @return 最后的值
 */
+ (NSDecimalNumber *)keepDecimalWithPrice:(double)Price numberOfDecimalDigits:(int)Scale
{
    NSDecimalNumber * resultNumber = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",Price]];
    
    if (resultNumber.floatValue > 0 && resultNumber.floatValue <= 0.01) {
        
        resultNumber=[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",0.01]];
    }
    
    NSDecimalNumberHandler * round = [NSDecimalNumberHandler
                                      
                                      decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                      
                                      scale:Scale
                                      
                                      raiseOnExactness:NO
                                      
                                      raiseOnOverflow:NO
                                      
                                      raiseOnUnderflow:NO
                                      
                                      raiseOnDivideByZero:YES];
    
    NSDecimalNumber * resultDecimal = [resultNumber decimalNumberByRoundingAccordingToBehavior:round];
    
    return resultDecimal;
}


#pragma mark 标示类公共方法

/**
 *  @author zxh, 16-10-13 00:10:18
 *
 *  获取网络的运营商
 *
 *  @return string
 */
+ (NSString *)currentNetworkOperators {
    
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    
    CTCarrier *carrier = [info subscriberCellularProvider];
    
    if (carrier == nil) {return @"";}
    
    NSString *code = [carrier mobileNetworkCode];
    
    return code ? code:@"";
}

/**
 *  @author zxh, 16-10-13 00:10:06
 *
 *  获得设备型号
 *
 *  @return string
 */
+ (NSString *)currentDeviceModel {
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
//    if ([CDUtil isEmptyString:deviceString]) {deviceString = @"";}
    
    return deviceString;
}

#pragma mark 数据转换类公共方法

/**
 *  @author zxh, 16-11-16 15:11:58
 *
 *  16进制颜色转换相应的UIColor颜色对象
 *
 *  @param stringToConvert
 *
 *  @return 标准RGB颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    
    return [ZXHTool colorWithHexString:stringToConvert withAlpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert withAlpha:(float)alpha{
    
    if ([stringToConvert hasPrefix:@"#"]) {
        
        stringToConvert = [stringToConvert substringFromIndex:1];
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    
    if (![scanner scanHexInt:&hexNum]) {return nil;}
    
    return CDColorHEX(hexNum, alpha);
}

+ (UIButton *)buttonFrame:(CGRect)frame image:(UIImage *)image highlightImage:(UIImage *)image2 addTarget:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.exclusiveTouch = YES;
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:image2 forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

+ (UIBarButtonItem *)barBackButtonItemWithTitle:(NSString *)title color:(UIColor *)color image:(UIImage *)image addTarget:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 30);
    button.exclusiveTouch = YES;
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button setTitle:title forState:UIControlStateNormal];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 0);
    button.contentEdgeInsets = UIEdgeInsetsMake( 2, -18, 0, 0);
    
    if (color) {
        [button setTitleColor:color forState:UIControlStateNormal];
    }else {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    if(image){
        [button setImage:image forState:UIControlStateNormal];
        [button setImage:image forState:UIControlStateHighlighted];
    }
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (NSString *)stringByTrimmingWhitespaceAndNewline:(NSString *)string {
    
    if ([string isEqual:[NSNull null]] || string == nil) {return @"";}
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (BOOL)isEmptyString:(NSString *)string {
    
    if ([string isEqual:[NSNull null]]) {return YES;}
    if (string == nil || [string isEqualToString:@""]) {return YES;}
    
    NSString *str = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (str == nil || [str isEqualToString:@""]) {return YES;}
    
    return NO;
}

+ (BOOL)isNilNullObject:(id)object {
    
    if([object isKindOfClass:[NSNull class]]) {
        
        return YES;
    }
    if (object == nil) {
        
        return YES;
    }
    
    return NO;
}

+ (NSString *)URLEncodingWithString:(NSString *)string {
    
    if ([ZXHTool isEmptyString:string]) {return @"";}
    
    NSString *urlString = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    urlString = [ZXHTool stringByTrimmingWhitespaceAndNewline:urlString];
    
    if (urlString == nil) {
        
        return [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
    }else {
        
        return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
}


#pragma mark - JSON

+ (id)jsonObjectFromJsonString:(NSString *)jsonString {
    
    NSError *error = nil;
    
    if (jsonString == nil || [jsonString isEqualToString:@""] || [jsonString isEqual:[NSNull null]]) {return nil;}
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(error != nil) return nil;
    return result;
}

+ (NSString *)jsonStringFromObject:(id)jsonObject {
    
    if (jsonObject == nil || [jsonObject isEqual:[NSNull null]]) {return nil;}
    NSError *error =nil;
    NSData *jsonData =[NSJSONSerialization dataWithJSONObject:jsonObject options:kNilOptions error:&error];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark 来自客户端的时间转换成服务器需要的

//NSDate转换成：yyyy/MM/dd
+ (NSString *)dateStringFromDate:(NSDate *)date{
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd"];
    return [formater stringFromDate:date];
}
//NSDate转换成：yyyy/MM/dd-HH:mm:ss
+ (NSString *)dateAndTimeStringFromDate:(NSDate *)date{
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd-HH:mm:ss SSS"];
    return [formater stringFromDate:date];
}
//NSDate转换成：yyyy/MM/dd-HH:mm
+ (NSString *)dateAndTimeToMinuteStringFromDate:(NSDate *)date{
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd-HH:mm"];
    return [formater stringFromDate:date];
}

+ (NSString *)millisecondStringFromNow{
    return [NSString stringWithFormat:@"%ld", (NSInteger)floor([[NSDate date] timeIntervalSince1970] * 1000)];
}
+ (NSString *)millisecondStringFromDate:(NSDate *)date{
    return [NSString stringWithFormat:@"%ld", (NSInteger)floor([date timeIntervalSince1970] * 1000)];
}
+ (NSString *)millisecondStringFromDateString:(NSString *)dateStr; //2017/10/10
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd"];
    NSDate * date = [formater dateFromString:dateStr];
    return [ZXHTool millisecondStringFromDate:date];
}
+ (NSString *)millisecondStringFromDateString2:(NSString *)dateStr; //2017/10/10-HH:mm
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd-HH:mm"];
    NSDate * date = [formater dateFromString:dateStr];
    return [ZXHTool millisecondStringFromDate:date];
}

#pragma mark 来自服务器的时间转换成用户能看明白的

//将时间段转换成表示日期NSDate
+ (NSDate *)dateFromTimeInterval:(long)timeInterval{
    NSDate * dateTime = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return dateTime;
}
//将时间段转换成表示日期字符串
+ (NSString *)dateTimeStringFromTimeInterval:(long)timeInterval{
    NSDate * dateTime = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString * dateTimeStr = [ZXHTool dateAndTimeStringFromDate:dateTime];
    return dateTimeStr;
}
+ (NSString *)compareCurrentTimeWithDate:(NSDate *)compareDate {
    
    NSDate *currentDate = [NSDate date];
    NSTimeInterval  timeInterval = [currentDate timeIntervalSinceDate:compareDate];
    
    //一分钟以内
    if (timeInterval < 60) {return @"刚刚";}
    //一个小时之内
    if(timeInterval < 3600) {return [NSString stringWithFormat:@"%.0f分钟前",timeInterval / 60];}
    //今天
    if(timeInterval < 24 * 3600){return @"今天";}
    //昨天
    if(timeInterval < 2 * 24 * 3600){return @"昨天";}
    //更早些
    NSString *defaultString = [self dateStringFromDate:compareDate];
    return defaultString;
}


/*
//NSDate to NSString
+ (NSString *)dateToString:(NSDate *)date format:(NSString *)formatString {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:formatString];
    [dateFormatter setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]];
    [dateFormatter setLocale:[NSLocale systemLocale]];
    
    return [dateFormatter stringFromDate:date];
}

*/

#pragma mark - 将手机号码转换成前三中四后四的格式
+(BOOL)isPhoneNumber:(NSString *)number{
    
    NSString *phoneRegex=@"1[0123456789]([0-9]){9}";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return  [phonePredicate evaluateWithObject:number];
}

+(NSString *)phoneNumberFormat:(NSString *)number{
    
    if ([ZXHTool isEmptyString:number]) {
        
        return @"";
    }
    
    NSMutableString *changeMobileString = [NSMutableString stringWithString:number];
    
    if ([number length] > 3) {
        
        [changeMobileString insertString:@" " atIndex:3];
    }
    
    if ([number length] > 8) {
        
        [changeMobileString insertString:@" " atIndex:8];
    }
    
    return [NSString stringWithString:changeMobileString];
}

+(NSString *)phoneNumberHiddenFormat:(NSString *)mobile{
    
    if ([ZXHTool isEmptyString:mobile]) {
        
        return @"***";
    }
    
    if (![ZXHTool isPhoneNumber:mobile]) {
        return mobile;
    }
    
    return [mobile stringByReplacingCharactersInRange:NSMakeRange(3, [mobile length] -7) withString:@"****"];
}

+ (double)distanceFromLat1:(double)lat1 Lng1:(double)lng1 ToLat2:(double)lat2 Lng2:(double)lng2{
    
    CLLocation *orig = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];
    
    CLLocation* dist = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];
    
    CLLocationDistance kilometers = [orig distanceFromLocation:dist]/1000;
    
    NSLog(@"距离:%f",kilometers);
    return kilometers;
}

+ (NSString *)distanceStringFromLat1:(double)lat1 Lng1:(double)lng1 ToLat2:(double)lat2 Lng2:(double)lng2{
    
    double distance = [ZXHTool distanceFromLat1:lat1 Lng1:lng1 ToLat2:lat2 Lng2:lng2];
    
    if (distance >= 1.0) {
        CLog(@"%@",[NSString stringWithFormat:@"%dkm",(int)distance]);
        return [NSString stringWithFormat:@"%dkm",(int)distance];
    }
    else{
        CLog(@"%@",[NSString stringWithFormat:@"%dm",(int)(distance*1000)]);
        return [NSString stringWithFormat:@"%dm",(int)(distance*1000)];
    }
}

//NSDictionary 转为json字符串
+ (NSString *)dataToJsonString:(id)object{
    
    NSString *jsonString = nil;
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}
+ (NSArray *)dataConvertFromJsonString:(NSString *)jsonString{
    
    NSData* data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error]; // options:NSJSONReadingAllowFragments
    if (error != nil) return nil;
    return result;
}

#pragma mark 文本段落计算高度
+ (CGFloat)heightWithText:(NSString *)text labelFont:(UIFont *)font labelWidth:(CGFloat)width{
    
    CGFloat height = 0;
    
    if (text.length == 0) {
        height = 0;
    } else {
        
        // 字体
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:18.f]};
        if (font) {
            attribute = @{NSFontAttributeName: font};
        }
        
        // 尺寸
        CGSize retSize = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                           options:
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                        attributes:attribute
                                           context:nil].size;
        
        height = retSize.height;
    }
    
    return height;
}
@end
