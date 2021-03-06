//
//  CDServerAPIs+MainPage.m
//  FishingMan
//
//  Created by zhangxh on 2017/10/11.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "CDServerAPIs+MainPage.h"

@implementation CDServerAPIs (MainPage)

#pragma mark 发现-文章大分类
#warning 发现-文章大分类入口列表
/**
 发现-文章大分类入口列表
 */
- (NSURLSessionDataTask *)articleTypesInfoListSuccess:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/articalFish/getArticleTypeInfo";
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

#pragma mark 文章相关
/**
 文章发布
 */
- (NSURLSessionDataTask *)articlePublishWithType:(int)articleType ArticleContent:(NSMutableDictionary *)articleDic Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/articalFish/publish";
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic addEntriesFromDictionary:articleDic];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}
/**
 文章列表
 FMArticleType articleType（⚠️-1表示首页主列表）
 int currentPage 当前第几页
 */
- (NSURLSessionDataTask *)articleListWithType:(int)articleType currentPage:(int)currentPage Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/articalFish/articalFishList";
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    //tyep==-1表示首页文章列表查询
    if (articleType != -1) {
        [requestDic setObject:[NSNumber numberWithInteger:articleType] forKey:@"articleType"];  //文章类型
    }
    //当前第n页
    [requestDic setObject:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}
/**
 文章详情
 */
- (NSURLSessionDataTask *)articleDetailWithArticleId:(NSInteger)articleId Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/articalFish/articalFishDetail";
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:[NSNumber numberWithInteger:articleId] forKey:@"articalId"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}


#pragma mark 单个用户发表的文章列表
/**
 单个用户发表的文章列表
 string userId
 int currentPage 当前第几页
 */
- (NSURLSessionDataTask *)articleListWithUserId:(NSString *)userId currentPage:(int)currentPage Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/articalFish/articalFishList";
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    [requestDic setObject:userId forKey:@"userId"];
    
        //当前第n页
    [requestDic setObject:[NSNumber numberWithInteger:currentPage] forKey:@"currentPage"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

#pragma mark 文章/钓点/渔具店收藏相关接口

/**
 取消收藏/收藏
 //id:收藏ID
 //type:类型1\钓点2\渔具店3
 //userId:用户的suerId
 */
- (NSURLSessionDataTask *)contentFavorite:(BOOL)colected sourceId:(long)sourceId type:(FMSourceType)type Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/collection/collection";
    if (colected) {
        APIName = @"/collection/cancelCollection";
    }
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:[NSNumber numberWithInteger:sourceId] forKey:@"sourceId"];
    [requestDic setObject:[NSNumber numberWithInteger:type] forKey:@"sourceType"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}
/**
 文章收藏列表
 */
- (NSURLSessionDataTask *)contentFavoriteListWithSourceType:(FMSourceType)type page:(NSInteger)page Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/collection/list";
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:[NSNumber numberWithInteger:type] forKey:@"sourceType"];
    [requestDic setObject:[NSNumber numberWithInteger:page] forKey:@"currentPage"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

#pragma mark 文章、钓点、渔具店的点赞
/**
 点赞
 //type:文章1\钓点2\渔具店3
 //like YES=喜欢， NO=不喜欢
 */
- (NSURLSessionDataTask *)contentLikeWithSourceId:(long)sourceId
                                       SourceType:(int)sourceType
                                             Like:(BOOL)isLiked
                                          Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/like/del";
    if (isLiked) {
        APIName = @"/like/like";
    }
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:[NSNumber numberWithInteger:sourceId] forKey:@"sourceId"];
    [requestDic setObject:[NSNumber numberWithInteger:sourceType] forKey:@"sourceType"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

#pragma mark 公共-评论相关接口

/**
 发表评论
 */
- (NSURLSessionDataTask *)commentPublishWithSourceId:(long)sourceId sourceType:(FMSourceType)sourceType Content:(NSString *)content FromUserId:(long)fromUserId FromUserName:(NSString *)fromUserName FromUserAvtor:(NSString *)fromUserAvtor ToUserId:(long)toUserId Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/comment/publish";
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    [requestDic setObject:[NSNumber numberWithLong:sourceId] forKey:@"topicId"];//文章ID
    [requestDic setObject:[NSNumber numberWithInteger:sourceType] forKey:@"topicType"];//文章类型
    [requestDic setObject:content forKey:@"content"];
    
    [requestDic setObject:[NSNumber numberWithLong:fromUserId] forKey:@"fromUserId"];
    if (![ZXHTool isEmptyString:fromUserName]) {
        [requestDic setObject:fromUserName forKey:@"fromUserName"];
    }
    if (![ZXHTool isEmptyString:fromUserAvtor]) {
        [requestDic setObject:fromUserAvtor forKey:@"fromUserAvtor"];
    }
    
    if(toUserId != 0){
        [requestDic setObject:[NSNumber numberWithLong:toUserId] forKey:@"toUserId"];
        if (![ZXHTool isEmptyString:fromUserName]) {
            [requestDic setObject:fromUserName forKey:@"toUserName"];
        }
        if (![ZXHTool isEmptyString:fromUserAvtor]) {
            [requestDic setObject:fromUserAvtor forKey:@"toUserAvtor"];
        }
    }
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

/**
 获取评论列表
 */
- (NSURLSessionDataTask *)commentListWithSourceId:(long)sourceId sourceType:(FMSourceType)sourceType currentPage:(long)currentPage Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/comment/getComment";
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    [requestDic setObject:[NSNumber numberWithInteger:sourceType] forKey:@"type"];//资源类型
    [requestDic setObject:[NSNumber numberWithLong:sourceId] forKey:@"topicId"];//资源id
    [requestDic setObject:[NSNumber numberWithLong:currentPage] forKey:@"currentPage"];//当前页
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

/**
 删除评论
 */
- (NSURLSessionDataTask *)commentDeleteWithCommentId:(long)commentId Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/comment/del";
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:[NSNumber numberWithLong:commentId] forKey:@"id"];//评论id
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

#pragma mark 公共 - 文章举报／钓点渔具店反馈 相关接口（文章、钓点、渔具店）
/**
 文章举报／钓点渔具店反馈
 */
- (NSURLSessionDataTask *)reportAndFeedbackWithReportType:(FMReportType)reportType
                                                 sourceId:(long)sourceId
                                               sourceType:(FMSourceType)sourceType
                                                  Success:(CDHttpSuccess)success
                                                  Failure:(CDHttpFailure)failure{
    
    NSString *APIName = @"/report/report";
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    [requestDic setObject:[NSNumber numberWithLong:reportType] forKey:@"reportType"];
    [requestDic setObject:[NSNumber numberWithLong:sourceId] forKey:@"sourceId"];
    [requestDic setObject:[NSNumber numberWithLong:sourceType] forKey:@"sourceType"];
    
    return [self POSTRequestOperationWithURL:CD_SERVER_ADDRESS(APIName) connectNumber:APIName parameters:requestDic success:success failure:failure];
}

@end
