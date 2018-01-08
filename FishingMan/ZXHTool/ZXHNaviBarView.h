//
//  ZXHNaviBarView.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/28.
//  Copyright © 2017年 HongFan. All rights reserved.
//

//直接接入代码
/*
 
 #import "ZXHNaviBarView.h"
 
 @property (strong, nonatomic) ZXHNaviBarView * naviBarView;
 
 
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 ......
 
 _naviBarView = [[[NSBundle mainBundle] loadNibNamed:@"ZXHNaviBarView" owner:self options:nil] firstObject];
 
 [_naviBarView initialViewStyle:3
 WithColor:[UIColor whiteColor]
 withTartget:self
 LeftAction:@selector(backButtonClicked)
 RightAction:nil];
 
 ......
 
 }
 
 - (void)viewWillAppear:(BOOL)animated{
 
 [super viewWillAppear:animated];
 
 [self.navigationController setNavigationBarHidden:YES animated:YES];
 
 [_naviBarView updateWithScrollViewContentOffsetY:10000];
 
 }
 
 
 #pragma mark - 滚动时改变顶部导航栏颜色
 - (void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
 if(scrollView.contentOffset.y <= 64){
 
 [_naviBarView updateWithScrollViewContentOffsetY:scrollView.contentOffset.y];
 }
 else{
 [_naviBarView updateWithScrollViewContentOffsetY:64];
 }
 }
 
 
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ZXHNaviBarViewStyle)
{
    ZXHNaviBarStyleColorStatic = 0,         //固定颜色不动
    ZXHNaviBarStyleColorChange = 1,         //固定颜色变化
    
    ZXHNaviBarStyleBlurStatic = 2,          //固定模糊不变化
    ZXHNaviBarStyleBlurChange = 3,          //模糊变化
};

typedef NS_ENUM(NSInteger, ZXHNaviBarViewShiftStyle){

    ZXHNaviBarStyleShiftStatic = 0,      //固定位置
    ZXHNaviBarStyleShiftUp = 1,          //往上移动
    ZXHNaviBarStyleShiftDown = 2,        //往下移动
};


@interface ZXHNaviBarView : UIView

- (void)initialViewStyle:(ZXHNaviBarViewStyle)viewStyle
                   color:(UIColor *)color
                   title:(NSString *)title
                 tartget:(id)target
     leftButtonImageName:(NSString *)LImageName
    rightButtonImageName:(NSString *)RImageName
              leftAction:(SEL)lAction
             rightAction:(SEL)rAction;

- (void)initialViewStyle:(ZXHNaviBarViewStyle)viewStyle
               WithColor:(UIColor *)color
             withTartget:(id)target
              LeftAction:(SEL)action
             RightAction:(SEL)action;
- (void)updateWithScrollViewContentOffsetY:(float)offsetY;
@end
