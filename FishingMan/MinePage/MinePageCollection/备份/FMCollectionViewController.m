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

//钓点相关
#import "LocalFishSiteTBCell.h"
#import "FMSiteHomepageController.h"
#import "FMFishSiteModel.h"
#import "CDServerAPIs+FishSite.h"

//渔具店相关
#import "LocalFishStoreTBCell.h"
#import "FMStoreHomepageController.h"
#import "FMFishStoreModel.h"
#import "CDServerAPIs+FishStore.h"

//其他的
#import "FMLoginUser.h"
#import "MJRefresh.h"
#import "UIScrollView+EmptyDataSet.h"
#import "FMEmptyNotiView.h"

@interface FMCollectionViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    UISegmentedControl * segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"文章",@"钓点",@"渔具店"]];
    [segmentedControl setSelectedSegmentIndex:0];
    [segmentedControl addTarget:self action:@selector(topSegmentdControlChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
}

- (void)backButtonClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
    
    NSLog(@"收藏菜单选择 %ld", segCtl.selectedSegmentIndex);
    
}


#pragma mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    
    if(!cell){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
    }
    
    return cell;
    
//
//    if(!cell){
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"FMSiteHomeInfoCell" owner:nil options:nil] firstObject];
//    }
    
    return nil;
}

@end
