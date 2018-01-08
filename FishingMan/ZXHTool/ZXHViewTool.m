//
//  ZXHViewTool.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/10.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "ZXHViewTool.h"
#import "UIImage+GIF.h"
#import "MJRefresh.h"

@implementation ZXHViewTool

/*  @author zxh, 17-01-12 23:01:13
 *
 *  加载网络图片，能够显示柔和的动画
 *
 *  @param imv
 *  @param imgUrl
 *  @param img
 */
+ (void)setImageView:(UIImageView *)imv WithImageURL:(NSURL *)imgUrl AndPlaceHolderName:(NSString *)imgName CompletedBlock:(SDExternalCompletionBlock)completedBlock{
    
    [imv sd_setImageWithPreviousCachedImageWithURL:imgUrl
                                  placeholderImage:[UIImage imageNamed:imgName]
                                           options:SDWebImageRetryFailed
                                          progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * targetURL) {
                                              
                                          } completed:completedBlock];
}

+ (void)addNaviBarWithViewStyle:(ZXHNaviBarViewStyle)viewStyle
                      WithColor:(UIColor *)color
                    withTartget:(id)target
                     LeftAction:(SEL)leftAction
                    RightAction:(SEL)rightAction{
    
    ZXHNaviBarView * _naviBarView = [[[NSBundle mainBundle] loadNibNamed:@"ZXHNaviBarView" owner:self options:nil] firstObject];
    
    [_naviBarView initialViewStyle:viewStyle
                         WithColor:color
                       withTartget:target
                        LeftAction:leftAction
                       RightAction:rightAction];
}

+ (void)addNaviBarWithViewStyle:(ZXHNaviBarViewStyle)viewStyle
                        bgColor:(UIColor *)color
                          title:(NSString *)title
                        tartget:(id)target
                leftButtonImage:(NSString *)leftButtonImageName
               rightButtonImage:(NSString *)rightButtonImageName
                     leftAction:(SEL)leftAction
                    rightAction:(SEL)rightAction;{
    
    ZXHNaviBarView * _naviBarView = [[[NSBundle mainBundle] loadNibNamed:@"ZXHNaviBarView" owner:self options:nil] firstObject];
    
    [_naviBarView initialViewStyle:viewStyle
                             color:color
                             title:title
                           tartget:target
               leftButtonImageName:leftButtonImageName
              rightButtonImageName:rightButtonImageName
                        leftAction:leftAction
                       rightAction:rightAction];
}

+ (id)customViewWithXIBName:(NSString *)name owner:(id)owner{
    
    return [[[NSBundle mainBundle] loadNibNamed:name owner:owner options:nil] firstObject];
}

+ (void)addAlertWithTitle:(NSString*)title
                  message:(NSString*)message
              withTartget:(id)target
          leftActionStyle:(UIAlertActionStyle)leftStyle
         rightActionStyle:(UIAlertActionStyle)rightStyle
        leftActionHandler:(void (^ _Nullable)(UIAlertAction *))leftHandler rightActionHandler:(void (^ _Nullable)(UIAlertAction *))rightHandler{
    
    UIViewController * superVC = (UIViewController *)target;
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                            style:leftStyle
                                                          handler:leftHandler];
    UIAlertAction * comfirmAction = [UIAlertAction actionWithTitle:@"确认"
                                                             style:rightStyle
                                                           handler:rightHandler];
    [alertVC addAction:cancelAction];
    [alertVC addAction:comfirmAction];
    
    [superVC presentViewController:alertVC animated:YES completion:nil];
}

//单个action的alert
+ (void)alertViewTitle:(NSString *)title Tartget:(id)target Message:(NSString *)message ActionName:(NSString *)actionName ActionStyle:(UIAlertActionStyle)actionStyle ActionHandler:(void (^ __nullable)(UIAlertAction *action))handler{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title
                                                                     message:message
                                                              preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * action = [UIAlertAction actionWithTitle:actionName
                                                            style:actionStyle
                                                          handler:handler];
    [alertVC addAction:action];
    
    UIViewController * superVC = (UIViewController *)target;
    [superVC presentViewController:alertVC animated:YES completion:nil];
}

+ (void)justOKHUD{
    
    [PHProgressHUD showSingleCustonImageSetmsg:nil view:nil imageName:@"Checkmark" setSquare:YES];
}

+ (void)addMJRefreshGifHeader:(UITableView *)tableView selector:(SEL)selector target:(id)target{
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:selector];
    
    //1、隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    //2、隐藏状态
    header.stateLabel.hidden = YES;
    
    //3、设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    [header setImages:idleImages forState:MJRefreshStateIdle];
    
    //4、设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [header setImages:refreshingImages forState:MJRefreshStatePulling];
    
    //5、设置正在刷新状态的动画图片
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    tableView.mj_header = header;
}
+ (void)addMJRefreshGifFooter:(UITableView *)tableView selector:(SEL)selector target:(id)target{
    
    MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingTarget:target refreshingAction:selector];
    
//    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:target refreshingAction:selector];
    
    // 隐藏状态
    footer.stateLabel.hidden = YES;
    footer.refreshingTitleHidden = YES;
    footer.automaticallyHidden = YES;
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=60; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_anim__000%zd", i]];
        [idleImages addObject:image];
    }
    [footer setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [footer setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [footer setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    tableView.mj_footer = footer;
}

@end
