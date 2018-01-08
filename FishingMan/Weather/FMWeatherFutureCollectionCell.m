//
//  FMWeatherFutureCollectionCell.m
//  ZiMaCaiHang
//
//  Created by fightper on 16/6/7.
//  Copyright © 2016年 fightper. All rights reserved.
//

#import "FMWeatherFutureCollectionCell.h"
#import "UIImageView+WebCache.h"

@interface FMWeatherFutureCollectionCell ()

@property (weak, nonatomic) IBOutlet UIView      *bottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel     *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *temperatureLabel;
@end

@implementation FMWeatherFutureCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImageView.image = nil;
    self.nameLabel.text = @"";
}

- (void)dealloc {
    
    NSLog(@"---[%@ dealloc]---",NSStringFromClass(self.class));
}

- (void)reloadData {
    
    if (self.isHiddenLine) {
        
        [self.bottomLine setHidden:YES];
    }
    else{
        
        [self.bottomLine setHidden:NO];
    }
    
    //    self.nameLabel.textColor = [CDUtil colorWithHexString:self.weatherFutureModel.titleColor];
    
    //温度
    self.temperatureLabel.text = self.weatherFutureModel.temperature;
    
    //星期几
    self.nameLabel.text = self.weatherFutureModel.week;
    
    //天气图标
    NSString * weatherName = [NSString stringWithFormat:@"5天气_%@_%@", @"白天", self.weatherFutureModel.dayTime];
    if([[self getTheTimeBucket] isEqualToString:@"night"]){
        weatherName = [NSString stringWithFormat:@"5天气_%@_%@", @"夜晚", self.weatherFutureModel.night];
    }
    [self.iconImageView sd_setImageWithURL:nil placeholderImage:ZXHImageName(weatherName) options:SDWebImageRetryFailed];
}


//获取时间段
-(NSString *)getTheTimeBucket{
    //    NSDate * currentDate = [self getNowDateFromatAnDate:[NSDate date]];
    
    /*** 早上五点---下午6点都属于白天 ***/
    
    NSDate * currentDate = [NSDate date];
    if (//[currentDate compare:[self getCustomDateWithHour:0]] == NSOrderedDescending &&
        [currentDate compare:[self getCustomDateWithHour:5]] == NSOrderedDescending &&
        [currentDate compare:[self getCustomDateWithHour:9]] == NSOrderedAscending)
    {
        //@"早上好";
        return @"dayTime";
    }
    else if ([currentDate compare:[self getCustomDateWithHour:9]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:11]] == NSOrderedAscending)
    {
        //@"上午好";
        return @"dayTime";
    }
    else if ([currentDate compare:[self getCustomDateWithHour:11]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:13]] == NSOrderedAscending)
    {
        //@"中午好";
        return @"dayTime";
    }
    else if ([currentDate compare:[self getCustomDateWithHour:13]] == NSOrderedDescending && [currentDate compare:[self getCustomDateWithHour:18]] == NSOrderedAscending)
    {
        //@"下午好";
        return @"dayTime";
    }
    else
    {
        //@"晚上好"
        return @"night";
    }
}


//将时间点转化成日历形式
- (NSDate *)getCustomDateWithHour:(NSInteger)hour{
    //获取当前时间
    NSDate * destinationDateNow = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    currentComps = [currentCalendar components:unitFlags fromDate:destinationDateNow];
    
    //设置当前的时间点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    return [resultCalendar dateFromComponents:resultComps];
}


@end
