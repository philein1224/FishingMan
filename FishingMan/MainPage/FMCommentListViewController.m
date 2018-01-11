//
//  FMCommentListViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/20.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMCommentListViewController.h"
#import "FMCommentListCell.h"
#import "FMArticleModel.h"
#import "FMArticleCommentModel.h"
#import "CDServerAPIs+MainPage.h"
#import "MJRefresh.h"
#import "FMCommentEditView.h"

@interface FMCommentListViewController ()

@property (assign, nonatomic) BOOL pullingDownward; //向下拉获取最新
@property (assign, nonatomic) int currentPage;
@property (nonatomic, strong) NSMutableArray * commentModelArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) int totalCount;
@property (assign, nonatomic) int pageSize;

@end

@implementation FMCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FMCommentListCell" bundle:nil]
         forCellReuseIdentifier:@"FMCommentListCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 121;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //加载列表数据
    [ZXHViewTool addMJRefreshGifHeader:self.tableView selector:@selector(topDownloadListData) target:self];
    [ZXHViewTool addMJRefreshGifFooter:self.tableView selector:@selector(bottomUploadListData) target:self];
    
    //第一次获取
    [self topDownloadListData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//获取评论列表
- (void)topDownloadListData{
    _pullingDownward = YES;
    _currentPage = 1;
    
    [self reloadDataWithPosition:_pullingDownward Page:_currentPage];
}
- (void)bottomUploadListData{
    
    //总数不够一页时，不进行加载更多
    //总数 <= 当前页数能包含的最大数据量
    if(self.totalCount <= self.currentPage * self.pageSize){
        [self.tableView.mj_footer endRefreshing];
        return;
    }
    
    _pullingDownward = NO;
    _currentPage = _currentPage + 1;
    
    [self reloadDataWithPosition:_pullingDownward Page:_currentPage];
}

- (void)reloadDataWithPosition:(BOOL)downward Page:(int)currentPage{
    
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] commentListWithSourceId:_articleModel.ID sourceType:FMSourceArticleType currentPage:_currentPage Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        CLog(@"requestCommentList = %@", responseObject);
        
        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
            
            //判断是否继续
            NSDictionary * dataDic = responseObject[@"data"];
            if([ZXHTool isNilNullObject:dataDic]){
                return;
            }
            
            if([ZXHTool isNilNullObject:dataDic[@"result"]]){
                return;
            }
            
            weakself.currentPage = [dataDic[@"currentPage"] intValue];
            weakself.totalCount = [dataDic[@"totalCount"] intValue];
            weakself.pageSize = [dataDic[@"pageSize"] intValue];
            
            //取出获取到的新数据
            NSMutableArray *tempArray = [FMArticleCommentModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"result"]];
            
            //下拉获取最新
            if(weakself.pullingDownward){
                
                [weakself.tableView.mj_header endRefreshing];
                
                if(weakself.commentModelArray.count > 0){
                    [weakself.commentModelArray removeAllObjects];
                }
                
                if(tempArray.count > 0){
                    NSArray * array = [weakself dealingWithArticleArray: tempArray];
                    weakself.commentModelArray = [NSMutableArray arrayWithArray:array];
                    
                    [weakself.tableView reloadData];
                }
            }
            //上拉加载更多
            else{
                
                [weakself.tableView.mj_footer endRefreshing];
                
                if(tempArray.count > 0){
                    NSArray * array = [weakself dealingWithArticleArray: tempArray];
                    [weakself.commentModelArray addObjectsFromArray:array];
                    
                    [weakself.tableView reloadData];
                }
            }
        }
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        [CDServerAPIs httpDataTask:dataTask error:error.error];
    }];
}

//主要功能是计算cell的高度
- (NSMutableArray *)dealingWithArticleArray:(NSMutableArray *)array{
    
    for (FMArticleCommentModel * model in array) {
        
        if(model.ID % 2 == 1){
            model.toContent = @"tips:由于模型直接继承自NSObject,创建的时候只包含了Fundation框架,所以添加CGFloat类型的属性的时候会报错,这时候只要把fundation改成UIKit就可以了(UIKit内部也包含了Fundation).";
        }
        else{
            model.toContent = @"";
        }
    }
    
    return array;
    
//    currentPage = 1;
//    endIndex = 20;
//    firstPage = 1;
//    lastPage = 1;
//    nextPage = 1;
//    pageCount = 1;
//    pageSize = 20;
//    previousPage = 1;
//    startIndex = 0;
//    totalCount = 4;
//    unit = "\U6761";
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentModelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"FMCommentListCell";
    
    FMCommentListCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FMCommentListCell" owner:nil options:nil] firstObject];
    }
    
    cell.commentModel = [self.commentModelArray objectAtIndex:indexPath.row];
    [cell reloadData];
    
    ZXH_WEAK_SELF
    cell.actionBlock = ^(CommentActionType type, FMArticleCommentModel * info) {
        
        CLog(@"info.fromUserName => %@", info.fromUserName);
        switch (type) {
            case CommentActionTypeOpenUserPage:
            {
            }
                break;
            case CommentActionTypePraise:
            {
            }
                break;
            case CommentActionTypeReplay:
            {
                if(weakself.replyActionBlock){
                    weakself.replyActionBlock(info);
                }
            }
                break;
            default:
                break;
        }
    };
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//        FMCommentListCell * cell = (FMCommentListCell *)[tableView cellForRowAtIndexPath:indexPath];
}


#pragma mark ----------------评论点赞

- (void)sendComment:(NSString *)content{
    
    if(!IS_LOGIN_WITH_ALERT) {
        return;
    }
    
#warning ToUserId
    
    FMLoginUser * user = [FMLoginUser getCacheUserInfo];
    [[CDServerAPIs shareAPI] commentPublishWithSourceId:_articleModel.ID
                                             sourceType:FMSourceArticleType
                                                Content:content
                                             FromUserId:[user.userId longLongValue]
                                           FromUserName:user.nickName
                                          FromUserAvtor:user.avatarUrl
                                               ToUserId:18
                                                Success:^(NSURLSessionDataTask *dataTask, id responseObject)
     {
         if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
             
             [CDTopAlertView showMsg:@"发送成功" alertType:TopAlertViewSuccessType];
         }
         else{
             [CDTopAlertView showMsg:@"发送失败" alertType:TopAlertViewFailedType];
         }
     }
                                                 Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error)
     {
         [CDServerAPIs httpDataTask:dataTask error:error.error];
         [CDTopAlertView showMsg:@"发送失败" alertType:TopAlertViewFailedType];
     }];
}


@end
