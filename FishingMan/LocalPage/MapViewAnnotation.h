//
//  MapViewAnnotation.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/27.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>  

@interface MapViewAnnotation : NSObject<MKAnnotation , MKMapViewDelegate>
@property (nonatomic, readwrite) int index;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d;
- (id)initWithTitle:(NSString *)ttl Coordinate:(CLLocationCoordinate2D)c2d andIndex:(int)intIndex;

+(MKCoordinateRegion) regionForAnnotations:(NSArray*) annotations ;

@end
