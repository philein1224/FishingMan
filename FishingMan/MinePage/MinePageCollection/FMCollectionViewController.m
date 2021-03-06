//
//  FMCollectionViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/3/18.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMCollectionViewController.h"

//文章相关
#import "FishMultiImageCell.h"
#import "FishTwoImageCell.h"
#import "FishSingleImageCell.h"
#import "FishVideoCell.h"
#import "FMArticleModel.h"
#import "CDServerAPIs+MainPage.h"
#import "FMFavoriteArticleTableViewController.h"
#import "FMFavoriteFishSiteTableViewController.h"
#import "FMFavoriteFishStoreTableViewController.h"

//其他的
#import "FMLoginUser.h"
#import "MJRefresh.h"
#import "UIScrollView+EmptyDataSet.h"
#import "FMEmptyNotiView.h"

@interface FMCollectionViewController ()

//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UISegmentedControl * segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray * viewControllersArray;

@property (strong, nonatomic) FMFavoriteArticleTableViewController * favoriteArticleTableCtrl;
@property (strong, nonatomic) FMFavoriteFishSiteTableViewController * fishSiteTableViewController;
@property (strong, nonatomic) FMFavoriteFishStoreTableViewController * fishStoreTableViewController;

@end

@implementation FMCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [ZXHTool barBackButtonItemWithTitle:nil
                                                                          color:[UIColor grayColor]
                                                                          image:ZXHImageName(@"navBackGray")
                                                                      addTarget:self
                                                                         action:@selector(backButtonClicked:)];
    
    //顶部的菜单栏
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"文章",@"钓点",@"渔具店"]];
    [_segmentedControl setSelectedSegmentIndex:0];
    [_segmentedControl addTarget:self action:@selector(topSegmentdControlChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segmentedControl;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //加在三个主要的视图控制器
    [self setTheVC];
}

- (void)backButtonClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 三个主要的视图控制器
- (void)setTheVC{
    
    self.viewControllersArray = [NSMutableArray arrayWithCapacity:3];
    
    //1、文章列表
    _favoriteArticleTableCtrl = [[FMFavoriteArticleTableViewController alloc] initWithNibName:@"FMFavoriteArticleTableViewController" bundle:nil];
    _favoriteArticleTableCtrl.view.frame = CGRectMake(0, 64, ZXHScreenWidth, ZXHScreenHeight);
    [self addChildViewController:_favoriteArticleTableCtrl];
    [self.scrollView addSubview:_favoriteArticleTableCtrl.view];
    [_favoriteArticleTableCtrl didMoveToParentViewController:self];
    [self.viewControllersArray addObject:_favoriteArticleTableCtrl];

        //2、钓点列表
    _fishSiteTableViewController = [[FMFavoriteFishSiteTableViewController alloc] initWithNibName:@"FMFavoriteFishSiteTableViewController" bundle:nil];
    _fishSiteTableViewController.view.frame = CGRectMake(ZXHScreenWidth * 1, 64, ZXHScreenWidth, ZXHScreenHeight);
    [self addChildViewController:_fishSiteTableViewController];
    [self.scrollView addSubview:_fishSiteTableViewController.view];
    [_fishSiteTableViewController didMoveToParentViewController:self];
    [self.viewControllersArray addObject:_fishSiteTableViewController];
    
        //3、渔具店列表
    _fishStoreTableViewController = [[FMFavoriteFishStoreTableViewController alloc] initWithNibName:@"FMFavoriteFishStoreTableViewController" bundle:nil];
    _fishStoreTableViewController.view.frame = CGRectMake(ZXHScreenWidth * 2, 64, ZXHScreenWidth, ZXHScreenHeight);
    [self addChildViewController:_fishStoreTableViewController];
    [self.scrollView addSubview:_fishStoreTableViewController.view];
    [_fishStoreTableViewController didMoveToParentViewController:self];
    [self.viewControllersArray addObject:_fishStoreTableViewController];
    
    //4、contentSize
    self.scrollView.contentSize = CGSizeMake(ZXHScreenWidth * 3, ZXHScreenWidth);
    self.scrollView.pagingEnabled = YES;
}

#pragma mark UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int pageIndex = floor(scrollView.contentOffset.x / ZXHScreenWidth);
    if(pageIndex < 0){
        pageIndex = 0;
    }
    
    [_segmentedControl setSelectedSegmentIndex:pageIndex];
}

#pragma mark 我的收藏标签的切换
/**
 *  @author zxh, 17-03-23 20:03:13
 *
 *  钓点，钓鱼人，渔具店菜单选择方法
 *
 *  @param sender
 */
- (void)topSegmentdControlChanged:(UISegmentedControl *)segCtl {
    
    [self.scrollView setContentOffset:CGPointMake(segCtl.selectedSegmentIndex * ZXHScreenWidth, 0) animated:YES];
}
@end
