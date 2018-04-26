//
//  CDServerAPIs+Friend.h
//  FishingMan
//
//  Created by zhangxh on 2017/10/12.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "CDServerAPIs.h"
/*
 applyFriend       添加好友，(关注)
 deleteFriends     删除好友，(取消关注)
 
 agreeApplyFriends 同意好友添加，
 refuseInvitation  拒绝好友添加
 
 getFriendsList    获取粉丝的列表列表，
 getFriendsList    获取我关注的好友列表，
 
 好友想起信息
 
 */
@interface CDServerAPIs (Friend)

/**
 添加关注、取消关注
 addFollow:YES 添加对用户的关注，NO 取消对用户的关注
 */
- (NSURLSessionDataTask *)friendAddFollow:(BOOL)addFollow
                                 friendId:(long)friendId
                                  Success:(CDHttpSuccess)success
                                  Failure:(CDHttpFailure)failure;

/**
 朋友列表
 currentPage : 分页
 isMyFans : YES粉丝列表／NO我关注的人
 */
- (NSURLSessionDataTask *)friendListWithPage:(int)currentPage
                                    isMyFans:(BOOL)isMyFans
                                     Success:(CDHttpSuccess)success
                                     Failure:(CDHttpFailure)failure;
/**
 获取其他用户基本信息 user/getUserInfoById
 */
- (NSURLSessionDataTask *)requestUserInfoByUserId:(NSString *)friendUserId Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;

@end
