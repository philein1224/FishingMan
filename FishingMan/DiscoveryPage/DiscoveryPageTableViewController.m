//
//  DiscoveryPageTableViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/1/5.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "DiscoveryPageTableViewController.h"
#import "DiscoveryPageTableViewCell.h"
#import "FMSingleArticleTypeTableViewController.h"

#import <CoreMotion/CoreMotion.h>

#import "CDServerAPIs+MainPage.h"

#pragma mark 发现-文章分类数据模型

@interface FMArticleTypeInfoModel : ZXHBaseModel
@property (assign, nonatomic) long     count;        //单个文章的数量
@property (assign, nonatomic) int      articleType;  //文章类型
@end

@implementation FMArticleTypeInfoModel
MJExtensionCodingImplementation
- (id)init{
    self = [super init];
    if (self) {
    }
    return self;
}
@end

#pragma mark 发现-文章分类总列表

@interface DiscoveryPageTableViewController ()
{
    NSMutableArray * ArticleTypeTitleArray;
    NSMutableArray * ArticleTypeIconArray;
}

@property (nonatomic, strong) NSMutableArray * articleTypeInfoDataArray;
@property (nonatomic, strong) NSMutableArray * articleTypeCountArray;
@property (nonatomic, strong) CMAltimeter * altimeter;
@end

@implementation DiscoveryPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"文章"];
    
    /*** 注册表单元 ***/
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoveryPageTableViewCell" bundle:nil] forCellReuseIdentifier:@"DiscoveryPageTableViewCell"];
    
    /*** 列表视图背景 ***/
    [self.tableView setBackgroundColor:ZXHColorRGB(248, 248, 248, 1)];
    
    /*** 列表去掉多余cell ***/
    UIView *tempfooterview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZXHScreenWidth, 49)];
    tempfooterview.backgroundColor = ZXHColorRGB(248, 248, 248, 1);
    self.tableView.tableFooterView = tempfooterview;
    
    /*** 加载默认数据 ***/
    [self loadListData];
    
//    _altimeter = [[CMAltimeter alloc]init];
//    
//    //检测设备是否支持气压计
//    if (![CMAltimeter isRelativeAltitudeAvailable]) {
//        NSLog(@"不支持气压监测");
//        return;
//    }
//        //开始监测
//    [self.altimeter startRelativeAltitudeUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAltitudeData * _Nullable altitudeData, NSError * _Nullable error) {
//        
//        // 实时刷新数据
//        [self updateLabels:altitudeData];
//        
//    }];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self loadArticleTypeListData];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [self.altimeter stopRelativeAltitudeUpdates];
}

- (void)updateLabels:(CMAltitudeData *)altitudeData {
    
    NSLog(@"气压：%@", altitudeData.relativeAltitude);
    NSLog(@"海拔：%@", altitudeData.pressure);
    
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    NSString *altitude = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:altitudeData.relativeAltitude]];
    NSString *pressure = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:altitudeData.pressure]];
    
    //相对高度，并非海拔
    NSString *haiBa = [NSString stringWithFormat:@"Relative Altitude: \n%@ m", altitude];
    //实时气压
    NSString *qiYa = [NSString stringWithFormat:@"Air Pressure: \n%@ kPa", pressure];
    
    
    NSLog(@"气压：%@", qiYa);
    NSLog(@"海拔：%@", haiBa);
}

#pragma mark - 数据生成

- (void)loadListData{
    
    NSMutableArray * allTypes = ALL_ARTICLE_TYPE_NAME_ARRAY;
    
    //分类名字
    ArticleTypeTitleArray = [[NSMutableArray alloc] init];
    [ArticleTypeTitleArray addObjectsFromArray:allTypes];
    
    //分类icon的文件名
    ArticleTypeIconArray = [[NSMutableArray alloc] init];
    [ArticleTypeIconArray addObjectsFromArray:allTypes];
    
    //分类文章的数量
    _articleTypeInfoDataArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < ArticleTypeTitleArray.count; i++) {
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
        [tempDic setObject:ArticleTypeTitleArray[i] forKey:@"keyName"];   //名称
        [tempDic setObject:[NSNumber numberWithInt:0] forKey:@"keyValue"];//数量
        [tempDic setObject:ArticleTypeIconArray[i] forKey:@"keyIconName"]; //icon名称
        [tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"keyFlag"];//是否有提醒标示
        [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"ArticleType"];//文章类型
        [_articleTypeInfoDataArray addObject:tempDic];
    }
}

//文章大类型信息列表
- (void)loadArticleTypeListData{
    
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] articleTypesInfoListSuccess:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        CLog(@"文章大类型信息列表 : %@", responseObject);
        
        if([CDServerAPIs httpResponse:responseObject showAlert:NO DataTask:dataTask]){
            
            weakself.articleTypeCountArray = [FMArticleTypeInfoModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
            
            for (int i = 0; i < weakself.articleTypeInfoDataArray.count; i++) {
                
                for (FMArticleTypeInfoModel *countInfo in weakself.articleTypeCountArray) {
                    
                    if(i == countInfo.articleType){
                        NSMutableDictionary *tempDic = weakself.articleTypeInfoDataArray[i];
                        [tempDic setObject:[NSNumber numberWithInt:countInfo.count] forKey:@"keyValue"];
                        break;
                    }
                }
            }
            
            [weakself.tableView reloadData];
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
    return self.articleTypeInfoDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZXHRatioWithReal375 * 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DiscoveryPageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoveryPageTableViewCell" forIndexPath:indexPath];
    
    [cell loadData:self.articleTypeInfoDataArray[indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    if (indexPath.section == 0) {
        
        FMSingleArticleTypeTableViewController * oneKindArticleTypeVC = [[FMSingleArticleTypeTableViewController alloc] init];

        oneKindArticleTypeVC.typeObjInfo = _articleTypeInfoDataArray[indexPath.row];
        oneKindArticleTypeVC.navigationTitle = ArticleTypeTitleArray[indexPath.row];
        [self.navigationController pushViewController:oneKindArticleTypeVC animated:YES];
    }
    self.hidesBottomBarWhenPushed = NO;
}

@end
