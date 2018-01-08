//
//  MinePageTableViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/1/5.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "MinePageTableViewController.h"
#import "MinePageTableViewCell.h"
#import "MinePageSectionHeaderCell.h"

#import <CoreMotion/CoreMotion.h>

#import "DiscoveryTypeTableViewController.h"
#import "FMShareView.h"
#import "FMFeedbackViewController.h"
#import "FMThanksTableViewController.h"
#import "FMSettingTableViewController.h"
#import "FMAboutUsViewController.h"
#import "FMCooperationViewController.h"

#import "FMUserHomeHeaderView.h"
#define kTableHeaderViewHeight 200  //tableHeaderView的高度

@interface MinePageTableViewController ()
{
    NSMutableArray * mine1stArray;
    NSMutableArray * mine2ndArray;
    NSMutableArray * mine3rdArray;
    
    float HEADER_HEIGHT;
}

@property (nonatomic, strong) CMAltimeter * altimeter;
@property (strong, nonatomic) FMUserHomeHeaderView * userHomeHeader;
@end

@implementation MinePageTableViewController

//- (UIView *)setupHeaderView{
//    
//    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, HEADER_HEIGHT)];
//    [customView setUserInteractionEnabled:YES];
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, HEADER_HEIGHT)];
//    [imageView setImage:[UIImage imageNamed:@"DetailTopBG"]];
//    [imageView setUserInteractionEnabled:NO];
//    
//    //关键步骤 设置可变化背景view属性
//    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
//    imageView.clipsToBounds = YES;
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    [customView addSubview:imageView];
//    
//    UIButton *avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [avatarButton setImage:[UIImage imageNamed:@"userHead0.png"] forState:UIControlStateNormal];
//    [avatarButton setFrame:CGRectMake((ZXHScreenWidth - 60)/2, 60, 60, 60)];
//    [avatarButton setBackgroundColor:[UIColor clearColor]];
//    [avatarButton addTarget:self action:@selector(userHeadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [customView addSubview:avatarButton];
//    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,
//                                                               (avatarButton.frame.origin.y+avatarButton.frame.size.height) + 10,
//                                                               [[UIScreen mainScreen] bounds].size.width,
//                                                               30)];
//    [label setText:@"清风晓薇"];
//    [label setTextColor:[UIColor whiteColor]];
//    [label setTextAlignment:NSTextAlignmentCenter];
//    [customView addSubview:label];
//    
//    return customView;
//}

- (void)userHeadButtonAction:(UIButton *)sender{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*** 顶部头像区域 ***/
    CGRect menuframe = CGRectMake(0, 0, ZXHScreenWidth, kTableHeaderViewHeight *ZXHRatioWithReal375);
    UIView *tempFooterView = [[UIView alloc]init];
    tempFooterView.frame = menuframe;
    tempFooterView.clipsToBounds = YES;
    
    self.userHomeHeader = [[[NSBundle mainBundle] loadNibNamed:@"FMUserHomeHeaderView" owner:nil options:nil] firstObject];
    self.userHomeHeader.frame = tempFooterView.bounds;
    
    [tempFooterView addSubview:self.userHomeHeader];
    
    [self.tableView beginUpdates];
    self.tableView.tableHeaderView = tempFooterView;
    [self.tableView endUpdates];
    
    /*** 注册表单元 ***/
    [self.tableView registerNib:[UINib nibWithNibName:@"MinePageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MinePageTableViewCell"];
    
    /*** 列表视图背景 ***/
    [self.tableView setBackgroundColor:ZXHColorRGB(248, 248, 248, 1)];
    
    /*** 列表去掉多余cell ***/
    UIView *tempfooterview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZXHScreenWidth, 49)];
    tempfooterview.backgroundColor = ZXHColorRGB(248, 248, 248, 1);
    self.tableView.tableFooterView = tempfooterview;
    
    
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
    
    /*** 隐藏顶部导航栏 ***/
    [self.navigationController setNavigationBarHidden:YES animated:NO];
 
    /*** 加载个人中心数据 ***/
    [self loadListData];
}
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

#pragma mark - 滚动时改变顶部导航栏颜色
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //1
    [self.tableView.tableHeaderView viewWithTag:1000].frame = [self calculateFrameWithOffY:self.tableView.contentOffset.y];
    CGPoint center = [self.tableView.tableHeaderView viewWithTag:1000].center;
    center.x = self.view.frame.size.width / 2;
    [self.tableView.tableHeaderView viewWithTag:1000].center = center;
}

#pragma mark - Others （其他）
- (CGRect)calculateFrameWithOffY:(CGFloat)offy {
    
    //2.缩放比例计算
    CGFloat zoomScale = -offy / self.tableView.frame.size.height + 1;
    
    CGRect rect = [self.tableView.tableHeaderView viewWithTag:1000].frame;
    
    CLog(@"offy = %f, %f", offy, zoomScale);
    
    if (offy < 0) {
        rect.size.width = self.view.frame.size.width * zoomScale;
        rect.size.height = kTableHeaderViewHeight * zoomScale * ZXHRatioWithReal375;
    }
    
    return rect;
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
    
    NSMutableArray * mine1stNameArray = [[NSMutableArray alloc] init];;
    NSMutableArray * mine2ndNameArray = [[NSMutableArray alloc] init];;
    NSMutableArray * mine3rdNameArray = [[NSMutableArray alloc] init];;
    
    [mine1stNameArray addObject:@"收藏"];
    [mine1stNameArray addObject:@"我的发帖"];
    [mine1stNameArray addObject:@"我的评论"];
    
    [mine2ndNameArray addObject:@"意见反馈"];
    [mine2ndNameArray addObject:@"支持钓鱼大仙"];
    [mine2ndNameArray addObject:@"推荐给好友"];
    [mine2ndNameArray addObject:@"特别感谢"];
    
    [mine3rdNameArray addObject:@"关于我们"];
    [mine3rdNameArray addObject:@"商务合作"];
    [mine3rdNameArray addObject:@"设置"];
    
    mine1stArray = [[NSMutableArray alloc] init];
    mine2ndArray = [[NSMutableArray alloc] init];
    mine3rdArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < mine1stNameArray.count; i++) {
        
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
        [tempDic setObject:mine1stNameArray[i] forKey:@"keyName"];
        [tempDic setObject:@"value值" forKey:@"keyValue"];
        [tempDic setObject:@"tempIcon" forKey:@"keyIconName"];
        [tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"keyFlag"];
        [mine1stArray addObject:tempDic];
    }
    for (int i = 0; i < mine2ndNameArray.count; i++) {
        
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
        [tempDic setObject:mine2ndNameArray[i] forKey:@"keyName"];
        [tempDic setObject:@"value值" forKey:@"keyValue"];
        [tempDic setObject:@"tempIcon" forKey:@"keyIconName"];
        [tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"keyFlag"];
        [mine2ndArray addObject:tempDic];
    }
    for (int i = 0; i < mine3rdNameArray.count; i++) {
        
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
        [tempDic setObject:mine3rdNameArray[i] forKey:@"keyName"];
        [tempDic setObject:@"value值" forKey:@"keyValue"];
        [tempDic setObject:@"tempIcon" forKey:@"keyIconName"];
        [tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"keyFlag"];
        [mine3rdArray addObject:tempDic];
    }
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0) {
        return mine1stArray.count + 1;
    }
    else if(section == 1) {
        return mine2ndArray.count + 1;;
    }
    else if(section == 2) {
        return mine3rdArray.count + 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        return 8;
    }
    return ZXHRatioWithReal375 * 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            MinePageSectionHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MinePageSectionHeaderCell" forIndexPath:indexPath];
            return cell;
        }
        else{
            MinePageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MinePageTableViewCell" forIndexPath:indexPath];
            [cell loadData:mine1stArray[indexPath.row-1]];
            return cell;
        }
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            MinePageSectionHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MinePageSectionHeaderCell" forIndexPath:indexPath];
            return cell;
        }
        else{
            MinePageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MinePageTableViewCell" forIndexPath:indexPath];
            [cell loadData:mine2ndArray[indexPath.row-1]];
            return cell;
        }
    }
    else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            MinePageSectionHeaderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MinePageSectionHeaderCell" forIndexPath:indexPath];
            
            return cell;
        }
        else{
            MinePageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MinePageTableViewCell" forIndexPath:indexPath];
            
            [cell loadData:mine3rdArray[indexPath.row-1]];
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

#pragma mark 第一分组
    
    if(indexPath.section == 0){
        self.hidesBottomBarWhenPushed = YES;
        
        NSMutableDictionary * tempDic = mine1stArray[indexPath.row-1];
        NSString * title = [tempDic objectForKey:@"keyName"];
        
        DiscoveryTypeTableViewController * oneKindArticleVC = [[DiscoveryTypeTableViewController alloc] init];
        oneKindArticleVC.title = title;
        oneKindArticleVC.hideNavigationWhenPopOut = YES;
        [self.navigationController pushViewController:oneKindArticleVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }

#pragma mark 第二分组
    
    else if (indexPath.section == 1){
        
        if (indexPath.row == 1) {
            //意见反馈
            self.hidesBottomBarWhenPushed = YES;
            
            NSMutableDictionary * tempDic = mine2ndArray[indexPath.row-1];
            NSString * title = [tempDic objectForKey:@"keyName"];
            
            FMFeedbackViewController * feedbackVC = [[FMFeedbackViewController alloc] initWithNibName:@"FMFeedbackViewController" bundle:nil];
            feedbackVC.title = title;
            [self.navigationController pushViewController:feedbackVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
        else if (indexPath.row == 2){
           //支持钓鱼大仙
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1171339177"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
//            @"https://itunes.apple.com/us/app/%E9%B1%BC%E4%B9%90%E5%9C%88-%E9%92%93%E9%B1%BC%E4%BA%BA%E7%9A%84%E5%9C%88/id1171339177?l=zh&ls=1&mt=8"
        }
        else if (indexPath.row == 3){
            //推荐给好友
            [self RecommendAppToFriendsAction];
        }
        else if (indexPath.row == 4){
            //特别感谢
            self.hidesBottomBarWhenPushed = YES;
            
            NSMutableDictionary * tempDic = mine2ndArray[indexPath.row-1];
            NSString * title = [tempDic objectForKey:@"keyName"];
            
            FMThanksTableViewController * thanksVC = [[FMThanksTableViewController alloc] initWithNibName:@"FMThanksTableViewController" bundle:nil];
            thanksVC.title = title;
            [self.navigationController pushViewController:thanksVC animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
    }

#pragma mark 第三分组
    
    else if (indexPath.section == 2) {
        
        self.hidesBottomBarWhenPushed = YES;
        
        NSMutableDictionary * tempDic = mine3rdArray[indexPath.row-1];
        NSString * title = [tempDic objectForKey:@"keyName"];
        
        if (indexPath.row == 1){
            //关于我们
            FMAboutUsViewController * aboutUsVC = [[FMAboutUsViewController alloc] initWithNibName:@"FMAboutUsViewController" bundle:nil];
            [aboutUsVC setTitle:title];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
        else if (indexPath.row == 2){
            //商务合作
            FMCooperationViewController * cooperationVC = [[FMCooperationViewController alloc] initWithNibName:@"FMCooperationViewController" bundle:nil];
            [cooperationVC setTitle:title];
            [self.navigationController pushViewController:cooperationVC animated:YES];
        }
        if (indexPath.row == 3) {
            //设置
            FMSettingTableViewController * settingVC = [[FMSettingTableViewController alloc] initWithNibName:@"FMSettingTableViewController" bundle:nil];
            [settingVC setTitle:title];
            [self.navigationController pushViewController:settingVC animated:YES];
        }
        self.hidesBottomBarWhenPushed = NO;
    }
    
    
#pragma mark 导航栏的显示过滤
    if ((indexPath.section == 1 && indexPath.row == 2) ||
        (indexPath.section == 1 && indexPath.row == 3)) {
        //导航栏需不显示
    }
    else{
        //导航栏需要显示
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark - 推荐给好友
- (void)RecommendAppToFriendsAction{
    
    FMShareView *announceView = [[[NSBundle mainBundle] loadNibNamed:@"FMShareView" owner:self options:nil] firstObject];
    [announceView setFrame:[[UIScreen mainScreen] bounds]];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:announceView];
}
@end
