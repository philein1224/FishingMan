//
//  MineAccountUpdateViewController.h
//  FishingMan
//
//  Created by zhangxh on 2017/5/21.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineAccountUpdateViewController : UIViewController

@property (copy, nonatomic) void (^updateCallback)(BOOL updated);

@end
