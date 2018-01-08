//
//  UIButtonForMapPin.h
//  FishingMan
//
//  Created by zhangxh on 2017/5/22.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface UIButtonForMapPin : UIButton

@property (assign, nonatomic)CLLocationCoordinate2D pinLocation;

@end
