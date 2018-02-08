//
//  MinePageTableViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/1/5.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "MinePageTableViewController.h"
#import "MinePageSectionHeaderCell.h"  //分区的header
#import "MinePageTableViewCell.h"

#import "FMSingleArticleTypeTableViewController.h"
#import "FMShareView.h"
#import "FMCollectionViewController.h"
#import "FMThanksTableViewController.h"
#import "FMSettingTableViewController.h"
#import "FMAboutUsViewController.h"
#import "FMCooperationViewController.h"
#import "MineUserInfoSettingViewController.h"

#import "FMUserHomeHeaderView.h"
#import "FMLoginUser.h"
#import "FMLoginRegisterViewController.h"

#define kTableHeaderViewHeight 400  //tableHeaderView的高度

#pragma mark 阿里百川意见反馈
#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>
/**
 *  修改为你自己的appkey。
 *  同时，也需要替换yw_1222.jpg这个安全图片。
 */
static NSString * const kAppKey = @"23855996";


@interface MinePageTableViewController ()
{
    NSMutableArray * mine1stArray;
    NSMutableArray * mine2ndArray;
    NSMutableArray * mine3rdArray;
    
    float HEADER_HEIGHT;
    
    NSInteger feedbackUnreadCount;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) YWFeedbackKit *feedbackKit;
@property (strong, nonatomic) FMUserHomeHeaderView * userHomeHeader;
@end

@implementation MinePageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*** 注册表单元 ***/
    [self.tableView registerNib:[UINib nibWithNibName:@"MinePageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MinePageTableViewCell"];
    /*** 列表视图背景 ***/
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:ZXHColorRGB(248, 248, 248, 1)];
    
    /*** 列表去掉多余cell ***/
    UIView *tempfooterview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZXHScreenWidth, 49)];
    tempfooterview.backgroundColor = ZXHColorRGB(248, 248, 248, 1);
    self.tableView.tableFooterView = tempfooterview;
    
    /*** 顶部头像区域 ***/
    CGRect menuframe = CGRectMake(0, 0, ZXHScreenWidth, kTableHeaderViewHeight *ZXHRatioWithReal375);
    UIView *tempFooterView = [[UIView alloc]init];
    tempFooterView.frame = menuframe;
    tempFooterView.clipsToBounds = YES;
    
    self.userHomeHeader = [[[NSBundle mainBundle] loadNibNamed:@"FMUserHomeHeaderView" owner:nil options:nil] firstObject];
    self.userHomeHeader.frame = tempFooterView.bounds;
    self.userHomeHeader.avatarTapActionType = FMUserHomeSettingAvatar;
    [tempFooterView addSubview:self.userHomeHeader];
    
    ZXH_WEAK_SELF
    _userHomeHeader.callBack_userHomeActionType = ^(FMUserHomeActionType userHeaderActionType){
        
        [weakself doUserHomeActionWithType:userHeaderActionType];
    };
    
    [self.tableView beginUpdates];
    self.tableView.tableHeaderView = tempFooterView;
    [self.tableView endUpdates];
    
    
    _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAppKey];
    
    /*** 加载个人中心数据 ***/
    [self loadListData];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    /*** 隐藏顶部导航栏 ***/
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    /*** 请求反馈未读消息数 ***/
    ZXH_WEAK_SELF
    [self.feedbackKit getUnreadCountWithCompletionBlock:^(NSInteger unreadCount, NSError *error) {
        
        CLog(@"请求反馈未读消息数 %ld", unreadCount);
        NSString * countStr = [NSString stringWithFormat:@"%ld", unreadCount];
        feedbackUnreadCount = unreadCount;
        NSMutableDictionary * dic = mine2ndArray[0];
        [dic setObject:countStr forKey:@"keyValue"];
        [dic setObject:@"countType" forKey:@"keyValueType"];
        mine2ndArray[0] = dic;
        
        NSIndexPath * indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
        [weakself.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    //加载头像数据
    [_userHomeHeader reloadData:nil userType:FMUserTypeAdmin];
    
    //加载用户基本信息
    [[CDServerAPIs shareAPI] requestLoginedUserInfoSuccess:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        CLog(@"加载用户基本信息 成功 = %@", responseObject);
        /*
         data =     {
         address = string;
         avatarUrl = "http://diaoyudaxian01.b0.upaiyun.com/asd";
         created = 1509375597000;
         id = 1;
         level = 0;
         modified = 1515681916000;
         nickName = haha;
         orderFieldNextType = ASC;
         point = 0;
         tel = 18782420424;
         yn = 1;
         };
         */
        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
            
            NSDictionary *dic = responseObject[@"data"];
            if(![ZXHTool isNilNullObject:dic]){
                
                FMLoginUser * user = [FMLoginUser mj_objectWithKeyValues:dic];
                [FMLoginUser setCacheUserInfo:user];
            }
        }
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        
        CLog(@"加载用户基本信息 失败 = %@", error.error);
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
}

- (void)doUserHomeActionWithType:(FMUserHomeActionType )actionType{
    
    if(IS_LOGIN_WITHOUT_ALERT){
       
        self.hidesBottomBarWhenPushed = YES;
        
        switch (actionType) {
            case FMUserHomePreviewAvatar:
                
                break;
            case FMUserHomeSettingAvatar:
                //用户信息设置
                [self openUserInfoSettingViewController];
                break;
            case FMUserHomeFollows:
            case FMUserHomeFans:
                //用户关注 和 粉丝
                [self openFollowsOrFansListWithType:actionType];
                break;
            case FMUserHomeActionNormal:
            default:
                break;
        }
        
        self.hidesBottomBarWhenPushed = NO;
    }
}
- (void)openUserInfoSettingViewController{
    
    MineUserInfoSettingViewController * mineUserInfoSettingVC = [[MineUserInfoSettingViewController alloc] initWithNibName:@"MineUserInfoSettingViewController" bundle:nil];
    
    mineUserInfoSettingVC.navigationTitle = @"个人资料";
    
    [self.navigationController pushViewController:mineUserInfoSettingVC animated:YES];
    
    //导航栏需要显示
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)openFollowsOrFansListWithType:(FMUserHomeActionType) actionType{
    
    FMFriendType followType;
    if (actionType == FMUserHomeFollows) {
        followType = FMFriendTypeFollows;
    }
    else {
        followType = FMFriendTypeFans;
    }
    
    FMThanksTableViewController * thanksVC = [[FMThanksTableViewController alloc] initWithNibName:@"FMThanksTableViewController" bundle:nil];
    thanksVC.friendType = followType;
    
    [self.navigationController pushViewController:thanksVC animated:YES];
    
    if (followType == FMFriendTypeFollows) {
        thanksVC.navigationTitle = @"我关注的人";
    }
    else if (followType == FMFriendTypeFans){
        
        thanksVC.navigationTitle = @"我的粉丝";
    }
    
    //导航栏需要显示
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

#pragma mark - 滚动时改变顶部导航栏颜色
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //下拉header撑大
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
    
    //CLog(@"offy = %f, %f", offy, zoomScale);
    
    if (offy < 0) {
        rect.size.width = self.view.frame.size.width * zoomScale;
        rect.size.height = kTableHeaderViewHeight * zoomScale * ZXHRatioWithReal375;
    }
    
    return rect;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    NSMutableArray * mine1stIconArray = [[NSMutableArray alloc] init];;
    NSMutableArray * mine2ndIconArray = [[NSMutableArray alloc] init];;
    NSMutableArray * mine3rdIconArray = [[NSMutableArray alloc] init];;
    
    [mine1stIconArray addObject:@"收藏"];
    [mine1stIconArray addObject:@"我的发帖"];
    [mine1stIconArray addObject:@"我的评论"];
    
    [mine2ndIconArray addObject:@"意见反馈"];
    [mine2ndIconArray addObject:@"支持钓鱼大仙"];
    [mine2ndIconArray addObject:@"推荐给好友"];
    [mine2ndIconArray addObject:@"特别感谢"];
    
    [mine3rdIconArray addObject:@"关于我们"];
    [mine3rdIconArray addObject:@"商务合作"];
    [mine3rdIconArray addObject:@"设置"];
    
    
    
    mine1stArray = [[NSMutableArray alloc] init];
    mine2ndArray = [[NSMutableArray alloc] init];
    mine3rdArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < mine1stNameArray.count; i++) {
        
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
        [tempDic setObject:mine1stNameArray[i] forKey:@"keyName"];
        [tempDic setObject:@"100" forKey:@"keyValue"];
        [tempDic setObject:[NSString stringWithFormat:@"%@icon", mine1stIconArray[i]] forKey:@"keyIconName"];
        [tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"keyFlag"];
        [mine1stArray addObject:tempDic];
    }
    for (int i = 0; i < mine2ndNameArray.count; i++) {
        
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
        [tempDic setObject:mine2ndNameArray[i] forKey:@"keyName"];
        [tempDic setObject:@"" forKey:@"keyValue"];
        [tempDic setObject:[NSString stringWithFormat:@"%@icon", mine2ndIconArray[i]] forKey:@"keyIconName"];
        [tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"keyFlag"];
        [mine2ndArray addObject:tempDic];
    }
    for (int i = 0; i < mine3rdNameArray.count; i++) {
        
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
        [tempDic setObject:mine3rdNameArray[i] forKey:@"keyName"];
        [tempDic setObject:@"" forKey:@"keyValue"];
        [tempDic setObject:[NSString stringWithFormat:@"%@icon", mine3rdIconArray[i]] forKey:@"keyIconName"];
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
        
        if(!IS_LOGIN){
            FMLoginRegisterViewController * loginVC = [[FMLoginRegisterViewController alloc] initWithNibName:@"FMLoginRegisterViewController" bundle:nil];
            loginVC.loginRegisterViewMode = FMLoginRegisterViewMode_PhoneNumCheck;
            [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:loginVC animated:YES completion:^{
            }];
            return;
        }
        else {
            self.hidesBottomBarWhenPushed = YES;
            
            NSMutableDictionary * tempDic = mine1stArray[indexPath.row-1];
            NSString * title = [tempDic objectForKey:@"keyName"];
            
            if ([title isEqualToString:@"收藏"]) {
                FMCollectionViewController * feedbackVC = [[FMCollectionViewController alloc] initWithNibName:@"FMCollectionViewController" bundle:nil];
                [self.navigationController pushViewController:feedbackVC animated:YES];
            }
            else{
                FMSingleArticleTypeTableViewController * oneKindArticleVC = [[FMSingleArticleTypeTableViewController alloc] init];
                oneKindArticleVC.navigationTitle = title;
                oneKindArticleVC.hideNavigationWhenPopOut = YES;
                [self.navigationController pushViewController:oneKindArticleVC animated:YES];
            }
            
            self.hidesBottomBarWhenPushed = NO;
        }
    }

#pragma mark 第二分组
    
    else if (indexPath.section == 1){
        
        if (indexPath.row == 1) {
            //意见反馈
            self.hidesBottomBarWhenPushed = YES;
            
            /** 设置App自定义扩展反馈数据 */
            self.feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
                                         @"visitPath":@"登陆->关于->反馈",
                                         @"userid":@"yourid",
                                         @"应用自定义扩展信息":@"开发者可以根据需要设置不同的自定义信息，方便在反馈系统中查看"};
            
            __weak typeof(self) weakSelf = self;
            [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
                
                if (viewController != nil) {
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
                    [weakSelf presentViewController:nav animated:YES completion:nil];
                    [viewController setCloseBlock:^(UIViewController *aParentController){
                        [aParentController dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    weakSelf.hidesBottomBarWhenPushed = NO;
                }
                else {
                    /** 使用自定义的方式抛出error时，此部分可以注释掉 */
                    NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
                    NSLog(@"%@", title);
                }
            }];
        }
        else if (indexPath.row == 2){
           //支持钓鱼大仙
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%@", APP_BUNDLE_IDENTITY];
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
            thanksVC.navigationTitle = title;
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
    if ((indexPath.section == 1 && indexPath.row == 1) ||
        (indexPath.section == 1 && indexPath.row == 2) ||
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
