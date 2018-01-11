//
//  CDServerAPIs+FishSite.h
//  FishingMan
//
//  Created by zhangxh on 2017/10/12.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "CDServerAPIs.h"

@interface CDServerAPIs (FishSite)
/**
 发布钓点／钓场
 */
- (NSURLSessionDataTask *)fishSitePublishWithContent:(NSMutableDictionary *)requestDic
                                            Success:(CDHttpSuccess)success
                                            Failure:(CDHttpFailure)failure;

/**
 钓点列表
 */
- (NSURLSessionDataTask *)fishSiteListWithPage:(int)currentPage         //分页
                                       Success:(CDHttpSuccess)success
                                       Failure:(CDHttpFailure)failure;

/**
 钓点详情
 */
- (NSURLSessionDataTask *)fishSiteDetailWithUserId:(NSString *)userId
                                            SiteId:(NSString *)siteId     //钓点id
                                           Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;














@end
