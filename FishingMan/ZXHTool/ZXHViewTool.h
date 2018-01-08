//
//  ZXHViewTool.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/10.
//  Copyright © 2017年 HongFan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "UIImageView+WebCache.h"
#import "ZXHNaviBarView.h"


@interface ZXHViewTool : NSObject
/**
 *  @author zxh, 17-01-12 23:01:13
 *
 *  加载网络图片，能够显示柔和的动画
 *
 *  @param imv
 *  @param imgUrl
 *  @param img
 */
+ (void)setImageView:(UIImageView *)imv
        WithImageURL:(NSURL *)imgUrl
  AndPlaceHolderName:(NSString *)imgName
      CompletedBlock:(SDExternalCompletionBlock)completedBlock;

+ (void)addNaviBarWithViewStyle:(ZXHNaviBarViewStyle)viewStyle
                      WithColor:(UIColor *)color
                    withTartget:(id)target
                     LeftAction:(SEL)leftAction
                    RightAction:(SEL)rightAction;


+ (void)addNaviBarWithViewStyle:(ZXHNaviBarViewStyle)viewStyle
                        bgColor:(UIColor *)color
                          title:(NSString *)title
                        tartget:(id)target
                leftButtonImage:(NSString *)leftButtonImageName
               rightButtonImage:(NSString *)rightButtonImageName
                     leftAction:(SEL)leftAction
                    rightAction:(SEL)rightAction;


+ (nullable id)customViewWithXIBName:(nullable NSString *)name owner:(nullable id)owner;

#pragma mark 提示语

+ (void)addAlertWithTitle:(NSString *)title
                  message:(NSString *)message
              withTartget:(id)target
          leftActionStyle:(UIAlertActionStyle)leftStyle
         rightActionStyle:(UIAlertActionStyle)rightStyle
        leftActionHandler:(void (^)(UIAlertAction *action))handler
       rightActionHandler:(void (^)(UIAlertAction *action))handler;

//单个action的alert
+ (void)alertViewTitle:(NSString *)title Tartget:(id)target Message:(NSString *)message ActionName:(NSString *)actionName ActionStyle:(UIAlertActionStyle)actionStyle ActionHandler:(void (^ __nullable)(UIAlertAction *action))handler;

//快速成功的HUD提示
+ (void)justOKHUD;

//下拉刷新动画
+ (void)addMJRefreshGifHeader:(UITableView *)tableView selector:(SEL)selector target:(id)target;
+ (void)addMJRefreshGifFooter:(UITableView *)tableView selector:(SEL)selector target:(id)target;
@end
