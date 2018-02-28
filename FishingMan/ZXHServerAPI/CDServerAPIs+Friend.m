//
//  CDServerAPIs+Friend.m
//  FishingMan
//
//  Created by zhangxh on 2017/10/12.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "CDServerAPIs+Friend.h"

@implementation CDServerAPIs (Friend)

/**
 添加关注、取消关注
 addFollow:YES 添加对用户的关注，NO 取消对用户的关注
 */
- (NSURLSessionDataTask *)friendAddFollow:(BOOL)addFollow
                                 friendId:(long)friendId
                                  Success:(CDHttpSuccess)success
                                  Failure:(CDHttpFailure)failure{
    NSString *APIName = @"/user/cancelfollow";
    if(addFollow){
        APIName = @"/user/follow";
    }
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:[NSNumber numberWithInteger:friendId] forKey:@"toUserId"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

/**
 朋友列表
 currentPage : 分页
 isMyFans : YES粉丝列表／NO我关注的人
 */
- (NSURLSessionDataTask *)friendListWithPage:(int)currentPage
                                    isMyFans:(BOOL)isMyFans
                                     Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/user/getFollowList";
    if(isMyFans){
        APIName = @"/user/getFansList";
    }
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}


@end
