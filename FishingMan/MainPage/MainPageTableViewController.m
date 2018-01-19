//
//  MainPageTableViewController.m
//  ZXHTools
//
//  Created by zhangxh on 2016/10/21.
//  Copyright © 2016年 HongFan. All rights reserved.
//

#import "MainPageTableViewController.h"
#import "FMIndexBannerCell.h"
#import "FishMultiImageCell.h"
#import "FishTwoImageCell.h"
#import "FishSingleImageCell.h"
#import "FishVideoCell.h"
#import "FMWeatherViewController.h"
#import "FMArticleDetailViewController.h"

#import "MenuView.h"
#import "EditViewController.h"            //通用的编辑视图
#import "EditFishStoreViewController.h"   //钓鱼渔具商店
#import "EditFishSiteViewController.h"    //钓点编辑

#import "FMVersionUpdate.h"
#import "ZXHWebViewController.h"
#import "ZXHWKWebViewController.h"

#import "FMLoginRegisterViewController.h"
#import "FMLoginUser.h"

#import "MJRefresh.h"
#import "CDServerAPIs+MainPage.h"
#import "FMArticleModel.h"

@interface MainPageTableViewController ()<UIScrollViewDelegate>
{
}
@property (weak, nonatomic) IBOutlet UIButton *editMenuButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UIButton *leftButton;
@property (strong, nonatomic) UIButton *rightButton;

@property (strong, nonatomic) NSMutableArray *sliderDataArray;   //已经加载了的广告数组

@property (assign, nonatomic) BOOL pullingDownward; //向下拉获取最新
@property (assign, nonatomic) int currentPage; //当前加载到第几页
@property (nonatomic, strong) NSMutableArray * articleModelArray; //已经加载的列表数据
@property (assign, nonatomic) int totalCount;  //总共有多少文章
@property (assign, nonatomic) int pageSize;    //每一页有多少条数据

@end

@implementation MainPageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"钓鱼大仙"];
    
    //tableView顶部位置多出64像素的处理
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    _articleModelArray = [[NSMutableArray alloc] init];
    
    
    /*** 顶部左边的地理位置 ***/
    UIImage * image = ZXHImageName(@"mainCityButton");
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setTitleColor:ZXHColorHEX(@"333333", 1) forState:UIControlStateNormal];
    _leftButton.titleLabel.text = [NSString stringWithFormat:@"成都"];
    
    UIFont * font = [_leftButton.titleLabel font];
    font = [font fontWithSize:14];
    [_leftButton.titleLabel setFont:font];
    
    [_leftButton setImage:image forState:UIControlStateNormal];
    [_leftButton setTitle:@"成都" forState:UIControlStateNormal];
    _leftButton.frame = CGRectMake(0, 0, 100, 24);
    
    [_leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 40)];
    [_leftButton setImageEdgeInsets:UIEdgeInsetsMake(5, 35, 5, 5)];
    
    [_leftButton layoutIfNeeded];
    [_leftButton layoutSubviews];
    
    [_leftButton setBackgroundColor:[UIColor clearColor]];
    [_leftButton addTarget:self action:@selector(leftAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
    
    /*** 顶部右边的天气信息 ***/
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setTitleColor:ZXHColorHEX(@"333333", 1) forState:UIControlStateNormal];
    _rightButton.titleLabel.text = [NSString stringWithFormat:@"零散阵雨36℃"];
    font = [_rightButton.titleLabel font];
    font = [font fontWithSize:14];
    [_rightButton.titleLabel setFont:font];
    [_rightButton.titleLabel setTextAlignment:NSTextAlignmentRight];
//    [_rightButton.titleLabel setBackgroundColor:[UIColor lightGrayColor]];
    [_rightButton setTitle:@"零散阵雨11℃" forState:UIControlStateNormal];
    
    _rightButton.frame = CGRectMake(0, 0, 140, 24);
    
    [_rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
    
    [_rightButton addTarget:self action:@selector(rightWeatherVCAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FMIndexBannerCell" bundle:nil] forCellReuseIdentifier:@"FMIndexBannerCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FishMultiImageCell" bundle:nil] forCellReuseIdentifier:@"FishMultiImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FishTwoImageCell" bundle:nil] forCellReuseIdentifier:@"FishTwoImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FishSingleImageCell" bundle:nil] forCellReuseIdentifier:@"FishSingleImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FishVideoCell" bundle:nil] forCellReuseIdentifier:@"FishVideoCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //顶部滚动广告栏
    [self setupTableViewHeaderView];
    
    //加载列表数据
    [ZXHViewTool addMJRefreshGifHeader:self.tableView selector:@selector(topDownloadListData) target:self];
    [ZXHViewTool addMJRefreshGifFooter:self.tableView selector:@selector(bottomUploadListData) target:self];
    
    //获取主页文章的列表
    [self topDownloadListData];
    
    //版本更新说明
//    [self performSelector:@selector(showUpdateNote) withObject:nil afterDelay:1.5];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];    
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    //显示出编辑入口
    ZXH_WEAK_SELF;
    [UIView animateWithDuration:0.5 animations:^{
        
        if (weakself.editMenuButton.alpha != 1.0) {
            weakself.editMenuButton.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
        
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark 顶部滚动广告栏
/**
 *  @author zxh, 17-05-18 17:05:54
 *
 *  顶部滚动广告栏，放在tableView header上边
 */
- (void)setupTableViewHeaderView{
    
    CGRect menuframe = CGRectMake(0, 0, ZXHScreenWidth, ZXHRatioWithReal375 * 154.0);
    UIView *tempFooterView = [[UIView alloc]init];
    [tempFooterView setBackgroundColor:[UIColor greenColor]];
    tempFooterView.frame = menuframe;
    tempFooterView.clipsToBounds = YES;
    
    FMIndexBannerCell * indexBanner = [[[NSBundle mainBundle] loadNibNamed:@"FMIndexBannerCell" owner:nil options:nil] firstObject];
    
    indexBanner.frame = tempFooterView.bounds;
    [tempFooterView addSubview:indexBanner];
    
    NSMutableArray * sliderArrayData = [[NSMutableArray alloc]init];
    for (int i = 0; i < 5; i++) {
        
        NSMutableDictionary * tempDic = [[NSMutableDictionary alloc]init];
        [tempDic setObject:@"https://static.caihang.com/public/appbannerImg/20170705135255微信图片_20170705135151.jpg" forKey:@"img"];                                   //图片地址
        [tempDic setObject:@"我是标题我是标题我是标题" forKey:@"title"];                          //标题
        [tempDic setObject:@"啊哈建设大街上看到哈萨德哈桑空间的哈萨克等哈设计大赛空间啊圣诞节啊上海大世界" forKey:@"content"];                       //文字内容
        [tempDic setObject:@"https://m.caihang.com/toActLink.htm" forKey:@"url"];         //对应网址
        [tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isLoginKey"];  //是否需要登录
        [tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"articleId"];   //文章ID
        [tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"articleType"]; //文章类型
        [sliderArrayData addObject:tempDic];
    }
    indexBanner.dataArray = sliderArrayData;
    [indexBanner reloadData];
    
    ZXH_WEAK_SELF
    indexBanner.cellClickedCallBack =  ^(id info){
        
        [weakself showWebView];
        //            [weakself allClickedDetailMethod:info viewMark:viewMark];
    };
    
    [self.tableView beginUpdates];
    self.tableView.tableHeaderView = tempFooterView;
    [self.tableView endUpdates];
}

#pragma mark 版本更新说明
- (void)showUpdateNote{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        FMVersionUpdate * versionUpdate = [[[NSBundle mainBundle] loadNibNamed:@"FMVersionUpdate" owner:self options:nil] firstObject];
        [versionUpdate setFrame:self.view.bounds];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:versionUpdate];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark  导航栏左右菜单
- (void)leftAction:(id)sender{
    
    FMLoginRegisterViewController * loginVC = [[FMLoginRegisterViewController alloc] initWithNibName:@"FMLoginRegisterViewController" bundle:nil];
    
    loginVC.loginRegisterViewMode = FMLoginRegisterViewMode_PhoneNumCheck;
    
    self.hidesBottomBarWhenPushed = YES;
    [self presentViewController:loginVC animated:YES completion:^{
        
    }];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)rightWeatherVCAction:(id)sender{
    
    FMWeatherViewController * weatherVC = [[FMWeatherViewController alloc] initWithNibName:@"FMWeatherViewController" bundle:nil];
    
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:weatherVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark  显示菜单
- (IBAction)editMenuAction:(UIButton *)menuButton{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if (menuButton.alpha == 1.0) {
            menuButton.alpha = 0.0;
        }
        else{
            menuButton.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
        
    }];
    
    if(IS_LOGIN_WITHOUT_ALERT){
        
        [self showMenu];
    }
}
- (void)showMenu {
    
    //测试代码
    //    [self showEditViewWithType:0];
    //    return;
    
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
    MenuItem *menuItem = [[MenuItem alloc] initWithTitle:@"鱼获展示"
                                                iconName:@"添加_渔获icon"
                                               glowColor:[UIColor grayColor]
                                                   index:0];
    [items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:@"加钓点" iconName:@"添加_钓点icon" glowColor:[UIColor colorWithRed:0.000 green:0.840 blue:0.000 alpha:1.000] index:0];
    [items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:@"加渔具店" iconName:@"添加_渔具店icon" glowColor:[UIColor colorWithRed:0.687 green:0.000 blue:0.000 alpha:1.000] index:0];
    [items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:@"DIY" iconName:@"添加_DIYicon" glowColor:[UIColor colorWithRed:0.687 green:0.000 blue:0.000 alpha:1.000] index:0];
    [items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:@"测评" iconName:@"添加_测评icon" glowColor:[UIColor colorWithRed:0.687 green:0.000 blue:0.000 alpha:1.000] index:0];
    [items addObject:menuItem];
    
    menuItem = [[MenuItem alloc] initWithTitle:@"其他" iconName:@"添加_其他icon" glowColor:[UIColor colorWithRed:0.687 green:0.000 blue:0.000 alpha:1.000] index:0];
    [items addObject:menuItem];
    
    MenuView *menuView = [[MenuView alloc] initWithFrame:self.view.bounds items:items];
    
    ZXH_WEAK_SELF
    
    menuView.didSelectedItemCompletion = ^(MenuItem *selectedItem) {
        
        NSLog(@"index = %ld, %@", selectedItem.index, selectedItem.title);
        CLog(@"index = %ld, %@", selectedItem.index, selectedItem.title);
        [UIView animateWithDuration:0.5 animations:^{
            
            if (weakself.editMenuButton.alpha == 1.0) {
                weakself.editMenuButton.alpha = 0.0;
            }
            else{
                weakself.editMenuButton.alpha = 1.0;
            }
        } completion:^(BOOL finished) {
            
        }];
        
        
        if(selectedItem.title == nil) {
            return;
        }
        
        [weakself showEditViewWithType:selectedItem.index];
        
    };
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [menuView showMenuAtView:window];
}
- (void)showEditViewWithType:(NSInteger)editType{
    
    switch (editType) {
        case 0: {
            
            EditViewController * editViewCtrl = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
            editViewCtrl.articleType = FMArticleTypeHarvest;
            UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:editViewCtrl];
            editViewCtrl.navigationController.navigationBarHidden = YES;
            [self presentViewController:navCtrl animated:YES completion:^{
                
            }];
        }
            break;
        case 1:{
            
            EditFishSiteViewController * editViewCtrl = [[EditFishSiteViewController alloc] initWithNibName:@"EditFishSiteViewController" bundle:nil];
            UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:editViewCtrl];
            editViewCtrl.navigationController.navigationBarHidden = YES;
            [self presentViewController:navCtrl animated:YES completion:^{
                
            }];
        }
            break;
        case 2:{
            
            EditFishStoreViewController * editViewCtrl = [[EditFishStoreViewController alloc] initWithNibName:@"EditFishStoreViewController" bundle:nil];
            UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:editViewCtrl];
            editViewCtrl.navigationController.navigationBarHidden = YES;
            [self presentViewController:navCtrl animated:YES completion:^{
                
            }];
        }
            break;
        case 3:{
            /*** DIY ***/
            
            EditViewController * editViewCtrl = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
            editViewCtrl.articleType = FMArticleTypeDIY;
            UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:editViewCtrl];
            editViewCtrl.navigationController.navigationBarHidden = YES;
            [self presentViewController:navCtrl animated:YES completion:^{
                
            }];
        }
            break;
            
        case 4:{
            
            /*** 测评 ***/
            
            EditViewController * editViewCtrl = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
            editViewCtrl.articleType = FMArticleTypeTest;
            UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:editViewCtrl];
            editViewCtrl.navigationController.navigationBarHidden = YES;
            [self presentViewController:navCtrl animated:YES completion:^{
                
            }];
        }
            break;
            
        case 5:{
            
            /*** 其他 ***/
            
            EditViewController * editViewCtrl = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
            editViewCtrl.articleType = FMArticleTypeQA;
            UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:editViewCtrl];
            editViewCtrl.navigationController.navigationBarHidden = YES;
            [self presentViewController:navCtrl animated:YES completion:^{
                
            }];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark  首页数据加载
//上边的下拉刷新
- (void)topDownloadListData{
    _pullingDownward = YES;
    _currentPage = 1;
    
    [self reloadDataWithPosition:_pullingDownward Page:_currentPage];
}
//下边的上拉刷新
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
    [[CDServerAPIs shareAPI] articleListWithType:-1 currentPage:currentPage Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        CLog(@"主页文章列表 =>>article List = %@", responseObject);
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        
        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
            //判断是否继续
            NSDictionary * dataDic = responseObject[@"data"];
            if([ZXHTool isNilNullObject:dataDic]){
                return;
            }
            
                //取出获取到的新数据
            NSMutableArray *tempArray = [FMArticleModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"result"]];
            if([ZXHTool isNilNullObject:tempArray]){
                return;
            }
            
            weakself.currentPage = [dataDic[@"currentPage"] intValue];
            weakself.totalCount = [dataDic[@"totalCount"] intValue];
            weakself.pageSize = [dataDic[@"pageSize"] intValue];
            
            
            //下拉获取最新
            if(weakself.pullingDownward){
                
                [weakself.tableView.mj_header endRefreshing];
                
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
                
                [weakself.tableView.mj_footer endRefreshing];
                
                if(tempArray.count > 0){
                    NSArray * array = [weakself dealingWithArticleArray: tempArray];
                    [weakself.articleModelArray addObjectsFromArray:array];
                    
                    [weakself.tableView reloadData];
                }
            }
        }
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        CLog(@"首页文章列表：%@", error.error);
        [weakself.tableView.mj_header endRefreshing];
        [weakself.tableView.mj_footer endRefreshing];
        [CDServerAPIs httpDataTask:dataTask error:error.error];
    }];
}
//处理转换文章内容数据
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
        CLog(@"model.推荐图片 = %@, %d", model.contentArray, model.imageCount);
    }
    
    return tempArray;
}


#pragma mark  webView

- (void)showWebView {
    
//    ZXHWebViewController * webViewController = [[ZXHWebViewController alloc] initWithNibName:@"ZXHWebViewController" bundle:nil];
    
    ZXHWKWebViewController * webViewController = [[ZXHWKWebViewController alloc] initWithNibName:@"ZXHWKWebViewController" bundle:nil];
    
    webViewController.urlString = @"https://www.baidu.com";

    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webViewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - UISCrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"1 WillBeginDragging");
    __weak __typeof(self) weakself = self;
    [UIView animateWithDuration:0.5 animations:^{

        weakself.editMenuButton.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
    }];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"3 DidEndDragging");
    //    __weak __typeof(self) weakself = self;
    //    [UIView animateWithDuration:0.5 animations:^{
    //
    //        if (weakself.editMenuButton.alpha == 0.0) {
    //            weakself.editMenuButton.alpha = 1.0;
    //        }
    //    } completion:^(BOOL finished) {
    //        
    //    }];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"2.1 WillBeginDecelerating");
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"2.2 DidEndDecelerating");
    __weak __typeof(self) weakself = self;
    [UIView animateWithDuration:0.5 animations:^{
        
        if (weakself.editMenuButton.alpha != 1.0) {
            weakself.editMenuButton.alpha = 1.0;
        }
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _articleModelArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    if([_articleModelArray[indexPath.row] isEqualToString:@"FMIndexBannerCell"]){
        return ZXHRatioWithReal375 * 154.0;
    }
    else
        */
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
    
//    else if(articleModel.imageCount == 100){
//        return ZXHRatioWithReal375 * 240;
//    }
    else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMArticleModel * articleModel = _articleModelArray[indexPath.row];
    /*
    if([articleModel.articleType isEqualToString:@"FMIndexBannerCell"]){
        
        static NSString *CellIdentifier = @"FMIndexBannerCell";
        
        FMIndexBannerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FMIndexBannerCell" owner:nil options:nil] firstObject];
        }
        
        ZXH_WEAK_SELF
        cell.cellClickedCallBack =  ^(id info){
            
            [weakself showWebView];
//            [weakself allClickedDetailMethod:info viewMark:viewMark];
        };
        
        //如果值未发生变化,则不reloadData.
        //        if (CDIsValidObject(self.realDataArray[indexPath.row]) &&
        //            ![cell.dataArray isEqual:self.realDataArray[indexPath.row]])
        {
            NSMutableArray * sliderArrayData = [[NSMutableArray alloc]init];
            for (int i = 0; i < 5; i++) {
                
                NSMutableDictionary * tempDic = [[NSMutableDictionary alloc]init];
                [tempDic setObject:@"https://static.caihang.com/public/appbannerImg/20170317174933750_309.jpg" forKey:@"img"];                                   //图片地址
                [tempDic setObject:@"我是标题我是标题我是标题" forKey:@"title"];                          //标题
                [tempDic setObject:@"啊哈建设大街上看到哈萨德哈桑空间的哈萨克等哈设计大赛空间啊圣诞节啊上海大世界" forKey:@"content"];                       //文字内容
                [tempDic setObject:@"https://m.caihang.com/toActLink.htm" forKey:@"url"];         //对应网址
                [tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"isLoginKey"];  //是否需要登录
                [tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"articleId"];   //文章ID
                [tempDic setObject:[NSNumber numberWithBool:YES] forKey:@"articleType"]; //文章类型
                [sliderArrayData addObject:tempDic];
            }
            cell.dataArray = sliderArrayData;
            [cell reloadData];
        }
        
        return cell;
    }
    
    else
        */
    
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
    /*
    else if ([CellInfoName isEqualToString:@"FishVideoCell"]){
        
        static NSString *CellIdentifier = @"FishVideoCell";
        
        FishVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FishVideoCell" owner:nil options:nil] firstObject];
        }
        
        return cell;
    }
     */
    
//    
//    //默认的cell
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rootTableViewCellReuseId" forIndexPath:indexPath];
//    cell.textLabel.text = [_articleModelArray objectAtIndex:indexPath.row];
//    return cell;
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FMArticleModel * articleModel = _articleModelArray[indexPath.row];
    
    FMArticleDetailViewController * articleDetailVC = [[FMArticleDetailViewController alloc] initWithNibName:@"FMArticleDetailViewController" bundle:nil];
    articleDetailVC.articleModel = articleModel;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:articleDetailVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}



@end
