//
//  FMFavoriteArticleTableViewController.m
//  ZXHTools
//
//  Created by zhangxh on 2016/10/21.
//  Copyright © 2016年 HongFan. All rights reserved.
//

#import "FMFavoriteArticleTableViewController.h"
#import "FishMultiImageCell.h"
#import "FishTwoImageCell.h"
#import "FishSingleImageCell.h"
#import "FishVideoCell.h"
#import "FMArticleDetailViewController.h"

#import "MJRefresh.h"
#import "CDServerAPIs+MainPage.h"
#import "FMArticleModel.h"

@interface FMFavoriteArticleTableViewController ()
{
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL pullingDownward; //向下拉获取最新
@property (assign, nonatomic) int currentPage; //当前加载到第几页
@property (nonatomic, strong) NSMutableArray * articleModelArray; //已经加载的列表数据
@property (assign, nonatomic) int totalCount;  //总共有多少文章
@property (assign, nonatomic) int pageSize;    //每一页有多少条数据

@end

@implementation FMFavoriteArticleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addCustomNavigationBarBackButtonWithImage:ZXHImageName(@"navBackGray")
                                             target:self
                                           selector:@selector(leftAction:)];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FishMultiImageCell" bundle:nil] forCellReuseIdentifier:@"FishMultiImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FishTwoImageCell" bundle:nil] forCellReuseIdentifier:@"FishTwoImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FishSingleImageCell" bundle:nil] forCellReuseIdentifier:@"FishSingleImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FishVideoCell" bundle:nil] forCellReuseIdentifier:@"FishVideoCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //加载列表数据
    [ZXHViewTool addMJRefreshGifHeader:self.tableView selector:@selector(topDownloadListData) target:self];
    [ZXHViewTool addMJRefreshGifFooter:self.tableView selector:@selector(bottomUploadListData) target:self];
    
    //第一次获取
    [self topDownloadListData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//获取评论列表
- (void)topDownloadListData{
    
    if(!IS_LOGIN_WITHOUT_ALERT) return;
    
    _pullingDownward = YES;
    _currentPage = 1;
    [self reloadDataWithPosition:_pullingDownward Page:_currentPage];
}
- (void)bottomUploadListData{
    
    if(!IS_LOGIN_WITHOUT_ALERT) return;
    
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
    [[CDServerAPIs shareAPI] contentFavoriteListWithSourceType:FMSourceArticleType page:currentPage Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        CLog(@"收藏的文章列表 =>>article List = %@", responseObject);
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        
        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
            
                //判断是否继续
            NSDictionary * dataDic = responseObject[@"data"];
            if([ZXHTool isNilNullObject:dataDic] || [ZXHTool isNilNullObject:dataDic[@"result"]]){
                return;
            }
            
            weakself.currentPage = [dataDic[@"currentPage"] intValue];
            weakself.totalCount = [dataDic[@"totalCount"] intValue];
            weakself.pageSize = [dataDic[@"pageSize"] intValue];
            
                //取出获取到的新数据
            NSMutableArray *tempArray = [FMArticleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"result"]];
            
                //下拉获取最新
            if(weakself.pullingDownward){
                
                if(weakself.articleModelArray.count > 0){
                    [weakself.articleModelArray removeAllObjects];
                }
                
                if(tempArray.count > 0){
                    NSArray * array = [weakself dealingWithArticleArray: tempArray];
                    weakself.articleModelArray = [NSMutableArray arrayWithArray:array];
                    
                    [weakself.tableView reloadData];
                }
            }
                //上拉加载更多
            else{
                
                if(tempArray.count > 0){
                    NSArray * array = [weakself dealingWithArticleArray: tempArray];
                    [weakself.articleModelArray addObjectsFromArray:array];
                    
                    [weakself.tableView reloadData];
                }
            }
        }
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        [CDServerAPIs httpDataTask:dataTask error:error.error];
    }];
}

//主要功能是计算cell的高度
- (NSMutableArray *)dealingWithArticleArray:(NSMutableArray *)tempArray{
    
    for (FMArticleModel * model in tempArray) {
        
        NSArray * array = [ZXHTool dataConvertFromJsonString:model.recommends];
        if ([ZXHTool isNilNullObject:array]) {
            model.contentArray = nil;
        }
        else{
            
            for (NSString * contentStr in array) {
                
                if ([contentStr hasPrefix:@"http"]) {
                    
                    model.imageCount = model.imageCount + 1;
                    
                    if(model.imageCount <= 3){
                        
                        if (model.imageCount == 1) {
                            model.pic0 = contentStr;
                        }
                        else if(model.imageCount == 2) {
                            model.pic1 = contentStr;
                        }
                        else if(model.imageCount == 3) {
                            model.pic2 = contentStr;
                            break;
                        }
                    }
                }
            }
            
            model.contentArray = array;
        }
        CLog(@"model.contentArray = %@, %d", model.contentArray, model.imageCount);
    }
    
    return tempArray;
}


- (void)leftAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)rightAction:(id)sender{
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articleModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMArticleModel * articleModel = _articleModelArray[indexPath.row];
    
    if(articleModel.imageCount >= 3){
        return ZXHRatioWithReal375 * 194;
    }
    else if(articleModel.imageCount == 2){
        return ZXHRatioWithReal375 * 194;
    }
    else if(articleModel.imageCount == 1){
        return ZXHRatioWithReal375 * 150;
    }
    else if(articleModel.imageCount == 0){
        return ZXHRatioWithReal375 * 150;
    }
    else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMArticleModel * articleModel = _articleModelArray[indexPath.row];
    
    //图片大于三张的
    if(articleModel.imageCount >= 3){
        
        static NSString *CellIdentifier = @"FishMultiImageCell";
        
        FishMultiImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FishMultiImageCell" owner:nil options:nil] firstObject];
        }
        cell.articleModel = articleModel;
        [cell reloadData];
        
        return cell;
    }
    //图片等于两张的
    else if (articleModel.imageCount == 2){
        
        static NSString *CellIdentifier = @"FishTwoImageCell";
        
        FishTwoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FishTwoImageCell" owner:nil options:nil] firstObject];
        }
        cell.articleModel = articleModel;
        [cell reloadData];
        
        return cell;
    }
    //图片等于一张的
    else if (articleModel.imageCount == 1){
        
        static NSString *CellIdentifier = @"FishSingleImageCell";
        
        FishSingleImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FishSingleImageCell" owner:nil options:nil] firstObject];
        }
        cell.articleModel = articleModel;
        [cell reloadData];
        
        return cell;
        
    }
    //纯文本的
    else if (articleModel.imageCount == 0){
        
        static NSString *CellIdentifier = @"FishSingleImageCell";
        
        FishSingleImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FishSingleImageCell" owner:nil options:nil] firstObject];
        }
        cell.articleModel = articleModel;
        [cell reloadData];
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FMArticleDetailViewController * articleDetailVC = [[FMArticleDetailViewController alloc] initWithNibName:@"FMArticleDetailViewController" bundle:nil];
    
    FMArticleModel * articleModel = _articleModelArray[indexPath.row];
    articleDetailVC.articleModel = articleModel;
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:articleDetailVC animated:YES];
}

@end
