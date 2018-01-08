//
//  FMSiteHomepageController.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/22.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMSiteHomepageController.h"
#import "ZXHNaviBarView.h"
#import "FMSiteHomeHeaderView.h"
#import "FMSiteHomeInfoCell.h"
#import "FMLoginUser.h"
#import "FMCommentEditView.h"
#import "FMFishSiteModel.h"
#import "CDServerAPIs+FishSite.h"
#import "CDServerAPIs+MainPage.h"

#define kTableHeaderViewHeight      400  //tableHeaderView的高度

@interface FMSiteHomepageController ()

@property (strong, nonatomic) ZXHNaviBarView * naviBarView;
@property (weak, nonatomic)   IBOutlet UITableView *tableView;
@property (strong, nonatomic) FMSiteHomeHeaderView * siteHomeHeader;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;   //反馈
@property (weak, nonatomic) IBOutlet UIButton *recommendButton;  //推荐
@property (weak, nonatomic) IBOutlet UIButton *commentButton;    //评论
@property (weak, nonatomic) IBOutlet UIButton *collectionButton; //收藏

@end

@implementation FMSiteHomepageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableView顶部位置多出64像素的处理
    self.automaticallyAdjustsScrollViewInsets = NO;
 
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"FMSiteHomeInfoCell" bundle:nil] forCellReuseIdentifier:@"FMSiteHomeInfoCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //左侧返回按钮
//    UIImage *image = [UIImage imageNamed:@"navBackGray"];
//    UIButton *backButtonbig = [ZXHTool buttonFrame:CGRectMake(0, 10, 64, 64) image:image highlightImage:image addTarget:self action:@selector(backButtonClicked)];
//    [self.view addSubview:backButtonbig];
    
    CGRect menuframe = CGRectMake(0, 0, ZXHScreenWidth, kTableHeaderViewHeight *ZXHRatioWithReal375);
    UIView *tempFooterView = [[UIView alloc]init];
    tempFooterView.frame = menuframe;
    tempFooterView.clipsToBounds = YES;
    
    self.siteHomeHeader = [[[NSBundle mainBundle] loadNibNamed:@"FMSiteHomeHeaderView" owner:nil options:nil] firstObject];
    self.siteHomeHeader.frame = tempFooterView.bounds;
    [tempFooterView addSubview:self.siteHomeHeader];
    
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
    
    //统一加载整个页面数据
    [self reloadData];
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
    
    [self reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 底部菜单栏事件
- (IBAction)feedbackAction:(id)sender {
    if(!IS_LOGIN_WITHOUT_ALERT) return;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"反馈"
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil];
    
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"位置有误"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                               
                                                           }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"信息有误"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                               
                                                           }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"钓点重复"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         
                                                     }];
    UIAlertAction * action4 = [UIAlertAction actionWithTitle:@"钓点已关闭"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                               
                                                           }];
    UIAlertAction * action5 = [UIAlertAction actionWithTitle:@"其他反馈"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * _Nonnull action) {
                                                               
                                                               //意见反馈
                                                           }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [alertVC addAction:action3];
    [alertVC addAction:action4];
    [alertVC addAction:action5];

    [self presentViewController:alertVC animated:YES completion:nil];
}

- (IBAction)recommendAction:(id)sender {
    
    if(!IS_LOGIN_WITHOUT_ALERT) return;
    
    //钓点的推荐（点赞）
    
    [PHProgressHUD showSingleCustonImageSetmsg:@"" view:nil imageName:@"Checkmark" setSquare:YES];
    
    FMLoginUser * user = [FMLoginUser getCacheUserInfo];
    BOOL isLike = YES;
    [[CDServerAPIs shareAPI] articleLikeWithSourceId:self.model.ID
                                                type:2
                                                like:isLike
                                              userId:[user.userId longLongValue]
                                              Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
                                                  
                                                  CLog(@"文章点赞成功 = %@", responseObject);
                                                  if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
                                                      
                                                  }else if (![ZXHTool isEmptyString:responseObject[@"msg"]]){
                                                      [CDTopAlertView showMsg:responseObject[@"msg"] alertType:TopAlertViewFailedType];
                                                  }
                                              } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
                                                  [CDServerAPIs httpDataTask:dataTask error:error.error];
                                                  CLog(@"文章点赞失败 = %@", error.error);
                                              }];
}

#pragma mark ----------------评论
- (IBAction)commentAction:(id)sender {
    
    if(!IS_LOGIN_WITHOUT_ALERT) return;
    
    //钓点的评论界面和接口
    ZXH_WEAK_SELF
    [FMCommentEditView shareCommentViewWithTarget:self
                                         callback:^(BOOL show) {
                                         }
                                         callback:^(NSString *content) {
                                         }];
}

- (IBAction)favoritesAction:(id)sender {
    if(!IS_LOGIN_WITHOUT_ALERT) return;
    
    //调用钓点的收藏接口
    [PHProgressHUD showSingleCustonImageSetmsg:@"" view:nil imageName:@"Checkmark" setSquare:YES];
}


#pragma mark ----------------数据请求处理
- (void)reloadData{
    
    if(![ZXHTool isNilNullObject:self.model]){
        //1、header的数据
        self.siteHomeHeader.siteModel = self.model;
        [self.siteHomeHeader reloadData];
        
        //2、cell的数据
        [self.tableView reloadData];
    }
}
- (void)reloadFishSiteDetailWithID:(NSString *) siteId{
    
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] fishSiteDetailWithSiteId:siteId Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
            
            weakself.model = [FMFishSiteModel mj_objectWithKeyValues:responseObject[@"data"]];
            [weakself reloadData];
        }
        else{
            [CDTopAlertView showMsg:@"加载失败，请稍后再试" alertType:TopAlertViewSuccessType];
        }
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        
        [CDServerAPIs httpDataTask:dataTask error:error.error];
    }];
}




#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 430;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1 + 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellId = @"FMSiteHomeInfoCell";
    
    FMSiteHomeInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FMSiteHomeInfoCell" owner:nil options:nil] firstObject];
    }
    
    cell.siteModel = self.model;
    [cell reloadData];
    
    ZXH_WEAK_SELF
    cell.callback = ^(FMTargetPageEventType eventType){
        
        switch (eventType) {
                
            case FMTargetPageEventTypeCall:
            {
                if(![ZXHTool isEmptyString:weakself.model.sitePhone]){
                    NSString * telURL = [NSString stringWithFormat:@"tel:%@", weakself.model.sitePhone];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telURL]];
                }
            }
                break;
            case FMTargetPageEventTypeAddress:
            {
            }
                break;
            case FMTargetPageEventTypeMap:
            {
            }
                break;
                
            default:
                break;
        }
    };
    
    
    return cell;
}

@end
