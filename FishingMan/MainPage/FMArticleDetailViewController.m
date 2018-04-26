//
//  FMArticleDetailViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/3/15.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMArticleDetailViewController.h"
#import "FMShareView.h"
#import "FMCommentEditView.h"

#import "FMArticleContentViewController.h"
#import "FMCommentListViewController.h"
#import "FMLoginUser.h"
#import "FMArticleModel.h"
#import "CDServerAPIs+MainPage.h"

@interface FMArticleDetailViewController ()<UIScrollViewDelegate>{

}

@property (assign, nonatomic) BOOL isInCommentEditMode;
@property (strong, nonatomic) NSMutableArray *viewControllersArray;
@property (strong, nonatomic) FMArticleContentViewController *articleContentViewController;
@property (strong, nonatomic) FMCommentListViewController    *commentListViewController;
@property (strong, nonatomic) UIButton * shareButton;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UILabel *commentNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *enjoyIcon;
@property (weak, nonatomic) IBOutlet UILabel *enjoyNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *favoriteIcon;

@property (copy, nonatomic) NSArray  * commentModelArray;  //评论列表内容

@end

@implementation FMArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitle = @"文章详情";
    
    self.navigationItem.leftBarButtonItem = [ZXHTool barBackButtonItemWithTitle:nil
                                                                          color:[UIColor grayColor]
                                                                          image:ZXHImageName(@"navBackGray")
                                                                      addTarget:self
                                                                         action:@selector(backButtonClicked:)];
    
    
    self.shareButton = [ZXHTool buttonFrame:CGRectMake(0, 0, 40, 40)
                                      image:ZXHImageName(@"MainPage_分享")
                             highlightImage:nil
                                  addTarget:self
                                     action:@selector(shareButtonClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
    
    //tableView顶部位置多出64像素的处理
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    //设置scrollview的参数
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.frame = CGRectMake(0, 0, ZXHScreenWidth, ZXHScreenHeight-64-44);
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(ZXHScreenWidth, ZXHScreenHeight-64-44);
    [self.view addSubview:self.scrollView];
    
    //评论列表
    self.commentModelArray = [[NSMutableArray alloc]init];
    
    //子视图
    self.viewControllersArray = [NSMutableArray arrayWithCapacity:2];
    [self loadVC];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] articleDetailWithArticleId:_articleModel.ID Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        CLog(@"文章详情 %@", responseObject);
        
        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
            
            weakself.articleModel = [FMArticleModel mj_objectWithKeyValues:responseObject[@"data"]];
            [weakself reloadDetailViewWithDetailModel];
        }else if (![ZXHTool isEmptyString:responseObject[@"msg"]]){
            [CDTopAlertView showMsg:responseObject[@"msg"] alertType:TopAlertViewFailedType];
        }
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        
        [CDServerAPIs httpDataTask:dataTask error:error.error];
    }];
}

- (void)reloadDetailViewWithDetailModel{
    
    //评论
    _commentNumLabel.text = [NSString stringWithFormat:@"%d", _articleModel.commentCount];
    
    //点赞
    _enjoyNumLabel.text = [NSString stringWithFormat:@"%d", _articleModel.likeCount];
    
    if (_articleModel.liked) {
        _enjoyIcon.image = ZXHImageName(@"点赞_highlight");
    }
    else{
        _enjoyIcon.image = ZXHImageName(@"点赞_normal");
    }
    
    //是否收藏
    if (_articleModel.collectioned) {
        _favoriteIcon.image = ZXHImageName(@"收藏_highlight");
    }
    else{
        _favoriteIcon.image = ZXHImageName(@"收藏_normal");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadVC{
    
    //重新调用此方的时候,需要重置一下vc的属性
    for (UIViewController *vc in self.viewControllersArray) {
        
        [vc willMoveToParentViewController:nil];
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
    }
    
    [self.viewControllersArray removeAllObjects];
    self.viewControllersArray = nil;
    
    //创建数组
    self.viewControllersArray = [NSMutableArray arrayWithCapacity:2];
    
    //文章详情
    _articleContentViewController = [[FMArticleContentViewController alloc] initWithNibName:@"FMArticleContentViewController" bundle:nil];
    _articleContentViewController.articleModel = self.articleModel;
    _articleContentViewController.view.frame = CGRectMake(ZXHScreenWidth * 0, 0, ZXHScreenWidth, ZXHScreenHeight-64-44);
    [self addChildViewController:_articleContentViewController];
    [self.scrollView addSubview:_articleContentViewController.view];
    [_articleContentViewController didMoveToParentViewController:self];
    [self.viewControllersArray addObject:_articleContentViewController];
    
    //评论列表
    _commentListViewController = [[FMCommentListViewController alloc] initWithNibName:@"FMCommentListViewController" bundle:nil];
    _commentListViewController.articleModel = self.articleModel;
    _commentListViewController.view.frame = CGRectMake(ZXHScreenWidth * 1, 0, ZXHScreenWidth, ZXHScreenHeight-64-44);
    [self addChildViewController:_commentListViewController];
    [self.scrollView addSubview:_commentListViewController.view];
    [_commentListViewController didMoveToParentViewController:self];
    [self.viewControllersArray addObject:_commentListViewController];
    
    //评论列表里面的回复事件
    ZXH_WEAK_SELF
    _commentListViewController.replyActionBlock = ^(id info) {
    
        [weakself commentButtonClicked:nil];
    };
    
    /*** 住滚动视图的contentSize ***/
    self.scrollView.contentSize = CGSizeMake(ZXHScreenWidth * 2, ZXHScreenHeight-64-44);
}

#pragma mark ----------------返回上一页
- (void)backButtonClicked:(UIButton *)sender{
    
    if(_isInCommentEditMode == YES){
        return;
    }
    
    if(self.scrollView.contentOffset.x == 0.0){
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        
        self.scrollView.contentOffset = CGPointMake(ZXHScreenWidth, 0);
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark ----------------分享
- (void)shareButtonClicked:(UIButton *)sender{
    
    if(_isInCommentEditMode == YES){
        return;
    }
    
    FMShareView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"FMShareView" owner:self options:nil] firstObject];
    [shareView setFrame:self.view.bounds];
    
    ZXH_WEAK_SELF
    shareView.articleReportBlock = ^{
        [weakself feedbackAction];
    };
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:shareView];
}

#pragma mark ----------------举报
- (IBAction)feedbackAction{
    
    if(!IS_LOGIN_WITHOUT_ALERT) return;
    
    ZXH_WEAK_SELF
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"举报"
                                                                     message:nil
                                                              preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:nil];
    
    UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"政治"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [weakself sendReportType:FMReportPolitics];
                                                     }];
    UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"宗教"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [weakself sendReportType:FMReportReligion];
                                                     }];
    UIAlertAction * action3 = [UIAlertAction actionWithTitle:@"恐怖极端"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [weakself sendReportType:FMReportHorror];
                                                     }];
    UIAlertAction * action4 = [UIAlertAction actionWithTitle:@"暴力"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [weakself sendReportType:FMReportViolence];
                                                     }];
    UIAlertAction * action5 = [UIAlertAction actionWithTitle:@"色情"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [weakself sendReportType:FMReportPornographic];
                                                     }];
    UIAlertAction * action6 = [UIAlertAction actionWithTitle:@"其他"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                         [weakself sendReportType:FMReportOther];
                                                     }];
    
    [alertVC addAction:cancelAction];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [alertVC addAction:action3];
    [alertVC addAction:action4];
    [alertVC addAction:action5];
    [alertVC addAction:action6];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)sendReportType:(FMReportType)reportType{
    
    [[CDServerAPIs shareAPI] reportAndFeedbackWithReportType:reportType
                                                    sourceId:_articleModel.ID
                                                  sourceType:FMSourceArticleType
                                                     Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
                                                         
                                                         if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
                                                             
                                                             [CDTopAlertView showMsg:@"举报成功" alertType:TopAlertViewSuccessType];
                                                         }else if (![ZXHTool isEmptyString:responseObject[@"msg"]]){
                                                             [CDTopAlertView showMsg:responseObject[@"msg"] alertType:TopAlertViewFailedType];
                                                         }
                                                         else{
                                                             [CDTopAlertView showMsg:@"举报失败，请稍后再试" alertType:TopAlertViewFailedType];
                                                         }
                                                     } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
                                                         [CDServerAPIs httpDataTask:dataTask error:error.error];
                                                         [CDTopAlertView showMsg:@"举报失败，请稍后再试" alertType:TopAlertViewFailedType];
                                                     }];
}


#pragma mark ----------------发送评论

- (void)sendComment:(NSString *)content{
    
    if(!IS_LOGIN_WITH_ALERT) {
        return;
    }
    
#warning ToUserId
    
    FMLoginUser * user = [FMLoginUser getCacheUserInfo];
    
    [[CDServerAPIs shareAPI] commentPublishWithSourceId:_articleModel.ID
                                             sourceType:FMSourceArticleType
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

- (void)qqExpressionAction:(id)content{
    
}

- (IBAction)commentButtonClicked:(id)sender {
    
    if(!IS_LOGIN_WITHOUT_ALERT) return;
    
    _isInCommentEditMode = YES;
    
    ZXH_WEAK_SELF
    [FMCommentEditView shareCommentViewWithTarget:self
                                         callback:^(BOOL show) {
                                             
                                            weakself.isInCommentEditMode = NO;
                                         }
                                         callback:^(NSString *content) {
                                             
                                             [weakself sendComment:content];
                                         }];
}

#pragma mark ----------------评论列表显示和隐藏
- (IBAction)commentListViewShowButtonClicked:(id)sender {
    
    if(self.scrollView.contentOffset.x == ZXHScreenWidth){
        
        self.scrollView.contentOffset = CGPointMake(ZXHScreenWidth, 0);
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        
        self.scrollView.contentOffset = CGPointMake(0, 0);
        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.contentOffset = CGPointMake(ZXHScreenWidth, 0);
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark ----------------点赞
- (IBAction)enjoyButtonClicked:(id)sender {
    
    if(!IS_LOGIN_WITHOUT_ALERT) return;
    
    BOOL isLiked = self.articleModel.liked;
    
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] contentLikeWithSourceId:_articleModel.ID
                                          SourceType:1
                                                Like:!isLiked
      Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
          if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
              
              if (isLiked) {
                  CLog(@"文章取消点赞成功 = %@", responseObject);
                  weakself.enjoyIcon.image = ZXHImageName(@"点赞_normal");
                  weakself.articleModel.liked = NO;
              }
              else{
                  CLog(@"文章点赞成功 = %@", responseObject);
                  weakself.enjoyIcon.image = ZXHImageName(@"点赞_highlight");
                  weakself.articleModel.liked = YES;
              }
          }else if (![ZXHTool isEmptyString:responseObject[@"msg"]]){
              [CDTopAlertView showMsg:responseObject[@"msg"] alertType:TopAlertViewFailedType];
          }
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        [CDServerAPIs httpDataTask:dataTask error:error.error];
        CLog(@"文章点赞失败 = %@", error.error);
    }];
}

#pragma mark ----------------收藏
- (IBAction)favoriteButtonClicked:(id)sender {
    
    if(!IS_LOGIN_WITHOUT_ALERT) return;
    
    BOOL isCollected = self.articleModel.collectioned;
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] contentFavorite:isCollected
                                   sourceId:_articleModel.ID
                                       type:FMSourceArticleType
                                    Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
                                        
                                        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
                                            
                                            if(isCollected){
                                                CLog(@"取消收藏 = %@", responseObject);
                                                weakself.favoriteIcon.image = ZXHImageName(@"收藏_normal");
                                                weakself.articleModel.collectioned = NO;
                                            }
                                            else{
                                                CLog(@"收藏 = %@", responseObject);
                                                weakself.favoriteIcon.image = ZXHImageName(@"收藏_highlight");
                                                weakself.articleModel.collectioned = YES;
                                            }
                                        }else if (![ZXHTool isEmptyString:responseObject[@"msg"]]){
                                            [CDTopAlertView showMsg:responseObject[@"msg"] alertType:TopAlertViewFailedType];
                                        }
                                    }
                                    Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
                                        [CDServerAPIs httpDataTask:dataTask error:error.error];
                                    }];
}


@end
