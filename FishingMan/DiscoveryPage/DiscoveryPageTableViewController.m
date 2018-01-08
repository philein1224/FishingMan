//
//  DiscoveryPageTableViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/1/5.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "DiscoveryPageTableViewController.h"
#import "DiscoveryPageTableViewCell.h"
#import "DiscoveryTypeTableViewController.h"

#import <CoreMotion/CoreMotion.h>

#import "CDServerAPIs+MainPage.h"

@interface DiscoveryPageTableViewController ()
{
    NSMutableArray * ArticleTypeTitleArray;
    NSMutableArray * ArticleTypeIconArray;
    
    NSMutableArray * ArticleTypeInfoDataArray;
}

@property (nonatomic, strong) CMAltimeter * altimeter;
@end

@implementation DiscoveryPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"发现"];
    
    /*** 注册表单元 ***/
    [self.tableView registerNib:[UINib nibWithNibName:@"DiscoveryPageTableViewCell" bundle:nil] forCellReuseIdentifier:@"DiscoveryPageTableViewCell"];
    
    /*** 列表视图背景 ***/
    [self.tableView setBackgroundColor:ZXHColorRGB(248, 248, 248, 1)];
    
    /*** 列表去掉多余cell ***/
    UIView *tempfooterview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZXHScreenWidth, 49)];
    tempfooterview.backgroundColor = ZXHColorRGB(248, 248, 248, 1);
    self.tableView.tableFooterView = tempfooterview;
    
    /*** 加载数据 ***/
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

    // Dispose of any resources that can be recreated.
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
    
    ArticleTypeInfoDataArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < ArticleTypeTitleArray.count; i++) {
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
        [tempDic setObject:ArticleTypeTitleArray[i] forKey:@"keyName"];
        [tempDic setObject:[NSNumber numberWithInt:1001] forKey:@"keyValue"];
        [tempDic setObject:ArticleTypeIconArray[i] forKey:@"keyIconName"];
        [tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"keyFlag"];
        [tempDic setObject:[NSNumber numberWithInt:i] forKey:@"ArticleType"];
        [ArticleTypeInfoDataArray addObject:tempDic];
    }
}

//文章大类型信息列表
- (void)loadArticleTypeListData{
    
    [[CDServerAPIs shareAPI] articleTypesInfoListSuccess:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        CLog(@"文章大类型信息列表 : %@", responseObject);
        
        if([CDServerAPIs httpResponse:responseObject showAlert:NO DataTask:dataTask]){
            
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
    return ArticleTypeTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return ZXHRatioWithReal375 * 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DiscoveryPageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"DiscoveryPageTableViewCell" forIndexPath:indexPath];
    
    [cell loadData:ArticleTypeInfoDataArray[indexPath.row]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    if (indexPath.section == 0) {
        
        DiscoveryTypeTableViewController * oneKindArticleTypeVC = [[DiscoveryTypeTableViewController alloc] init];
        oneKindArticleTypeVC.typeObjInfo = ArticleTypeInfoDataArray[indexPath.row];
        oneKindArticleTypeVC.navigationTitle = ArticleTypeTitleArray[indexPath.row];
        [self.navigationController pushViewController:oneKindArticleTypeVC animated:YES];
    }
    self.hidesBottomBarWhenPushed = NO;
}

@end
