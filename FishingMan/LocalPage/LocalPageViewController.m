//
//  LocalPageViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/3/18.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "LocalPageViewController.h"
#import <MapKit/MKMapView.h>

#import "LocalFishSiteTBCell.h"
#import "LocalFishStoreTBCell.h"
#import "LocalFishUserTBCell.h"

#import "FMUserHomepageController.h"
#import "FMSiteHomepageController.h"
#import "FMStoreHomepageController.h"

#import <CoreLocation/CoreLocation.h>

#import <MapKit/MKUserLocation.h>
#import <MapKit/MKAnnotation.h>
#import <MapKit/MKPinAnnotationView.h>

#import "CheckInstalledMapAPP.h"
#import "LocationChange.h"
#import "LocIsBaidu.h"

#import "MapViewAnnotation.h"

#import "UIButtonForMapPin.h"

#import "CDServerAPIs+FishSite.h"
#import "CDServerAPIs+FishStore.h"
//#import "CDServerAPIs+FishFriend.h"

#import "FMFishSiteModel.h"
#import "FMFishStoreModel.h"

#import "MJRefresh.h"

#import "LocalPageDataHandler.h"

#import "UIScrollView+EmptyDataSet.h"
#import "FMEmptyNotiView.h"


#define ISIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)
#define ISIOS6 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=6)

typedef NS_ENUM(NSInteger, FishManLocalType) {
    FishManLocalFishSiteType,
    FishManLocalFishStoreType,
    FishManLocalFishUserType,
    FishManLocalDefaultType
};

@interface LocalPageViewController ()<MKMapViewDelegate, CLLocationManagerDelegate, UIActionSheetDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
{
    FishManLocalType fishManLocalCurrentType;
    
    //图钉📌
    NSMutableArray *arrSiteAnnotations;
    NSMutableArray *arrStoreAnnotations;
    NSMutableArray *arrUserAnnotations;
}

//来自服务器元数据对象
@property (strong, nonatomic) NSMutableArray * allSiteModelArray;   //所有地点
@property (strong, nonatomic) NSMutableArray * allStoreModelArray;  //所有商店
@property (strong, nonatomic) NSMutableArray * allUserModelArray;   //所有用户

@property (weak, nonatomic) IBOutlet UISegmentedControl *topSegmentedControl;    //顶部选择器菜单
@property (nonatomic, strong) CLLocationManager  *locationManager;
@property (strong, nonatomic) UIButton           *rightButton;      //翻转触发按钮
@property (weak, nonatomic) IBOutlet UIView      *flipView;         //翻转容器
@property (weak, nonatomic) IBOutlet MKMapView   *mapView;          //地图
@property (weak, nonatomic) IBOutlet UIView      *backContainerView;//背部列表容器
@property (weak, nonatomic) IBOutlet UITableView *tableView;        //列表视图

//列表和地图模式的切换
@property (nonatomic, assign) BOOL goingToListView;

//导航目的地2d,百度
@property(nonatomic,assign) CLLocationCoordinate2D naviCoordsBd; //将要去的地方——百度
//导航目的地2d,高德
@property(nonatomic,assign) CLLocationCoordinate2D naviCoordsGd; //将要去的地方——高德
//user最新2d
@property(nonatomic,assign) CLLocationCoordinate2D nowCoords;
//最近一次成功查询2d
@property(nonatomic,assign) CLLocationCoordinate2D lastCoords;
//地图的区域和详细地址
//@property(nonatomic,strong) NSString *regionStr;
@property(nonatomic,strong) NSString *addressStr;

//加载分页的参数
@property (assign, nonatomic) BOOL pullingDownward;   //向下拉获取最新

@property (nonatomic, assign) int pageOfFishSiteList; //钓点当前的page
@property (assign, nonatomic) int totalCountSite;     //总共有多少文章
@property (assign, nonatomic) int pageSizeSite;       //每一页有多少条数据

@property (nonatomic, assign) int pageOfFishStoreList;//渔具店当前的page
@property (assign, nonatomic) int totalCountStore;    //总共有多少文章
@property (assign, nonatomic) int pageSizeStore;      //每一页有多少条数据

@property (nonatomic, assign) int pageOfFishUserList; //钓友当前的page
@property (assign, nonatomic) int totalCountUser;     //总共有多少文章
@property (assign, nonatomic) int pageSizeUser;       //每一页有多少条数据

@end

@implementation LocalPageViewController

- (void)preparePointsArray{
    
    NSMutableArray * allSiteLocationArray = [[NSMutableArray alloc]init];
    NSMutableArray * allStoreLocationArray = [[NSMutableArray alloc]init];
    NSMutableArray * allUserLocationArray = [[NSMutableArray alloc]init];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"30.485853" forKey:@"latitude"];
    [dict setValue:@"104.063367" forKey:@"longitude"];
    [dict setValue:@"Bars 1" forKey:@"title"];
    [allSiteLocationArray addObject:dict];
    
    dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"30.487958" forKey:@"latitude"];
    [dict setValue:@"104.063377" forKey:@"longitude"];
    [dict setValue:@"Bars 2" forKey:@"title"];
    [allStoreLocationArray addObject:dict];
    
    dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"30.485455" forKey:@"latitude"];
    [dict setValue:@"104.063371" forKey:@"longitude"];
    [dict setValue:@"Bars 3" forKey:@"title"];
    [allUserLocationArray addObject:dict];
    
    dict = [[NSMutableDictionary alloc]init];
    [dict setValue:@"30.486446" forKey:@"latitude"];
    [dict setValue:@"104.063377" forKey:@"longitude"];
    [dict setValue:@"Bars 4" forKey:@"title"];
    [allUserLocationArray addObject:dict];
    
    if(arrSiteAnnotations != nil) {
        [arrSiteAnnotations removeAllObjects];
    }
    if(arrStoreAnnotations != nil) {
        [arrStoreAnnotations removeAllObjects];
    }
    if(arrUserAnnotations != nil) {
        [arrUserAnnotations removeAllObjects];
    }
    arrSiteAnnotations  = [[NSMutableArray alloc]init];
    arrStoreAnnotations  = [[NSMutableArray alloc]init];
    arrUserAnnotations  = [[NSMutableArray alloc]init];
    
    for(int i=0; i<[allSiteLocationArray count]; i++)
    {
        CLLocationCoordinate2D location;
        location.latitude = [[allSiteLocationArray[i] objectForKey:@"latitude"] doubleValue];
        location.longitude = [[allSiteLocationArray[i] objectForKey:@"longitude"] doubleValue];
        
        NSString *titleStr = (NSString *)[allSiteLocationArray[i] objectForKey:@"title"];
        MapViewAnnotation * annotation= [[MapViewAnnotation alloc] initWithTitle:titleStr Coordinate:location andIndex:i];
        [arrSiteAnnotations addObject:annotation];
    }
    
    for(int i=0; i<[allStoreLocationArray count]; i++)
    {
        CLLocationCoordinate2D location;
        location.latitude = [[allStoreLocationArray[i] objectForKey:@"latitude"] doubleValue];
        location.longitude = [[allStoreLocationArray[i] objectForKey:@"longitude"] doubleValue];
        
        NSString *titleStr = (NSString *)[allStoreLocationArray[i] objectForKey:@"title"];
        MapViewAnnotation * annotation= [[MapViewAnnotation alloc] initWithTitle:titleStr Coordinate:location andIndex:i];
        [arrStoreAnnotations addObject:annotation];
    }
    
    for(int i=0; i<[allUserLocationArray count]; i++)
    {
        CLLocationCoordinate2D location;
        location.latitude = [[allUserLocationArray[i] objectForKey:@"latitude"] doubleValue];
        location.longitude = [[allUserLocationArray[i] objectForKey:@"longitude"] doubleValue];
        
        NSString *titleStr = (NSString *)[allUserLocationArray[i] objectForKey:@"title"];
        MapViewAnnotation * annotation= [[MapViewAnnotation alloc] initWithTitle:titleStr Coordinate:location andIndex:i];
        [arrUserAnnotations addObject:annotation];
    }
    
    [self.mapView addAnnotations:arrSiteAnnotations];
}

//获取当前地区的海拔（通过地理定位方式获取）
- (void)getCurrentUserMapCenter{
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    _locationManager.delegate = self;
    //    [_locationManager requestAlwaysAuthorization];
    
    _locationManager.distanceFilter=500.0f;       //设置距离筛选器
    
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];     //启动位置管理器
}

- (void)settingUpMapView{
    
    self.mapView.delegate = self;
    
    //显示用户所在地
    self.mapView.showsUserLocation = YES;
    self.mapView.userLocation.title = @"张晓辉";
    self.mapView.userLocation.subtitle = @"vip";
    
    
    //[self preparePointsArray];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableView顶部位置多出64像素的处理
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //默认为钓点数据
    fishManLocalCurrentType = FishManLocalFishSiteType;
    
    //获取当前地区的海拔（通过地理定位方式获取）
    [self getCurrentUserMapCenter];
    //初始化地图
    [self settingUpMapView];
    
    
    //初始化数组
    self.allSiteModelArray = [NSMutableArray array];
    self.allStoreModelArray = [NSMutableArray array];
    self.allUserModelArray = [NSMutableArray array];
    
    //默认是加载钓点列表第一页
    fishManLocalCurrentType = FishManLocalFishSiteType;
    [self reloadAllPointsWithType:fishManLocalCurrentType downward:YES andPage:1];
    
    //默认列表模式
    self.goingToListView = NO;
    [self.flipView bringSubviewToFront:self.mapView];
    [self.flipView bringSubviewToFront:self.backContainerView];
    
    //地图模式
//    self.goingToListView = YES;
//    [self.flipView bringSubviewToFront:self.backContainerView];
//    [self.flipView bringSubviewToFront:self.mapView];
    
    
    
    /*** 顶部右边的天气信息 ***/
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(self.goingToListView == NO){
        [_rightButton setImage:ZXHImageName(@"本地_地图icon") forState:UIControlStateNormal];
    }
    else{
        [_rightButton setImage:ZXHImageName(@"本地_列表icon") forState:UIControlStateNormal];
    }
    _rightButton.frame = CGRectMake(0, 0, 48, 48);
//    [_rightButton setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [_rightButton addTarget:self action:@selector(rightListViewAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    
    
    //钓点
    [self.tableView registerNib:[UINib nibWithNibName:@"LocalFishSiteTBCell" bundle:nil] forCellReuseIdentifier:@"LocalFishSiteTBCell"];
    //钓友
    [self.tableView registerNib:[UINib nibWithNibName:@"LocalFishUserTBCell" bundle:nil] forCellReuseIdentifier:@"LocalFishUserTBCell"];
    //渔具店
    [self.tableView registerNib:[UINib nibWithNibName:@"LocalFishStoreTBCell" bundle:nil] forCellReuseIdentifier:@"LocalFishStoreTBCell"];
    
    /*** 列表去掉多余cell ***/
    UIView *tempfooterview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZXHScreenWidth, 0)];
    tempfooterview.backgroundColor = ZXHColorRGB(248, 248, 248, 1);
    self.tableView.tableFooterView = tempfooterview;
    
    //加载列表数据
    [ZXHViewTool addMJRefreshGifHeader:self.tableView selector:@selector(topDownloadListData) target:self];
    [ZXHViewTool addMJRefreshGifFooter:self.tableView selector:@selector(bottomUploadListData) target:self];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - 列表数据接口【钓点，钓鱼人，渔具店】
- (void)topDownloadListData{
    
    _pullingDownward = YES;
    int page;
    switch (fishManLocalCurrentType) {
        case FishManLocalFishSiteType:
            _pageOfFishSiteList = 1;
            page = _pageOfFishSiteList;
            break;
        case FishManLocalFishStoreType:
            _pageOfFishStoreList = 1;
            page = _pageOfFishStoreList;
            break;
        case FishManLocalFishUserType:
            _pageOfFishUserList = 1;
            page = _pageOfFishUserList;
            break;
        default:
            _pageOfFishSiteList = 1;
            page = _pageOfFishSiteList;
            break;
    }
    [self reloadAllPointsWithType:fishManLocalCurrentType downward:YES andPage:page];
}
- (void)bottomUploadListData{
    
    _pullingDownward = NO;
    
    int page;
    switch (fishManLocalCurrentType) {
            
        case FishManLocalFishStoreType:
                //总数 <= 当前页数能包含的最大数据量
            if(self.totalCountStore <= self.pageOfFishStoreList * self.pageSizeStore){
                [self.tableView.mj_footer endRefreshing];
                return;
            }
            _pageOfFishStoreList = _pageOfFishStoreList + 1;
            page = _pageOfFishStoreList;
            break;
            
        case FishManLocalFishUserType:
                //总数 <= 当前页数能包含的最大数据量
            if(self.totalCountUser <= self.pageOfFishUserList * self.pageSizeUser){
                [self.tableView.mj_footer endRefreshing];
                return;
            }
            _pageOfFishUserList = _pageOfFishUserList + 1;
            page = _pageOfFishUserList;
            break;
            
        case FishManLocalFishSiteType:
        default:
                //总数 <= 当前页数能包含的最大数据量
            if(self.totalCountSite <= self.pageOfFishSiteList * self.pageSizeSite){
                [self.tableView.mj_footer endRefreshing];
                return;
            }
            _pageOfFishSiteList = _pageOfFishSiteList + 1;
            page = _pageOfFishSiteList;
            break;
    }
    
    [self reloadAllPointsWithType:fishManLocalCurrentType downward:NO andPage:page];
}
/**
 *  @author zxh, 17-03-23 20:03:13
 *
 *  加载钓点，钓鱼人，渔具店列表
 *
 *  @param 列表类型
 *  @param 刷新方向【YES向下获取最新，NO向上获取更多】
 *  @param 列表页码
 */
- (void)reloadAllPointsWithType:(FishManLocalType)localType downward:(BOOL)down andPage:(int)page{
    
    NSString * longitude = @"104.063377";//经度longitude
    NSString * latitude = @"30.487958";//纬度latitude
    
    ZXH_WEAK_SELF
    switch (localType) {
        case FishManLocalFishSiteType:
        {
            if(!self.allSiteModelArray){
                self.allSiteModelArray = [NSMutableArray array];
            }
            
            [[CDServerAPIs shareAPI] fishSiteListWithPage:page
               Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
                   
                   if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
                       
                       //判断是否继续
                       NSDictionary * dataDic = responseObject[@"data"];
                       if([ZXHTool isNilNullObject:dataDic]){
                           return;
                       }
                       weakself.pageOfFishSiteList = [dataDic[@"currentPage"] intValue];
                       weakself.totalCountSite = [dataDic[@"totalCount"] intValue];
                       weakself.pageSizeSite = [dataDic[@"pageSize"] intValue];
                       
                       NSMutableArray *array = [FMFishSiteModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"result"]];
                       
                       if (![ZXHTool isNilNullObject:array] && array.count > 0) {
                           [weakself packagingArray:array downward:down];
                       }
                       else{
                           [weakself.tableView.mj_footer endRefreshing];
                           [weakself.tableView.mj_header endRefreshing];
                       }
                   }
                   else{
                       [weakself.tableView.mj_footer endRefreshing];
                       [weakself.tableView.mj_header endRefreshing];
                   }
               }
               Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
                   
                   [CDServerAPIs httpDataTask:dataTask error:error.error];
                   
                   [weakself.tableView.mj_footer endRefreshing];
                   [weakself.tableView.mj_header endRefreshing];
               }];
        }
            break;
            
        case FishManLocalFishStoreType:
        {   
            if(!self.allStoreModelArray){
                self.allStoreModelArray = [NSMutableArray array];
            }
            
            [[CDServerAPIs shareAPI] fishStoreListWithPage:page
           Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
               
               if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
                   
                   //判断是否继续
                   NSDictionary * dataDic = responseObject[@"data"];
                   if([ZXHTool isNilNullObject:dataDic]){
                       return;
                   }
                   weakself.pageOfFishStoreList = [dataDic[@"currentPage"] intValue];
                   weakself.totalCountStore = [dataDic[@"totalCount"] intValue];
                   weakself.pageSizeStore = [dataDic[@"pageSize"] intValue];
                   
                   NSMutableArray *array = [FMFishStoreModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"result"]];
                   
                   if (![ZXHTool isNilNullObject:array] && array.count > 0) {
                       [weakself packagingArray:array downward:down];
                   }
                   else{
                       [weakself.tableView.mj_footer endRefreshing];
                       [weakself.tableView.mj_header endRefreshing];
                   }
               }
               else{
                   [weakself.tableView.mj_footer endRefreshing];
                   [weakself.tableView.mj_header endRefreshing];
               }
           }
           Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
               
               [CDServerAPIs httpDataTask:dataTask error:error.error];
               
               [weakself.tableView.mj_footer endRefreshing];
               [weakself.tableView.mj_header endRefreshing];
           }];
        }
            break;
            
        case FishManLocalFishUserType:
            
            break;
            
        default:
            
            break;
    }
}
//组装数组数据
- (void)packagingArray:(NSMutableArray *)array downward:(BOOL)down{
    
    if(fishManLocalCurrentType == FishManLocalFishSiteType){
        
        if (down) {
            
            if(self.allSiteModelArray.count > 0){
                [self.allSiteModelArray removeAllObjects];
            }
            self.allSiteModelArray = [NSMutableArray arrayWithArray:array];
            
            [self.tableView.mj_header endRefreshing];
        }
        else{
            
            [self.allSiteModelArray addObjectsFromArray:array];
            [self.tableView.mj_footer endRefreshing];
        }
    }
    
    else if (fishManLocalCurrentType == FishManLocalFishStoreType){
        
        if (down) {
            
            if(self.allStoreModelArray.count > 0){
                [self.allStoreModelArray removeAllObjects];
            }
            self.allStoreModelArray = [NSMutableArray arrayWithArray:array];
            [self.tableView.mj_header endRefreshing];
        }
        else{
            
            [self.allStoreModelArray addObjectsFromArray:array];
            [self.tableView.mj_footer endRefreshing];
        }
    }
    
    else if (fishManLocalCurrentType == FishManLocalFishUserType){
        
    }
    
    //加载数据列表
    [self.tableView reloadData];
    
    //加载地图
#warning 加载地图
}

- (NSMutableArray *)arraySameObjFilter:(NSMutableArray *)array{
    
    for (int i = 0; i<self.allSiteModelArray.count; i++) {
        
        FMFishSiteModel * oldObj = self.allSiteModelArray[i];
        for (FMFishSiteModel * newObj in array) {
            if(oldObj.ID == newObj.ID){
                //替换旧的oldObj
                [self.allSiteModelArray replaceObjectAtIndex:i withObject:newObj];
            }
        }
    }
    
    return nil;
}

/**
 *  @author zxh, 17-03-23 20:03:13
 *
 *  钓点，钓鱼人，渔具店菜单选择方法
 *
 *  @param sender
 */
- (IBAction)topSegmentdControlChanged:(UISegmentedControl *)segCtl {
    
    NSLog(@"菜单选择 %ld", segCtl.selectedSegmentIndex);
    //当前选择的地理类型
    fishManLocalCurrentType = segCtl.selectedSegmentIndex;
    
    NSInteger count = 0;
    switch (fishManLocalCurrentType) {
        case FishManLocalFishSiteType:
            count = _allSiteModelArray.count;
            break;
        case FishManLocalFishStoreType:
            count = _allStoreModelArray.count;
            break;
        case FishManLocalFishUserType:
            count = _allUserModelArray.count;
            break;
        default:
            break;
    }
    
    if (count == 0) {
        [self reloadAllPointsWithType:fishManLocalCurrentType downward:YES andPage:1];
    }
    
    if(self.goingToListView == NO){//列表状态
        [self.tableView reloadData];
    }
    else{
        
        [self.mapView removeAnnotations:arrSiteAnnotations];
        [self.mapView removeAnnotations:arrStoreAnnotations];
        [self.mapView removeAnnotations:arrUserAnnotations];
        
        switch (fishManLocalCurrentType) {
            case FishManLocalFishSiteType:
            case FishManLocalDefaultType:
            {
                [self.mapView addAnnotations:arrSiteAnnotations];
            }
                break;
                
            case FishManLocalFishStoreType:
            {
                [self.mapView addAnnotations:arrStoreAnnotations];
            }
                break;
                
            case FishManLocalFishUserType:
            {
                [self.mapView addAnnotations:arrUserAnnotations];
            }
                break;
                
            default:
                break;
        }
    }
}

/**
 *  @author zxh, 17-03-22 22:03:09
 *
 *  地图和列表翻转切换
 *
 *  @param button
 */
- (void)rightListViewAction:(UIButton *)button{
    
    if(self.goingToListView){
        //进入列表状态
        //        [_rightButton setTitle:@"地图" forState:UIControlStateNormal];
        [_rightButton setImage:ZXHImageName(@"本地_地图icon") forState:UIControlStateNormal];
    }
    else{
        //进入地图状态
        //        [_rightButton setTitle:@"列表" forState:UIControlStateNormal];
        [_rightButton setImage:ZXHImageName(@"本地_列表icon") forState:UIControlStateNormal];
    }
    
    self.mapView.hidden = self.goingToListView;
    self.backContainerView.hidden = !self.goingToListView;
    [UIView transitionWithView:self.flipView duration:0.5 options:(self.goingToListView ? UIViewAnimationOptionTransitionFlipFromLeft :
                                                                      UIViewAnimationOptionTransitionFlipFromRight) animations:^{
        
    } completion:^(BOOL finished) {
        self.goingToListView = !self.goingToListView;
    }];
}


#pragma mark - 关注、取消关注

- (void)doFollowOrCancelFollowWithStatus:(BOOL)isFollowedByMe{
    
    if(isFollowedByMe){//已关注，则取消关注
        
        [CDTopAlertView showMsg:@"已取消关注" alertType:TopAlertViewSuccessType];
    }
    else{//未关注，则进行关注
        
        [CDTopAlertView showMsg:@"已关注成功" alertType:TopAlertViewSuccessType];
    }
}

#pragma mark  列表 UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (fishManLocalCurrentType) {
        case FishManLocalFishSiteType:{
            return self.allSiteModelArray.count;
        }
            break;
        case FishManLocalFishStoreType:{
            return self.allStoreModelArray.count;
        }
            break;
        case FishManLocalFishUserType:{
            return self.allUserModelArray.count;
        }
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (fishManLocalCurrentType) {
        case FishManLocalFishSiteType:{
            LocalFishSiteTBCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LocalFishSiteTBCell" forIndexPath:indexPath];
            cell.model = [self.allSiteModelArray objectAtIndex:indexPath.row];
            [cell reloadData];
            return cell;
        }
            break;
        case FishManLocalFishStoreType:{
            LocalFishStoreTBCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LocalFishStoreTBCell" forIndexPath:indexPath];
            cell.model = [self.allStoreModelArray objectAtIndex:indexPath.row];
            [cell reloadData];
            return cell;
        }
            break;
        case FishManLocalFishUserType:{
            LocalFishUserTBCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LocalFishUserTBCell" forIndexPath:indexPath];
            
            ZXH_WEAK_SELF
            cell.callback_UserTBCell = ^(BOOL isFollowedByMe){
                
                CLog(@"关注还是取消关注 哈哈哈哈哈");
                [weakself doFollowOrCancelFollowWithStatus:isFollowedByMe];
            };
            
            return cell;
        }
            break;
        default:{
            return nil;
        }
            break;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger heightForCell = 88;
    switch (fishManLocalCurrentType) {
        case FishManLocalFishSiteType:
            heightForCell = 88;
            break;
        case FishManLocalFishStoreType:
            heightForCell = 88;
            break;
        case FishManLocalFishUserType:
            heightForCell = 60;
            break;
            
        default:
            heightForCell = 0;
            break;
    }
    
    return heightForCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CLog(@"打开列表的详情");
    self.hidesBottomBarWhenPushed = YES;
    
    switch (fishManLocalCurrentType) {
        case FishManLocalFishSiteType:
        {
            FMSiteHomepageController * siteHP = [[FMSiteHomepageController alloc] initWithNibName:@"FMSiteHomepageController" bundle:nil];
            siteHP.model = [self.allSiteModelArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:siteHP animated:YES];
        }
            break;
        case FishManLocalFishStoreType:
        {
            FMStoreHomepageController * storeHP = [[FMStoreHomepageController alloc] initWithNibName:@"FMStoreHomepageController" bundle:nil];
            storeHP.model = [self.allStoreModelArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:storeHP animated:YES];
        }
            break;
        case FishManLocalFishUserType:
        {
            FMUserHomepageController * userHP = [[FMUserHomepageController alloc] initWithNibName:@"FMUserHomepageController" bundle:nil];
            //userHP.model = [self.allUserModelArray objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:userHP animated:YES];
        }
            break;
        default:
            break;
    }
    
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark  地图 MKMap kit Delegate

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation{
    
    if (annotation == map.userLocation)
    {
        return nil;
    }
    MKPinAnnotationView *pin = (MKPinAnnotationView *) [map dequeueReusableAnnotationViewWithIdentifier: @"restMap"];
    if (pin == nil)
    {
        pin = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"restMap"];
    }
    else
    {
        pin.annotation = annotation;
    }
    pin.image = [UIImage imageNamed:@"temp.png"];
    
    switch (fishManLocalCurrentType) {
        case FishManLocalFishSiteType:
        case FishManLocalDefaultType:
        {
            pin.pinColor = MKPinAnnotationColorRed;
        }
            break;
            
        case FishManLocalFishStoreType:
        {
            pin.pinColor = MKPinAnnotationColorGreen;
        }
            break;
            
        case FishManLocalFishUserType:
        {
            pin.pinColor = MKPinAnnotationColorPurple;
        }
            break;
            
        default:
            break;
    }
    
    pin.animatesDrop = NO;
    pin.canShowCallout = YES;
    
    //详细
    UIView *iv =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    iv.backgroundColor = [UIColor greenColor];
    pin.detailCalloutAccessoryView = iv;
    
    //left AccessoryView
    UIButtonForMapPin *leftBtn = [UIButtonForMapPin buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 50, 50);
    [leftBtn setTitle:@"导航" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    leftBtn.pinLocation = pin.annotation.coordinate;
    [leftBtn addTarget:self action:@selector(openNavigation:) forControlEvents:UIControlEventTouchUpInside];
    pin.leftCalloutAccessoryView = leftBtn;
    
    //right AccessoryView
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    MapViewAnnotation *temp = (MapViewAnnotation *)pin.annotation;
    rightBtn.tag = temp.index;
    pin.rightCalloutAccessoryView = rightBtn;
    [rightBtn addTarget:self action:@selector(openDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    return pin;
}
//打开导航
- (void)openNavigation:(UIButtonForMapPin *)button{
    
    CLog(@"要导航？？？");
    self.naviCoordsGd = button.pinLocation;
    
    [self doAcSheet];
}
-(void)doAcSheet {
    
    NSArray *appListArr = [CheckInstalledMapAPP checkHasOwnApp];
//    NSString *sheetTitle = [NSString stringWithFormat:@"导航到 %@",[self.navDic objectForKey:@"address"]];
    
    NSString *sheetTitle = @"导航到";
    
    UIActionSheet *sheet;
    if ([appListArr count] == 2) {
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1], nil];
    }else if ([appListArr count] == 3){
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1],appListArr[2], nil];
    }else if ([appListArr count] == 4){
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1],appListArr[2],appListArr[3], nil];
    }else if ([appListArr count] == 5){
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1],appListArr[2],appListArr[3],appListArr[4], nil];
    }
    else if ([appListArr count] == 6){
        sheet = [[UIActionSheet alloc] initWithTitle:sheetTitle delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:appListArr[0],appListArr[1],appListArr[2],appListArr[3],appListArr[4],appListArr[5], nil];
    }
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *btnTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (buttonIndex == 0) {
        if (!ISIOS6) {//ios6 调用goole网页地图
            NSString *urlString = [[NSString alloc]
                                   initWithFormat:@"http://maps.google.com/maps?saddr=&daddr=%.8f,%.8f&dirfl=d",self.naviCoordsGd.latitude,self.naviCoordsGd.longitude];
            
            NSURL *aURL = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:aURL];
        }else{//ios7 跳转apple map
            CLLocationCoordinate2D to;
            
            to.latitude = self.naviCoordsGd.latitude;
            to.longitude = self.naviCoordsGd.longitude;
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:to addressDictionary:nil]];
            
            toLocation.name = _addressStr;
            [MKMapItem openMapsWithItems:[NSArray arrayWithObjects:currentLocation, toLocation, nil] launchOptions:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeDriving, [NSNumber numberWithBool:YES], nil] forKeys:[NSArray arrayWithObjects:MKLaunchOptionsDirectionsModeKey, MKLaunchOptionsShowsTrafficKey, nil]]];
        }
    }
    if ([btnTitle isEqualToString:@"google地图"]) {
        NSString *urlStr = [NSString stringWithFormat:@"comgooglemaps://?saddr=%.8f,%.8f&daddr=%.8f,%.8f&directionsmode=transit",self.nowCoords.latitude,self.nowCoords.longitude,self.naviCoordsGd.latitude,self.naviCoordsGd.longitude];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
    else if ([btnTitle isEqualToString:@"高德地图"]){
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"iosamap://navi?sourceApplication=broker&backScheme=openbroker2&poiname=%@&poiid=BGVIS&lat=%.8f&lon=%.8f&dev=1&style=2",
                                           self.addressStr,
                                           self.naviCoordsGd.latitude,
                                           self.naviCoordsGd.longitude]];
        
        [[UIApplication sharedApplication] openURL:url];
        
    }
    else if ([btnTitle isEqualToString:@"百度地图"]){
        double bdNowLat,bdNowLon;
        bd_encrypt(self.nowCoords.latitude, self.nowCoords.longitude, &bdNowLat, &bdNowLon);
        
        NSString *stringURL = [NSString stringWithFormat:@"baidumap://map/direction?origin=%.8f,%.8f&destination=%.8f,%.8f&&mode=driving",bdNowLat,bdNowLon,self.naviCoordsBd.latitude,self.naviCoordsBd.longitude];
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
    }
    else if ([btnTitle isEqualToString:@"显示路线"]){
//        [self drawRout];
    }
}
/*
#pragma mark - 百度和火星经纬度转换
-(void)getChangedLoc{
    if ([LocIsBaidu locIsBaid:self.navDic]) {
        
        self.naviCoordsBd.latitude = [[self.navDic objectForKey:@"baidu_lat"] doubleValue];
        self.naviCoordsBd.longitude = [[self.navDic objectForKey:@"baidu_lng"] doubleValue];
        
        double gdLat,gdLon;
        bd_decrypt(self.naviCoordsBd.latitude, self.naviCoordsBd.longitude, &gdLat, &gdLon);
        
        self.naviCoordsGd.latitude = gdLat;
        self.naviCoordsGd.longitude = gdLon;
    }else{
        self.naviCoordsGd.latitude = [[self.navDic objectForKey:@"google_lat"] doubleValue];
        self.naviCoordsGd.longitude = [[self.navDic objectForKey:@"google_lng"] doubleValue];
        
        double bdLat,bdLon;
        bd_encrypt(naviCoordsGd.latitude, naviCoordsGd.longitude, &bdLat, &bdLon);
        
        naviCoordsBd.latitude = bdLat;
        naviCoordsBd.longitude = bdLon;
    }
}
*/
- (void)openDetail:(UIButton *)button{
    CLog(@"打开图钉📌的详情详情");
    self.hidesBottomBarWhenPushed = YES;
    
    switch (fishManLocalCurrentType) {
        case FishManLocalFishUserType:
        {
            FMUserHomepageController * userHP = [[FMUserHomepageController alloc] initWithNibName:@"FMUserHomepageController" bundle:nil];
            [self.navigationController pushViewController:userHP animated:YES];
        }
            break;
        case FishManLocalFishSiteType:
        {
            FMSiteHomepageController * siteHP = [[FMSiteHomepageController alloc] initWithNibName:@"FMSiteHomepageController" bundle:nil];
            [self.navigationController pushViewController:siteHP animated:YES];
        }
            break;
        case FishManLocalFishStoreType:
        {
            FMStoreHomepageController * storeHP = [[FMStoreHomepageController alloc] initWithNibName:@"FMStoreHomepageController" bundle:nil];
            [self.navigationController pushViewController:storeHP animated:YES];
        }
            break;
        default:
            break;
    }
    
    self.hidesBottomBarWhenPushed = NO;
}


//- (MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    MKPinAnnotationView *pinView = nil;
//    
//    static NSString *defaultPinID = @"com.invasivecode.pin";
//    pinView = (MKPinAnnotationView *)[mV dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
//    if ( pinView == nil ){
//        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:defaultPinID];
//    }
//    
//    pinView.pinColor = MKPinAnnotationColorRed;
//    pinView.canShowCallout = YES;
//    pinView.animatesDrop = YES;
//    [mV.userLocation setTitle:@"张小辉"];
//    [mV.userLocation setSubtitle:@"vip"];
//    return pinView;
//}


-(void)setMapCenterAndRegionWith:(CLLocationCoordinate2D)locationCoordinate2D{
    
    MKCoordinateSpan theSpan;
    //地图的范围 越小越精确
    theSpan.latitudeDelta = 0.05;
    theSpan.longitudeDelta = 0.05;
    
    MKCoordinateRegion theRegion;
    theRegion.center = locationCoordinate2D;
    theRegion.span = theSpan;
    
    [self.mapView setRegion:theRegion animated:YES];
    
    //重置到用户中心位置
//    [self.mapView setCenterCoordinate:locationCoordinate2D animated:YES];
}

#pragma mark 地理信息
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation{
    
    [self setMapCenterAndRegionWith:newLocation.coordinate];
    
    NSLog(@"经度纬度（%f， %f）", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
}
-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error {
    NSLog(@"error.userInfo：%@\nerror.domain：%@",error.userInfo,error.domain);
}


#pragma mark - tableVew delegate method

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView{
    
    FMEmptyNotiView *emptyView = [FMEmptyNotiView initEmptyListView:EmptyXiangMuShowType withFrame:self.tableView.frame];
    
    return emptyView;
}

@end
