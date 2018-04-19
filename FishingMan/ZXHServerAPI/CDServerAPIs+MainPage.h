//
//  CDServerAPIs+MainPage.h
//  FishingMan
//
//  Created by zhangxh on 2017/10/11.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "CDServerAPIs.h"

@interface CDServerAPIs (MainPage)

#pragma mark 发现-文章大分类
/**
 发现-文章大分类入口列表
 */
- (NSURLSessionDataTask *)articleTypesInfoListSuccess:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;

#pragma mark 文章
/**
 文章发布
 FMArticleType articleType
 */
- (NSURLSessionDataTask *)articlePublishWithType:(int)articleType ArticleContent:(NSMutableDictionary *)articleDic Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;
/**
 文章列表
 FMArticleType articleType（⚠️-1表示首页主列表）
 int currentPage 当前第几页
 */
- (NSURLSessionDataTask *)articleListWithType:(int)articleType currentPage:(int)currentPage Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;
/**
 文章详情
 */
- (NSURLSessionDataTask *)articleDetailWithArticleId:(NSInteger)articleId Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;

#pragma mark 公共 - 收藏相关接口（文章、钓点、渔具店）

/**
 取消收藏/收藏
 //id:收藏ID
 //type:文章1\钓点2\渔具店3
 //userId:用户的suerId
 */
- (NSURLSessionDataTask *)articleFavorit:(BOOL)colected sourceId:(long)sourceId type:(FMSourceType)type userId:(long)userId Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;
/**
 收藏列表
 */
- (NSURLSessionDataTask *)articleFavoritListWithSourceType:(FMSourceType)type userId:(long)userId page:(NSInteger)page Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;

#pragma mark 公共 - 点赞相关接口（文章、钓点、渔具店）

/**
 点赞
 //type:类型1\钓点2\渔具店3
 //like YES=喜欢， NO=不喜欢
 */
- (NSURLSessionDataTask *)contentLikeWithSourceId:(long)sourceId
                                       SourceType:(int)type
                                             Like:(BOOL)like
                                          Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;


#pragma mark 公共 - 评论相关接口（文章、钓点、渔具店）

/**
 发表评论
 */
//- (NSURLSessionDataTask *)commentPublishWithArticleId:(long)topicId ArticleType:(int)topicType Content:(NSString *)content FromUserId:(long)fromUserId FromUserName:(NSString *)fromUserName FromUserAvtor:(NSString *)fromUserAvtor  ToUserId:(long)ToUserId Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;

- (NSURLSessionDataTask *)commentPublishWithSourceId:(long)sourceId sourceType:(FMSourceType)sourceType Content:(NSString *)content FromUserId:(long)fromUserId FromUserName:(NSString *)fromUserName FromUserAvtor:(NSString *)fromUserAvtor  ToUserId:(long)ToUserId Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;

/**
 获取评论列表
 */
- (NSURLSessionDataTask *)commentListWithSourceId:(long)sourceId sourceType:(FMSourceType)sourceType currentPage:(long)currentPage Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;

/**
 删除评论
 */
- (NSURLSessionDataTask *)commentDeleteWithCommentId:(long)commentId Success:(CDHttpSuccess)success Failure:(CDHttpFailure)failure;


#pragma mark 公共 - 文章举报／钓点渔具店反馈 相关接口（文章、钓点、渔具店）
/**
 文章／钓点／渔具店的举报
 */
- (NSURLSessionDataTask *)reportAndFeedbackWithReportType:(FMReportType)reportType   //举报的类型
                                                 sourceId:(long)sourceId             //举报实体的id
                                               sourceType:(FMSourceType)sourceType   //举报的实体类型【文章／钓点／渔具店】
                                                  Success:(CDHttpSuccess)success
                                                  Failure:(CDHttpFailure)failure;














@end
