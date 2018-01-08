//
//  FMUserHomepageController.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/22.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMUserHomepageController.h"
#import "FMUserHomeHeaderView.h"

#import "FishMultiImageCell.h"
#import "FishTwoImageCell.h"
#import "FishSingleImageCell.h"
#import "FishVideoCell.h"

#import "ZXHNaviBarView.h"
#define kTableHeaderViewHeight 400  //tableHeaderView的高度

#import "FMArticleDetailViewController.h"

@interface FMUserHomepageController()
{
    NSMutableArray * menuTitleArray;
}

@property (strong, nonatomic) ZXHNaviBarView * naviBarView;

@property (weak, nonatomic)   IBOutlet UITableView *tableView;

@property (strong, nonatomic) FMUserHomeHeaderView * userHomeHeader;

@end

@implementation FMUserHomepageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableView顶部位置多出64像素的处理
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    UIImage *image = [UIImage imageNamed:@"navBackGray"];
//    UIButton *backButtonbig = [ZXHTool buttonFrame:CGRectMake(0, 10, 64, 64) image:image highlightImage:image addTarget:self action:@selector(backButtonClicked)];
//    [self.view addSubview:backButtonbig];
    
    
    menuTitleArray = [[NSMutableArray alloc] init];
    [menuTitleArray addObject:@"FishMultipleImageCell"];
    [menuTitleArray addObject:@"FishTwoImageCell"];
    [menuTitleArray addObject:@"FishSingleImageCell"];
    [menuTitleArray addObject:@"FishSingleImageCell"];
    [menuTitleArray addObject:@"FishSingleImageCell"];
    [menuTitleArray addObject:@"FishVideoCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FishMultiImageCell" bundle:nil] forCellReuseIdentifier:@"FishMultiImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FishTwoImageCell" bundle:nil] forCellReuseIdentifier:@"FishTwoImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FishSingleImageCell" bundle:nil] forCellReuseIdentifier:@"FishSingleImageCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FishVideoCell" bundle:nil] forCellReuseIdentifier:@"FishVideoCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    CGRect menuframe = CGRectMake(0, 0, ZXHScreenWidth, kTableHeaderViewHeight *ZXHRatioWithReal375);
    UIView *tempFooterView = [[UIView alloc]init];
    tempFooterView.frame = menuframe;
    tempFooterView.clipsToBounds = YES;
    
    self.userHomeHeader = [[[NSBundle mainBundle] loadNibNamed:@"FMUserHomeHeaderView" owner:nil options:nil] firstObject];
    self.userHomeHeader.frame = tempFooterView.bounds;
    self.userHomeHeader.avatarTapActionType = FMUserHomePreviewAvatar;
    [tempFooterView addSubview:self.userHomeHeader];
    
    ZXH_WEAK_SELF
    _userHomeHeader.callBack_userHomeActionType = ^(FMUserHomeActionType userHeaderActionType){
        
//        [weakself doUserHomeActionWithType:userHeaderActionType];
        
        CLog(@"放大头像");
        
    };
    
    [self.tableView beginUpdates];
    self.tableView.tableHeaderView = tempFooterView;
    [self.tableView endUpdates];
    
    //自定义导航栏
    _naviBarView = [[[NSBundle mainBundle] loadNibNamed:@"ZXHNaviBarView" owner:self options:nil] firstObject];
    [_naviBarView initialViewStyle:3
                         WithColor:[UIColor whiteColor]
                       withTartget:self
                        LeftAction:@selector(backButtonClicked)
                       RightAction:nil];
}

#pragma mark - 滚动时改变顶部导航栏颜色
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //1
    [_tableView.tableHeaderView viewWithTag:1000].frame = [self calculateFrameWithOffY:_tableView.contentOffset.y];
    CGPoint center = [_tableView.tableHeaderView viewWithTag:1000].center;
    center.x = self.view.frame.size.width / 2;
    [_tableView.tableHeaderView viewWithTag:1000].center = center;
    
    //2
    [_naviBarView updateWithScrollViewContentOffsetY:scrollView.contentOffset.y];
}

#pragma mark - Others （其他）
- (CGRect)calculateFrameWithOffY:(CGFloat)offy {
    
    //2.缩放比例计算
    CGFloat zoomScale = -offy / self.tableView.frame.size.height + 1;
    
    CGRect rect = [_tableView.tableHeaderView viewWithTag:1000].frame;
    
    //CLog(@"offy = %f, %f", offy, zoomScale);
    
    if (offy < 0) {
        rect.size.width = self.view.frame.size.width * zoomScale;
        rect.size.height = kTableHeaderViewHeight * zoomScale * ZXHRatioWithReal375;
    }
    
    return rect;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [_naviBarView updateWithScrollViewContentOffsetY:10000];
    
    //加载头像数据
    [_userHomeHeader reloadData:nil userType:FMUserTypeFriend];
}

- (void)backButtonClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([menuTitleArray[indexPath.row] isEqualToString:@"FishMultipleImageCell"]){
        return ZXHRatioWithReal375 * 194;
    }
    else if([menuTitleArray[indexPath.row] isEqualToString:@"FishTwoImageCell"]){
        return ZXHRatioWithReal375 * 194;
    }
    else if([menuTitleArray[indexPath.row] isEqualToString:@"FishSingleImageCell"]){
        return ZXHRatioWithReal375 * 150;
    }
    else if([menuTitleArray[indexPath.row] isEqualToString:@"FishVideoCell"]){
        return ZXHRatioWithReal375 * 240;
    }
    else{
        return 44;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return menuTitleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellInfoName = menuTitleArray[indexPath.row];
    
    if([CellInfoName isEqualToString:@"FishMultipleImageCell"]){
        
        static NSString *CellIdentifier = @"FishMultiImageCell";
        
        FishMultiImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FishMultiImageCell" owner:nil options:nil] firstObject];
        }
        
        return cell;
    }
    else if ([CellInfoName isEqualToString:@"FishTwoImageCell"]){
        
        static NSString *CellIdentifier = @"FishTwoImageCell";
        
        FishTwoImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FishTwoImageCell" owner:nil options:nil] firstObject];
        }
        
        return cell;
    }
    else if ([CellInfoName isEqualToString:@"FishSingleImageCell"]){
        
        static NSString *CellIdentifier = @"FishSingleImageCell";
        
        FishSingleImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FishSingleImageCell" owner:nil options:nil] firstObject];
        }
        
        return cell;
        
    }
    else if ([CellInfoName isEqualToString:@"FishVideoCell"]){
        
        static NSString *CellIdentifier = @"FishVideoCell";
        
        FishVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if(!cell){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"FishVideoCell" owner:nil options:nil] firstObject];
        }
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    
    FMArticleDetailViewController * articleDetailVC = [[FMArticleDetailViewController alloc] initWithNibName:@"FMArticleDetailViewController" bundle:nil];
    
    [self.navigationController pushViewController:articleDetailVC animated:YES];
    
    //导航栏需要显示
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
@end
