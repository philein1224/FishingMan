//
//  CDServerAPIs+FishSite.m
//  FishingMan
//
//  Created by zhangxh on 2017/10/12.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "CDServerAPIs+FishSite.h"

@implementation CDServerAPIs (FishSite)
/**
 发布钓点／钓场
 */
- (NSURLSessionDataTask *)fishSitePublishWithContent:(NSMutableDictionary *)requestDic
                                             Success:(CDHttpSuccess)success
                                             Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/fishSite/publish";
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

/**
 钓点列表
 */
- (NSURLSessionDataTask *)fishSiteListWithPage:(int)currentPage         //分页
                                            Success:(CDHttpSuccess)success
                                            Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/fishSite/fishSiteList";
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    if(currentPage == 0){
        currentPage = 1;
    }
    [requestDic setObject:[NSNumber numberWithInt:currentPage] forKey:@"currentPage"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

/**
 钓点详情
 */
- (NSURLSessionDataTask *)fishSiteDetailWithSiteId:(NSString *)siteId     //钓点id
                                           Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{

    NSString *APIName = @"/fishSite/fishSiteDetail";
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:siteId forKey:@"siteId"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}
@end
