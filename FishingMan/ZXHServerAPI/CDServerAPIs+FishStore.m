//
//  CDServerAPIs+FishStore.m
//  FishingMan
//
//  Created by zhangxh on 2017/10/12.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "CDServerAPIs+FishStore.h"

@implementation CDServerAPIs (FishStore)
/**
 发布鱼具店
 */
//- (NSURLSessionDataTask *)fishStorePublishWithUserId:(long)userId              //用户的id
/*
 Title:(NSString *)title         //钓点标题
 Introduce:(NSString *)introduce     //文字介绍
 Content:(NSString *)content       //文字介绍（待保留一个）
 Pic0:(NSString *)pic0
 Pic1:(NSString *)pic1
 Pic2:(NSString *)pic2
 Pic3:(NSString *)pic3
 longitude:(NSString *)lng           //经度
 Latitude:(NSString *)lat           //纬度
 LocationAddress:(NSString *)address       //详细地址
 PublisherType:(int)publisherType        //发布者类型（0官方、1钓友、2店主）
 */

- (NSURLSessionDataTask *)fishStorePublishWithContent:(NSMutableDictionary *)requestDic
                                              Success:(CDHttpSuccess)success
                                              Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/fishShop/publish";
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

/**
 渔具店列表
 */
- (NSURLSessionDataTask *)fishStoreListWithPage:(int)currentPage         //分页
                                             Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/fishShop/fishShopList";
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    if(currentPage == 0){
        currentPage = 1;
    }
    [requestDic setObject:[NSNumber numberWithInt:currentPage] forKey:@"currentPage"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

/**
 渔具店详情
 */
- (NSURLSessionDataTask *)fishStoreDetailWithUserId:(long)userId
                                             SiteId:(NSString *)siteId     //渔具店id
                                            Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/fishShop/fishShopDetail";
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    [requestDic setObject:siteId forKey:@"siteId"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

@end
