//
//  FMCommonMainPageBaseCell.h
//  FishingMan
//
//  Created by zhangxh on 2017/5/17.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, FMTargetPageEventType) {
    FMTargetPageEventTypeDefault          = 0,    //其他[默认]
    FMTargetPageEventTypeCall             = 1,    //电话呼叫
    FMTargetPageEventTypeAddress          = 2,    //地址
    FMTargetPageEventTypeMap              = 3,    //地图
};

@interface FMCommonMainPageBaseCell : UITableViewCell

@property (copy, nonatomic) void (^callback)(FMTargetPageEventType eventType);

- (UIViewController*)getFirstViewController;
@end
