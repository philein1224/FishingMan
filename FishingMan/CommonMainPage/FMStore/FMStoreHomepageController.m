//
//  FMStoreHomepageController.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/22.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMStoreHomepageController.h"
#import "FMStoreHomeHeaderView.h"
#import "ZXHNaviBarView.h"
#import "FMStoreHomeInfoCell.h"

#import "FMCommentEditView.h"
#import "FMLoginUser.h"
#import "FMFishStoreModel.h"

#import "CDServerAPIs+MainPage.h"
#import "CDServerAPIs+FishStore.h"

#define kTableHeaderViewHeight      400  //tableHeaderView的高度

@interface FMStoreHomepageController ()

@property (strong, nonatomic) ZXHNaviBarView * naviBarView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) FMStoreHomeHeaderView * storeHomeHeader;

@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;   //反馈
@property (weak, nonatomic) IBOutlet UIButton *recommendButton;  //推荐
@property (weak, nonatomic) IBOutlet UIButton *commentButton;    //评论
@property (weak, nonatomic) IBOutlet UIButton *collectionButton; //收藏

@property (weak, nonatomic) IBOutlet UIImageView *recommendIcon; //推荐图标
@property (weak, nonatomic) IBOutlet UIImageView *favoriteIcon;  //收藏

@end

@implementation FMStoreHomepageController

- (void)viewDidLoad {
    [super viewDidLoad];
    //tableView顶部位置多出64像素的处理
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    UIImage *image = [UIImage imageNamed:@"navBackGray"];
//    UIButton *backButtonbig = [ZXHTool buttonFrame:CGRectMake(0, 10, 64, 64) image:image highlightImage:image addTarget:self action:@selector(backButtonClicked)];
//    [self.view addSubview:backButtonbig];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"FMStoreHomeInfoCell" bundle:nil] forCellReuseIdentifier:@"FMStoreHomeInfoCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    CGRect menuframe = CGRectMake(0, 0, ZXHScreenWidth, kTableHeaderViewHeight *ZXHRatioWithReal375);
    UIView *tempFooterView = [[UIView alloc]init];
    tempFooterView.frame = menuframe;
    tempFooterView.clipsToBounds = YES;
    
    self.storeHomeHeader = [[[NSBundle mainBundle] loadNibNamed:@"FMStoreHomeHeaderView" owner:nil options:nil] firstObject];
    self.storeHomeHeader.frame = tempFooterView.bounds;
    
    [tempFooterView addSubview:self.storeHomeHeader];
    
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
    
    [self reloadFishStoreDetailWithID:[NSString stringWithFormat:@"%ld", _fishStoreModel.ID]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonClicked {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 底部菜单栏事件

#pragma mark ----------------渔具店的反馈

- (IBAction)feedbackAction:(id)sender {
    
    if(!IS_LOGIN_WITHOUT_ALERT) return;
    
    ZXH_WEAK_SELF
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"反馈"
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil];
    
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"位置有误"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [weakself sendReportType:FMFeedbackLocationError];
                                                     }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"信息有误"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [weakself sendReportType:FMFeedbackInfoError];
                                                     }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"渔具店重复"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [weakself sendReportType:FMFeedbackInfoRepeated];
                                                     }];
    UIAlertAction * action4 = [UIAlertAction actionWithTitle:@"渔具店已关闭"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [weakself sendReportType:FMFeedbackClosed];
                                                     }];
    UIAlertAction * action5 = [UIAlertAction actionWithTitle:@"其他反馈"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [weakself sendReportType:FMFeedbackOther];
                                                     }];
    [alertVC addAction:cancelAction];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [alertVC addAction:action3];
    [alertVC addAction:action4];
    [alertVC addAction:action5];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)sendReportType:(FMReportType)reportType{
    
    FMLoginUser * user = [FMLoginUser getCacheUserInfo];
    
    [[CDServerAPIs shareAPI] reportAndFeedbackWithReportType:reportType
                                                    sourceId:_fishStoreModel.ID
                                                  sourceType:FMSourceFishStoreType
                                                      userId:[user.userId longLongValue]
                                                     Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
                                                         
                                                         if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
                                                             
                                                             [CDTopAlertView showMsg:@"反馈成功" alertType:TopAlertViewSuccessType];
                                                         }else if (![ZXHTool isEmptyString:responseObject[@"msg"]]){
                                                             [CDTopAlertView showMsg:responseObject[@"msg"] alertType:TopAlertViewFailedType];
                                                         }
                                                         else{
                                                             [CDTopAlertView showMsg:@"反馈失败，请稍后再试" alertType:TopAlertViewFailedType];
                                                         }
                                                     } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
                                                         [CDServerAPIs httpDataTask:dataTask error:error.error];
                                                         [CDTopAlertView showMsg:@"反馈失败，请稍后再试" alertType:TopAlertViewFailedType];
                                                     }];
}

#pragma mark ----------------推荐点赞

- (IBAction)recommendAction:(id)sender {
    
    if(!IS_LOGIN_WITHOUT_ALERT) return;
    
    //渔具店的推荐（点赞）
    [PHProgressHUD showSingleCustonImageSetmsg:@"" view:nil imageName:@"Checkmark" setSquare:YES];
    
    FMLoginUser * user = [FMLoginUser getCacheUserInfo];
    [[CDServerAPIs shareAPI] articleLikeWithSourceId:_fishStoreModel.ID
                                                type:FMSourceFishStoreType
                                                like:YES //默认只能点赞
                                              userId:[user.userId longLongValue]
                                             Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
                                                 
                                                 CLog(@"渔具店的推荐（点赞）成功 = %@", responseObject);
                                                 if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
                                                     
                                                 }else if (![ZXHTool isEmptyString:responseObject[@"msg"]]){
                                                     [CDTopAlertView showMsg:responseObject[@"msg"] alertType:TopAlertViewFailedType];
                                                 }
                                             } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
                                                 [CDServerAPIs httpDataTask:dataTask error:error.error];
                                                 CLog(@"渔具店的推荐（点赞）失败 = %@", error.error);
                                             }];
}

#pragma mark ----------------评论

- (IBAction)commentAction:(id)sender {
    if(!IS_LOGIN_WITHOUT_ALERT) return;
    
    //渔具店的评论界面和接口
    ZXH_WEAK_SELF
    [FMCommentEditView shareCommentViewWithTarget:self
                                         callback:^(BOOL show) {
                                             
                                         }
                                         callback:^(NSString *content) {
                                             if (![ZXHTool isEmptyString:content]) {
                                                 [weakself sendComment: content];
                                             }
                                         }];
}
- (void)sendComment:(NSString *)content{
    
    FMLoginUser * user = [FMLoginUser getCacheUserInfo];
    
    [[CDServerAPIs shareAPI] commentPublishWithSourceId:_fishStoreModel.ID
                                             sourceType:FMSourceFishStoreType
                                                Content:content
                                             FromUserId:[user.userId longLongValue]
                                           FromUserName:user.nickName
                                          FromUserAvtor:user.avatarUrl
                                               ToUserId:18
                                                Success:^(NSURLSessionDataTask *dataTask, id responseObject)
     {
         if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
             
             [CDTopAlertView showMsg:@"发送成功" alertType:TopAlertViewSuccessType];
         }else if (![ZXHTool isEmptyString:responseObject[@"msg"]]){
             [CDTopAlertView showMsg:responseObject[@"msg"] alertType:TopAlertViewFailedType];
         }
         else{
             [CDTopAlertView showMsg:@"发送失败" alertType:TopAlertViewFailedType];
         }
     }
                                                Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error)
     {
         [CDServerAPIs httpDataTask:dataTask error:error.error];
         [CDTopAlertView showMsg:@"发送失败" alertType:TopAlertViewFailedType];
     }];
}

#pragma mark ----------------收藏

- (IBAction)favoritesAction:(id)sender {
    if(!IS_LOGIN_WITHOUT_ALERT) return;
    
    //调用钓点的收藏接口
    [PHProgressHUD showSingleCustonImageSetmsg:@"" view:nil imageName:@"Checkmark" setSquare:YES];
    if(!IS_LOGIN_WITHOUT_ALERT) return;
    
    FMLoginUser * user = [FMLoginUser getCacheUserInfo];
    
    BOOL isCollected = _fishStoreModel.collected;
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] articleFavorit:isCollected
                                   sourceId:_fishStoreModel.ID
                                       type:FMSourceFishStoreType
                                     userId:[user.userId longLongValue]
                                    Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
                                        
                                        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
                                            
                                            if(isCollected){
                                                CLog(@"取消收藏 = %@", responseObject);
                                                weakself.favoriteIcon.image = ZXHImageName(@"收藏_normal");
                                                weakself.fishStoreModel.collected = NO;
                                            }
                                            else{
                                                CLog(@"收藏 = %@", responseObject);
                                                weakself.favoriteIcon.image = ZXHImageName(@"收藏_highlight");
                                                weakself.fishStoreModel.collected = YES;
                                            }
                                        }else if (![ZXHTool isEmptyString:responseObject[@"msg"]]){
                                            [CDTopAlertView showMsg:responseObject[@"msg"] alertType:TopAlertViewFailedType];
                                        }
                                    }
                                    Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
                                        [CDServerAPIs httpDataTask:dataTask error:error.error];
                                    }];
}

#pragma mark ----------------数据请求处理
#pragma mark ----------------钓点详情请求处理

- (void)reloadFishStoreDetailWithID:(NSString *) siteId{
    
    ZXH_WEAK_SELF
    
    //登录用户的userId
    NSString * userId = @"";
    FMLoginUser * user = [FMLoginUser getCacheUserInfo];
    if (![ZXHTool isNilNullObject:user]) {
        userId = user.userId;
    }
    
    [[CDServerAPIs shareAPI] fishStoreDetailWithUserId:userId
                                                SiteId:siteId
                                               Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
            
            weakself.fishStoreModel = [FMFishStoreModel mj_objectWithKeyValues:responseObject[@"data"]];
            [weakself reloadData];
        }
        else{
            [CDTopAlertView showMsg:@"加载失败，请稍后再试" alertType:TopAlertViewSuccessType];
        }
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        
        [CDServerAPIs httpDataTask:dataTask error:error.error];
    }];
}

//页面刷新
- (void)reloadData{
    
    if(![ZXHTool isNilNullObject:_fishStoreModel]){
        //1、header的数据
        self.storeHomeHeader.storeModel = _fishStoreModel;
        [self.storeHomeHeader reloadData];
        
        //2、cell的数据
        [self.tableView reloadData];
    }
}

#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 334;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1 + 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellId = @"FMStoreHomeInfoCell";
    
    FMStoreHomeInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FMStoreHomeInfoCell" owner:nil options:nil] firstObject];
    }
    
    cell.storeModel = _fishStoreModel;
    [cell reloadData];
    
    ZXH_WEAK_SELF
    cell.callback = ^(FMTargetPageEventType eventType){
        
        switch (eventType) {
                
            case FMTargetPageEventTypeCall:
            {
                if(![ZXHTool isEmptyString:weakself.fishStoreModel.sitePhone]){
                    NSString * telURL = [NSString stringWithFormat:@"tel:%@", weakself.fishStoreModel.sitePhone];
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
