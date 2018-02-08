//
//  FMMapLocationViewController.m
//  FishingMan
//
//  Created by zhangxh on 2018/1/23.
//  Copyright © 2018年 HongFan. All rights reserved.
//

#import "FMMapLocationViewController.h"
#import <MapKit/MKMapView.h>
#import "MapViewAnnotation.h"
#import <CoreLocation/CoreLocation.h>

@interface FMMapLocationViewController ()

@property (weak, nonatomic) IBOutlet UILabel     * naviTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel     * addressInfoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * customNaviHeight;
@property (weak, nonatomic) IBOutlet MKMapView   *mapView;
@property (assign, nonatomic) CLLocationCoordinate2D coordinateCenter;
@property (strong, nonatomic) MapViewAnnotation * annotationCenter;
@end

@implementation FMMapLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark 地理附加方法
- (void)makeUpNewCenterWithCoordinate2D:(CLLocationCoordinate2D)coordinate{
    
    if (_annotationCenter) {
        [self.mapView removeAnnotation:_annotationCenter];
    }
    
    _coordinateCenter = coordinate;
    
    NSString *titleStr = @"反编译地址";
    _annotationCenter = [[MapViewAnnotation alloc] initWithTitle:titleStr Coordinate:_coordinateCenter andIndex:0];
    [self.mapView addAnnotation:_annotationCenter];
    
    CLLocation * cll = [[CLLocation alloc] initWithLatitude:_coordinateCenter.latitude longitude:_coordinateCenter.longitude];
    [self ahhahah:cll];
}

- (void)ahhahah:(CLLocation *)newLocation {
    
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
        //反地理编码
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            //判断是否有错误或者placemarks是否为空
        if (error !=nil || placemarks.count==0) {
            NSLog(@"hahahah %@",error);
            return ;
        }
        for (CLPlacemark *placemark in placemarks) {
                //详细地址
            NSLog(@"详细地址1：%@",placemark.name);
            NSLog(@"详细地址2：%@",placemark.thoroughfare);
            NSLog(@"详细地址3：%@",placemark.subThoroughfare);
            NSLog(@"详细地址4：%@",placemark.locality);
            NSLog(@"详细地址5：%@",placemark.subLocality);
            NSLog(@"详细地址6：%@",placemark.administrativeArea);
            NSLog(@"详细地址7：%@",placemark.subAdministrativeArea);
            NSLog(@"详细地址8：%@",placemark.postalCode);
            NSLog(@"详细地址9：%@",placemark.ISOcountryCode);
            NSLog(@"详细地址10：%@",placemark.country);
            NSLog(@"详细地址11：%@",placemark.inlandWater);
            NSLog(@"详细地址12：%@",placemark.ocean);
            
            NSLog(@"详细地址14：%@",placemark.areasOfInterest);
            NSLog(@"详细地址15：%@",placemark.addressDictionary);
            /*
             详细地址15：{
             City = "成都市";
             Country = "中国";
             CountryCode = CN;
             FormattedAddressLines =     (
             "中国四川省成都市双流县梓州大道二段"
             );
             Name = "梓州大道二段";
             State = "四川省";
             Street = "梓州大道二段";
             SubLocality = "双流县";
             Thoroughfare = "梓州大道二段";
             */
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

- (void)fetchNearbyInfo:(CLLocationDegrees )latitude andT:(CLLocationDegrees )longitude{
    
    CLLocationCoordinate2D location=CLLocationCoordinate2DMake(latitude, longitude);
    
    MKCoordinateRegion region=MKCoordinateRegionMakeWithDistance(location, 1 ,1 );
    
    MKLocalSearchRequest *requst = [[MKLocalSearchRequest alloc] init];
    requst.region = region;
    requst.naturalLanguageQuery = @"building"; //想要的信息
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:requst];
//    [self.dataRrray removeAllObjects];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        if (!error) {
            
            for (MKMapItem *map in response.mapItems) {
                NSLog(@"所有的推荐周边名称 = %@",map.name);
            }
//            [self.dataRrray addObjectsFromArray:response.mapItems];
//            [self.tableView reloadData];
                //
            }
        else
            {
                //
            }
    }];
}

#pragma mark 地图代理
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    
    MKCoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center= centerCoordinate;
    
    NSLog(@" regionDidChangeAnimated %f,%f",centerCoordinate.latitude, centerCoordinate.longitude);
    
    NSLog(@" mapView.centerCoordinate: %f,%f",mapView.centerCoordinate.latitude, mapView.centerCoordinate.longitude);
    
    [self makeUpNewCenterWithCoordinate2D:mapView.centerCoordinate];
}
- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation{
    
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [map dequeueReusableAnnotationViewWithIdentifier: @"restMap"];
    if (pin == nil) {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"restMap"];
    }
    else{
        pin.annotation = annotation;
    }
    
    pin.image = [UIImage imageNamed:@"temp.png"];
    pin.pinColor = MKPinAnnotationColorGreen;
    
    pin.animatesDrop = NO;
    pin.canShowCallout = YES;
    
    //详细
    UIView *iv =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    iv.backgroundColor = [UIColor greenColor];
    pin.detailCalloutAccessoryView = iv;
    
//        //left AccessoryView
//    UIButtonForMapPin *leftBtn = [UIButtonForMapPin buttonWithType:UIButtonTypeCustom];
//    leftBtn.frame = CGRectMake(0, 0, 50, 50);
//    [leftBtn setTitle:@"导航" forState:UIControlStateNormal];
//    [leftBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
//    leftBtn.pinLocation = pin.annotation.coordinate;
//    [leftBtn addTarget:self action:@selector(openNavigation:) forControlEvents:UIControlEventTouchUpInside];
//    pin.leftCalloutAccessoryView = leftBtn;
    
        //right AccessoryView
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    MapViewAnnotation *temp = (MapViewAnnotation *)pin.annotation;
    rightBtn.tag = temp.index;
    pin.rightCalloutAccessoryView = rightBtn;
    [rightBtn addTarget:self action:@selector(openDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    return pin;
}



#pragma mark 非地图的操作
- (IBAction)closeButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  @author zxh, 17-11-22 11:05:00
 *
 *  初始化自定义状态风格，并兼容iPhoneX
 */
- (void)setUpNaviStyle{
    
        //1、⚠️默认隐藏系统导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];

        //2、动态naviBar的高度
    if(CDSafeAreaNavBarHeight == 88.0){
        self.customNaviHeight.constant = CDSafeAreaNavBarHeight;
    }
    
        //3、设置标题
    _naviTitleLabel.text = @"定位";
}

@end
