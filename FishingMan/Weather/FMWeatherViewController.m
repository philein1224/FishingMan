//
//  FMWeatherViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/3/15.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMWeatherViewController.h"
#import "FMWeatherFutureCollectionCell.h"
#import "UIImageView+WebCache.h"
//天气接口
#import <MobAPI/MobAPI.h>
#import <MOBFoundation/MOBFoundation.h>
//天气数据模型
#import "FMWeatherDataModel.h"
#import "FMWeatherFutureModel.h"
//文本
#import <CoreText/CoreText.h>
#import "NSString+WPAttributedMarkup.h"
//定位和气压地理
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <CoreMotion/CoreMotion.h>

#define kRowHeight  66.0

#define kWeatherBGImageView   @"key_Weather_BGImageView"

@interface FMWeatherViewController ()<CLLocationManagerDelegate,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>


@property (weak, nonatomic) IBOutlet UILabel     *localNameLabel;        //所在地名称

@property (weak, nonatomic) IBOutlet UILabel     *CurrentTemperatureLabel;//当前温度：18
@property (weak, nonatomic) IBOutlet UILabel     *weatherLabel;           //天气：°C晴

@property (weak, nonatomic) IBOutlet UIImageView *humidityIcon;           //湿度图标
@property (weak, nonatomic) IBOutlet UILabel     *humidityLabel;          //湿度

@property (weak, nonatomic) IBOutlet UIImageView *windIcon;               //风力图标
@property (weak, nonatomic) IBOutlet UILabel     *windLabel;              //风力

@property (weak, nonatomic) IBOutlet UIImageView *pollutionIndexIcon;     //污染指数图标
@property (weak, nonatomic) IBOutlet UILabel     *pollutionIndexLabel;    //污染指数

@property (weak, nonatomic) IBOutlet UIImageView *airPresureIcon;         //气压图标
@property (weak, nonatomic) IBOutlet UILabel     *airPresureLabel;        //气压

@property (weak, nonatomic) IBOutlet UIImageView *altitudeIcon;           //海拔图标
@property (weak, nonatomic) IBOutlet UILabel     *altitudeLabel;          //海拔

@property (weak, nonatomic) IBOutlet UIImageView *sunRiseSetIcon;         //日出日落图标
@property (weak, nonatomic) IBOutlet UILabel     *sunRiseSetLabel;        //日出日落

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView; //菊花指示器
@property (weak, nonatomic) IBOutlet UILabel     *indicatorLabel;            //天气更新提示

@property (weak, nonatomic) IBOutlet UIView      *moreFutureView;         //更多天气的容器
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;    //更多未来天气

@property (weak, nonatomic) IBOutlet UIImageView *weatherBGImageView;    //图片可变换背景
@property (strong, nonatomic) FMWeatherDataModel *weatherDataModel;      //天气预报信息
@property (nonatomic, strong) CLLocationManager  *locationManager;
@property (nonatomic, strong) CMAltimeter        *altimeter;

@end

@implementation FMWeatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    //self.navigationTitle = @"天气";
    [self addCustomNavigationBarBackButtonWithImage:ZXHImageName(@"navBackWhite")
                                             target:self
                                           selector:@selector(backButtonClicked)];
    
    //裁边【也可在xib中设置】，防止背景超出边界，返回时影响交互体验
    self.view.clipsToBounds = YES;
    
    //collectionView
    self.moreFutureView.hidden = YES;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FMWeatherFutureCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    //初始化默认温度
    self.CurrentTemperatureLabel.attributedText = [self updateTemperatureLabelWithValue:@"18"];
    
    //初始加载上次保存的图片默认图片
    if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:kWeatherBGImageView]) {
        
        self.weatherBGImageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:kWeatherBGImageView];
    }
    
    //气压
    self.airPresureLabel.text = [NSString stringWithFormat:@"气压：100kPa"];
    
    //海拔
    self.altitudeLabel.text = [NSString stringWithFormat:@"海拔：500米"];
    
    //获取城市列表
//    [self searchCityList];
    //请求天气预报数据
    [self searchWeather];
}

- (NSAttributedString *)updateTemperatureLabelWithValue:(NSString *)temperature{
    
    NSDictionary * textStyle = @{@"small":[UIFont fontWithName:@"HelveticaNeue-Light" size:12.0],
                                 @"large":[UIFont fontWithName:@"HelveticaNeue-Ultralight" size:88.0],
                                 @"whiteColor": [UIColor whiteColor]};
    
    NSString * noteStr = [NSString stringWithFormat:@"<large><whiteColor>%@°</whiteColor></large>", temperature];
    
    return [noteStr attributedStringWithStyleBook:textStyle];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //获取当前地区气压和海拔
    [self getAirPressureAndAltitude];
    
    //获取当前地区的海拔（通过地理定位方式获取）
    [self getMapAltitude];
}

- (void)backButtonClicked {
    //退出时导航栏显示不要动画
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  @author zxh, 17-03-29 23:03:19
 *
 *  根据天气数据重新加载页面
 */
- (void)reloadServerDataForAllDate:(BOOL)allDate{
    
    NSString * urlString = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490812207171&di=616768eb0230e8cfbec43e97bf539fa0&imgtype=0&src=http%3A%2F%2Fa.hiphotos.baidu.com%2Flvpics%2Fh%3D800%2Fsign%3D0e85bed92d381f30811980a999004c67%2Feaf81a4c510fd9f94780d988202dd42a2934a4b8.jpg";
    
    if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:kWeatherBGImageView]) {
        
        self.weatherBGImageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:kWeatherBGImageView];
    }
    else {
        
        ZXH_WEAK_SELF
        [ZXHViewTool setImageView:_weatherBGImageView WithImageURL:[NSURL URLWithString:urlString] AndPlaceHolderName:@"MainPage_WeatherBG" CompletedBlock:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            [UIView transitionWithView:weakself.weatherBGImageView
                              duration:1.5
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                
                                [weakself.weatherBGImageView setImage:image];
                                weakself.weatherBGImageView.alpha = 1.0;
                            } completion:NULL];
            
            if (!error) {
                
                weakself.weatherBGImageView.contentMode = UIViewContentModeScaleToFill;
            }
            
            if (image && !error) {
                
                [[SDImageCache sharedImageCache] storeImage:image forKey:kWeatherBGImageView toDisk:YES completion:^{
                    
                }];
            }
            
            if (error) {
                
                NSLog(@"Weather BG image reload error:%@",error);
            }
            
        }];
    }
    
    //当前温度度数
    if(![ZXHTool isEmptyString:self.weatherDataModel.temperature]){
        
        NSString *temperatureNumber = [self.weatherDataModel.temperature stringByReplacingOccurrencesOfString:@"℃" withString:@""];
        temperatureNumber = [temperatureNumber stringByReplacingOccurrencesOfString:@"°C" withString:@""];
        self.CurrentTemperatureLabel.attributedText = [self updateTemperatureLabelWithValue:temperatureNumber];
    }
    //当前天气
    self.weatherLabel.text = self.weatherDataModel.weather;
    
    //风力风向
    self.windLabel.text = self.weatherDataModel.wind;
    //如果外层当前没有风力风向的值，去列表第一项的风力
    if([ZXHTool isEmptyString:self.weatherDataModel.wind]){
        FMWeatherFutureModel * futureModel = self.weatherDataModel.future[0];
        self.windLabel.text = futureModel.wind;
    }
    
    if(allDate == NO){
        return;
    }
    
    //当前地址
    self.localNameLabel.text = [NSString stringWithFormat:@"%@%@", self.weatherDataModel.city, self.weatherDataModel.distrct];
    
    //湿度
    self.humidityLabel.text = self.weatherDataModel.humidity;
    
    //污染指数
    self.pollutionIndexLabel.text = [NSString stringWithFormat:@"%@ %@", self.weatherDataModel.pollutionIndex, self.weatherDataModel.airCondition];
    
    //日出和日落
    if([[self getTheTimeBucket] isEqualToString:@"dayTime"]){
        
        //日落时间
        self.sunRiseSetIcon.image = ZXHImageName(@"天气_日落icon");
        self.sunRiseSetLabel.text = [NSString stringWithFormat:@"日落：%@", self.weatherDataModel.sunset];
    }
    else{
        //日出时间
        self.sunRiseSetIcon.image = ZXHImageName(@"天气_日出icon");
        self.sunRiseSetLabel.text = [NSString stringWithFormat:@"日出：%@", self.weatherDataModel.sunrise];
    }
    
    //未来日期天气数据
    [self.collectionView reloadData];
    
    //未来天气栏显示
    self.moreFutureView.hidden = NO;
    self.moreFutureView.alpha = 0.f;
    [UIView animateWithDuration:0.5 animations:^{
        self.moreFutureView.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (finished) {
        }
    }];
}

- (void)reloadDataAffterChangingWeekWeatherData:(FMWeatherFutureModel *) futureData{
    
    //1、当前温度
    //1.1、去空格
    NSString * weather = [ZXHTool stringByTrimmingWhitespaceAndNewline:futureData.temperature];
    //1.2、分数组
    NSArray *array = [weather componentsSeparatedByString:@"/"];
    
    NSString *temperatureNum1 = [array[0] stringByReplacingOccurrencesOfString:@"℃" withString:@""];
    temperatureNum1 = [temperatureNum1 stringByReplacingOccurrencesOfString:@"°C" withString:@""];
    
    NSString *temperatureNum2 = [array[1] stringByReplacingOccurrencesOfString:@"℃" withString:@""];
    temperatureNum2 = [temperatureNum2 stringByReplacingOccurrencesOfString:@"°C" withString:@""];
    
    double averageTemperature = ([temperatureNum1 doubleValue] + [temperatureNum2 doubleValue])/2;
    
    self.CurrentTemperatureLabel.attributedText = [self updateTemperatureLabelWithValue:[NSString stringWithFormat:@"%.0f", averageTemperature]];
    
    //2、天气
    if([[self getTheTimeBucket] isEqualToString:@"dayTime"]){
        
        //日间天气
        self.weatherLabel.text = futureData.dayTime;
    }
    else{
        
        //晚间天气
        self.weatherLabel.text = futureData.night;
    }
    
    //3、风力风向
    self.windLabel.text = futureData.wind;
}

#pragma mark   获取时间

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


#pragma mark 查询城市列表
- (void)searchCityList{
    
    [self sendRequest:[MOBAWeatherRequest citiesRequest]];
}
#pragma mark 查询天气
- (void)searchWeather{
    
//    [self sendRequest:[MOBAWeatherRequest searchRequestByCity:@"通州" province:@"北京"]];
    [self sendRequest:[MOBAWeatherRequest searchRequestByCity:@"双流" province:@"四川省"]];
}

#pragma mark - Private
- (void)waitLoading:(BOOL)flag{
    
    self.indicatorView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin |
    UIViewAutoresizingFlexibleTopMargin |
    UIViewAutoresizingFlexibleRightMargin;
    
    [self.indicatorView startAnimating];
    
    self.indicatorView.hidden = !flag;
}

- (void)showLog:(NSString *)log{
    
    [self waitLoading:NO];
}

/**
 *  Api 返回信息处理
 *
 *  @param response
 */
- (void)resultWithResponse:(MOBAResponse *)response{
    
    NSString *logContent = nil;
    if (response.error)
    {
        logContent = [NSString stringWithFormat:@"request error!\n%@", response.error];
        NSLog(@"%@", logContent);
    }
    else
    {
        
        logContent = [NSString stringWithFormat:@"request success!\n%@", [MOBFJson jsonStringFromObject:response.responder]];
        
        NSString *jsonStr = [MOBFJson jsonStringFromObject:response.responder[@"result"][0]];
        
        CLog(@"天气预报成功：%@", logContent);
        self.weatherDataModel = [FMWeatherDataModel mj_objectWithKeyValues:jsonStr];
        
        CLog(@"天气预报未来数据：%ld", self.weatherDataModel.future.count);
        
        //第1个未来天，
        ((FMWeatherFutureModel * )(self.weatherDataModel.future[0])).night = self.weatherDataModel.weather;
        ((FMWeatherFutureModel * )(self.weatherDataModel.future[0])).dayTime = self.weatherDataModel.weather;
        
        [self reloadServerDataForAllDate:YES];
    }
    /*
     {"msg":"success",
      "result":[{"coldIndex":"易发期",
                 "week":"周二",
                 "province":"北京",
                 "time":"22:20",
                 "temperature":"10℃",
                 "washIndex":"非常适宜",
                 "future":[
     {"night":"晴","temperature":"3°C","week":"今天","wind":"南风 小于3级","date":"2017-03-28"},
     {"night":"多云","dayTime":"晴","temperature":"20°C / 6°C","week":"星期三","wind":"南风 小于3级","date":"2017-03-29"},
     {"night":"多云","dayTime":"多云","temperature":"16°C / 4°C","week":"星期四","wind":"东南风 小于3级","date":"2017-03-30"},
     {"night":"晴","dayTime":"晴","temperature":"17°C / 4°C","week":"星期五","wind":"北风 小于3级","date":"2017-03-31"},
     {"night":"多云","dayTime":"晴","temperature":"20°C / 5°C","week":"星期六","wind":"南风 小于3级","date":"2017-04-01"},
     {"night":"晴","dayTime":"多云","temperature":"23°C / 6°C","week":"星期日","wind":"北风 小于3级","date":"2017-04-02"},
     {"night":"晴","dayTime":"晴","temperature":"24°C / 8°C","week":"星期一","wind":"南风 小于3级","date":"2017-04-03"},
     {"night":"阴天","dayTime":"少云","temperature":"21°C / 10°C","week":"星期二","wind":"东南风 3级","date":"2017-04-04"},
     {"night":"阴天","dayTime":"局部多云","temperature":"19°C / 10°C","week":"星期三","wind":"东南风 3级","date":"2017-04-05"},
     {"night":"阴天","dayTime":"阴天","temperature":"17°C / 8°C","week":"星期四","wind":"东北偏北风 3级","date":"2017-04-06"}
     ],
                  "pollutionIndex":"88",
                  "updateTime":"20170328223409",
                  "exerciseIndex":"不适宜",
                  "city":"北京",
                  "dressingIndex":"毛衣类",
                  "distrct":"通州",
                  "date":"2017-03-28",
                  "humidity":"湿度：53%",
                  "sunset":"18:33",
                  "wind":"南风2级",
                  "weather":"晴",
                  "airCondition":"良",
                  "sunrise":"06:04"}],
     "retCode":"200"}
     */
    [self showLog:logContent];
}

#pragma mark - Private
- (void)sendRequest:(MOBARequest *)request{
    [self waitLoading:YES];
    
    ZXH_WEAK_SELF
    
    [MobAPI sendRequest:request onResult:^(MOBAResponse *response)
     {
         //目前请求一次，返回三次数据
         [weakself resultWithResponse:response];
     }];
}

#pragma mark 获取本地的气压和海拔
-(void)getAirPressureAndAltitude{
    
    _altimeter = [[CMAltimeter alloc]init];
    
    //检测设备是否支持气压计
    if (![CMAltimeter isRelativeAltitudeAvailable]) {
        NSLog(@"不支持气压监测");
        return;
    }
    //开始监测
    ZXH_WEAK_SELF
    [self.altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData * _Nullable altitudeData, NSError * _Nullable error) {
        
        // 实时刷新数据
        [weakself updateLabels:altitudeData];
    }];
}

- (void)updateLabels:(CMAltitudeData *)altitudeData {
    
    NSLog(@"原始气压：%@", altitudeData.pressure);
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    NSString *pressure = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:altitudeData.pressure]];
    
//    NSLog(@"转换后气压：%@", qiYa);
    self.airPresureLabel.text = [NSString stringWithFormat:@"气压：%@kPa", pressure];
}

#pragma mark 地理信息
- (void)getMapAltitude{
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.delegate = self;
    //    [_locationManager requestAlwaysAuthorization];
    
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
}
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation{
    
    float altitude = newLocation.altitude;
    self.altitudeLabel.text = [NSString stringWithFormat:@"海拔：%.0f米", floor(altitude)];
//    NSLog(@"海拔高度为：%.2fm",altitude);
//    NSLog(@"垂直精度为：%.2fm",newLocation.verticalAccuracy);
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    //用于纠偏的点
    CLLocation *newLocation = [locations lastObject];
    
    NSLog(@"A 精度和纬度 %f, %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    NSLog(@"newLocation:%@",newLocation);
    
    if (newLocation) {
        
        //获取海拔
        float altitude = newLocation.altitude;
        self.altitudeLabel.text = [NSString stringWithFormat:@"海拔：%.0f米", floor(altitude)];
        
        NSDictionary *dic = @{@"latitude":@(newLocation.coordinate.latitude),@"longitude":@(newLocation.coordinate.longitude)};
        
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"FM_User_Coordinate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        if (newLocation.horizontalAccuracy > 0 && newLocation.horizontalAccuracy < 10000) {
            
            [self.locationManager stopUpdatingLocation];
        }
        
        
        CLGeocoder *geocoder=[[CLGeocoder alloc]init];
        
        
        //        //经度
        //        NSString *longitude = @"113.23";
        //        //纬度
        //        NSString *latitude = @"23.16";
        //
        //        //创建位置
        //        CLLocation *location=[[CLLocation alloc]initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
        
        
        //反地理编码
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            //判断是否有错误或者placemarks是否为空
            if (error !=nil || placemarks.count==0) {
                NSLog(@"%@",error);
                return ;
            }
            for (CLPlacemark *placemark in placemarks) {
                //详细地址
                NSLog(@"详细地址1：%@",placemark.name);
                NSLog(@"详细地址2：%@",placemark.thoroughfare);
                NSLog(@"详细地址3：%@",placemark.subThoroughfare);
                NSLog(@"详细地址4：%@",placemark.locality);
                NSLog(@"详细地址5：%@",placemark.subLocality);
                NSLog(@"详细地址6：%@",placemark.subLocality);
                NSLog(@"详细地址7：%@",placemark.administrativeArea);
                NSLog(@"详细地址8：%@",placemark.subAdministrativeArea);
                NSLog(@"详细地址9：%@",placemark.postalCode);
                NSLog(@"详细地址10：%@",placemark.ISOcountryCode);
                NSLog(@"详细地址11：%@",placemark.country);
                NSLog(@"详细地址12：%@",placemark.inlandWater);
                NSLog(@"详细地址13：%@",placemark.ocean);
                NSLog(@"详细地址14：%@",placemark.areasOfInterest);
                
                NSLog(@"详细地址15：%@",placemark.addressDictionary);
                
                /*
                 http://lbsyun.baidu.com/index.php?title=webapi/guide/webservice-placeapi
                 */
                /*
                 2017-06-15 00:14:20.828 FishingMan[2158:847354] 详细地址1：麓山大道二段630号
                 2017-06-15 00:14:20.828 FishingMan[2158:847354] 详细地址2：麓山大道二段
                 2017-06-15 00:14:20.828 FishingMan[2158:847354] 详细地址3：630号
                 2017-06-15 00:14:20.828 FishingMan[2158:847354] 详细地址4：成都市
                 2017-06-15 00:14:20.828 FishingMan[2158:847354] 详细地址5：双流县
                 2017-06-15 00:14:20.828 FishingMan[2158:847354] 详细地址6：双流县
                 2017-06-15 00:14:20.828 FishingMan[2158:847354] 详细地址7：四川省
                 2017-06-15 00:14:20.828 FishingMan[2158:847354] 详细地址8：(null)
                 2017-06-15 00:14:20.830 FishingMan[2158:847354] 详细地址9：(null)
                 2017-06-15 00:14:20.830 FishingMan[2158:847354] 详细地址10：CN
                 2017-06-15 00:14:20.830 FishingMan[2158:847354] 详细地址11：中国
                 2017-06-15 00:14:20.831 FishingMan[2158:847354] 详细地址12：(null)
                 2017-06-15 00:14:20.831 FishingMan[2158:847354] 详细地址13：(null)
                 2017-06-15 00:14:20.831 FishingMan[2158:847354] 详细地址14：(null)
                 
                 {
                 City = "成都市";
                 Country = "中国";
                 CountryCode = CN;
                 FormattedAddressLines =     (
                 "中国四川省成都市双流县华阳镇街道麓山大道二段630号"
                 );
                 Name = "麓山大道二段630号";
                 State = "四川省";
                 Street = "麓山大道二段630号";
                 SubLocality = "双流县";
                 SubThoroughfare = "630号";
                 Thoroughfare = "麓山大道二段";
                 }
                 
                 */
            }
            
        }];
    }
}
-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error {
    NSLog(@"error.userInfo：%@\nerror.domain：%@",error.userInfo,error.domain);
}


#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.weatherDataModel.future.count > 6 ? 6:self.weatherDataModel.future.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FMWeatherFutureCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(indexPath.row == 0){
        
        FMWeatherFutureModel * futureData = self.weatherDataModel.future[0];
        NSString * lowWeather = [ZXHTool stringByTrimmingWhitespaceAndNewline:futureData.temperature];
        NSArray *array = [lowWeather componentsSeparatedByString:@"/"];
        NSString *temperatureNum1 = [array.lastObject stringByReplacingOccurrencesOfString:@"℃" withString:@""];
        temperatureNum1 = [temperatureNum1 stringByReplacingOccurrencesOfString:@"°C" withString:@""];
        double lowTemperature = [temperatureNum1 doubleValue];
        
        NSString *averageTemperatureStr = [self.weatherDataModel.temperature stringByReplacingOccurrencesOfString:@"℃" withString:@""];
        averageTemperatureStr = [averageTemperatureStr stringByReplacingOccurrencesOfString:@"°C" withString:@""];
        double highTemperature = [averageTemperatureStr doubleValue] * 2 - lowTemperature;
        
        futureData.temperature = [NSString stringWithFormat:@"%0.f°C / %.0f°C",highTemperature,lowTemperature];
    }
    
    cell.weatherFutureModel = self.weatherDataModel.future[indexPath.row];
    [cell reloadData];
    
    [cell.selectedBackgroundView setBackgroundColor:[UIColor greenColor]];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.row+1) % 6 == 0) {
        
        return CGSizeMake(ZXHScreenWidth - (floor(ZXHScreenWidth / 6.0)) * 5, kRowHeight);
    }else {
        
        return CGSizeMake(floor(ZXHScreenWidth / 6.0), kRowHeight);
    }
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0f;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0f;
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        [self reloadServerDataForAllDate:NO];
    }
    else{
        [self reloadDataAffterChangingWeekWeatherData:self.weatherDataModel.future[indexPath.row]];
    }
    
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    //选中之后的cell变颜色
    [self updateCellStatus:cell selected:YES];
}
//取消选中操作
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self updateCellStatus:cell selected:NO];
}

// 改变cell的背景颜色
-(void)updateCellStatus:(UICollectionViewCell *)cell selected:(BOOL)selected
{
    cell.backgroundColor = selected ? [UIColor lightGrayColor]:[UIColor whiteColor];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s", __FUNCTION__);
    return YES;
}



@end
