//
//  FMSingleArticleTypeTableViewController.h
//  ZXHTools
//
//  Created by zhangxh on 2016/10/21.
//  Copyright © 2016年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FMSingleArticleTypeTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableDictionary * typeObjInfo;   //只用于发现文章分类，其他情况下不传值
@end
