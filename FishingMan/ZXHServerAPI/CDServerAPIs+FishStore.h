//
//  CDServerAPIs+FishStore.h
//  FishingMan
//
//  Created by zhangxh on 2017/10/12.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "CDServerAPIs.h"

@interface CDServerAPIs (FishStore)

/**
 发布鱼具店
 */
- (NSURLSessionDataTask *)fishStorePublishWithContent:(NSMutableDictionary *)requestDic
                                              Success:(CDHttpSuccess)success
                                              Failure:(CDHttpFailure)failure;

/**
 渔具店列表
 */
- (NSURLSessionDataTask *)fishStoreListWithPage:(int)currentPage         //分页
                                             Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;

/**
 渔具店详情
 */
- (NSURLSessionDataTask *)fishStoreDetailWithUserId:(NSString *)userId
                                             SiteId:(NSString *)siteId     //渔具店id
                                            Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;

@end
