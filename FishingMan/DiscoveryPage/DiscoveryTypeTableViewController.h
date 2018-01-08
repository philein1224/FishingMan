//
//  DiscoveryTypeTableViewController.h
//  ZXHTools
//
//  Created by zhangxh on 2016/10/21.
//  Copyright © 2016年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoveryTypeTableViewController : UITableViewController
@property (nonatomic, assign) BOOL hideNavigationWhenPopOut;
@property (nonatomic, strong) NSMutableDictionary * typeObjInfo;
@end
