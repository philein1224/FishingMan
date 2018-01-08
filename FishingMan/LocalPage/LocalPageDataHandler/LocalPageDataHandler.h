//
//  LocalPageDataHandler.h
//  FishingMan
//
//  Created by zhangxh on 2017/6/15.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalPageDataHandler : NSObject

/**
 *  @author zxh, 17-06-19 14:50:00
 *
 *  获取列表数据
 *
 */
+ (void)APIForFishSiteListWithPage:(int)page Callback:(void (^)(NSMutableArray * array)) listBlock;
@end
