//
//  FMFishSiteTableViewController.m
//  FishingMan
//
//  Created by zhangxh on 2018/1/12.
//  Copyright © 2018年 HongFan. All rights reserved.
//

#import "FMFishSiteTableViewController.h"

//钓点相关
#import "LocalFishSiteTBCell.h"
#import "FMSiteHomepageController.h"
#import "FMFishSiteModel.h"
#import "CDServerAPIs+FishSite.h"
#import "CDServerAPIs+MainPage.h"

#import "MJRefresh.h"
#import "UIScrollView+EmptyDataSet.h"
#import "FMEmptyNotiView.h"

@interface FMFishSiteTableViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) BOOL pullingDownward;   //向下拉获取最新

@property (assign, nonatomic) int currentPage; //当前加载到第几页
@property (nonatomic, strong) NSMutableArray * allSiteModelArray; //已经加载的列表数据
@property (assign, nonatomic) int totalCount;  //总共有多少条
@property (assign, nonatomic) int pageSize;    //每一页有多少条数据

@end

@implementation FMFishSiteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
        //tableView顶部位置多出64像素的处理
    self.automaticallyAdjustsScrollViewInsets = NO;
    
        //初始化数组
    self.allSiteModelArray = [NSMutableArray array];
        //钓点
    [self.tableView registerNib:[UINib nibWithNibName:@"LocalFishSiteTBCell" bundle:nil] forCellReuseIdentifier:@"LocalFishSiteTBCell"];
    
    /*** 列表去掉多余cell ***/
    UIView *tempfooterview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZXHScreenWidth, 0)];
    self.tableView.tableFooterView = tempfooterview;
    
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
    
    FMLoginUser * user = [FMLoginUser getCacheUserInfo];
    
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] articleFavoritListWithSourceType:FMSourceFishSiteType userId:[user.userId longLongValue] page:currentPage Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        CLog(@"收藏的钓点列表 =>>article List = %@", responseObject);
        
        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
            
                //判断是否继续
            NSDictionary * dataDic = responseObject[@"data"];
            if([ZXHTool isNilNullObject:dataDic] || [ZXHTool isNilNullObject:dataDic[@"result"]]){
                [weakself.tableView.mj_header endRefreshing];
                [weakself.tableView.mj_footer endRefreshing];
                return;
            }
            
            weakself.currentPage = [dataDic[@"currentPage"] intValue];
            weakself.totalCount = [dataDic[@"totalCount"] intValue];
            weakself.pageSize = [dataDic[@"pageSize"] intValue];
            
                //取出获取到的新数据
            NSMutableArray *tempArray = [FMFishSiteModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"result"]];
            
                //下拉获取最新
            if(weakself.pullingDownward){
                
                [weakself.tableView.mj_header endRefreshing];
                
                if(weakself.allSiteModelArray.count > 0){
                    [weakself.allSiteModelArray removeAllObjects];
                }
                
                if(tempArray.count > 0){
                    
                    if(weakself.allSiteModelArray.count > 0){
                        [weakself.allSiteModelArray removeAllObjects];
                    }
                    
                    weakself.allSiteModelArray = [NSMutableArray arrayWithArray:tempArray];
                    
                    [weakself.tableView reloadData];
                }
            }
                //上拉加载更多
            else{
                
                [weakself.tableView.mj_footer endRefreshing];
                
                if(tempArray.count > 0){
                    
                    [weakself.allSiteModelArray addObjectsFromArray:tempArray];
                    
                    [weakself.tableView reloadData];
                }
            }
        }
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        [CDServerAPIs httpDataTask:dataTask error:error.error];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allSiteModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LocalFishSiteTBCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LocalFishSiteTBCell" forIndexPath:indexPath];
    cell.model = [self.allSiteModelArray objectAtIndex:indexPath.row];
    [cell reloadData];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMSiteHomepageController * siteHP = [[FMSiteHomepageController alloc] initWithNibName:@"FMSiteHomepageController" bundle:nil];
    siteHP.fishSiteModel = [self.allSiteModelArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:siteHP animated:YES];
}

@end
