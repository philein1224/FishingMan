//
//  FMTabBarController.m
//  FishingMan
//
//  Created by zhangxh on 2017/1/5.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMTabBarController.h"

@interface FMTabBarController ()
{
    BOOL tabBarIsShow;         //tabbar是否显示或者隐藏
}
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@end

#define kTabBarTextFontName      @"Helvetica"

@implementation FMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tabBarIsShow = YES;
    
    //1、设置tabbar的背景颜色
//    [self.tabBar setBarTintColor:[UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1.0]];
    
    [self.tabBar setBarTintColor:[UIColor whiteColor]];
    
    //2、设置tabbar的标题和图标
    for(int i = 0; i<self.tabBar.items.count; i++)
    {
        UITabBarItem * item = self.tabBar.items[i];
        
        [item setImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%dicon_N",i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [item setSelectedImage:[[UIImage imageNamed:[NSString stringWithFormat:@"%dicon_D",i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
    
    //normal state
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor grayColor], NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:kTabBarTextFontName size:12.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    //selected srate
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       
                                                       [UIColor blackColor], NSForegroundColorAttributeName,
                                                       [UIFont fontWithName:kTabBarTextFontName size:12.0], NSFontAttributeName, nil] forState:UIControlStateSelected];
    
}

/**
 *  @author zxh, 17-03-14 15:03:31
 *
 *  隐藏或者显示地步标签栏
 */
- (void)hideOrShowTabbar{
    
    if(tabBarIsShow)
    {
        [self hideTabBar];
    }
    else
    {
        [self showTabBar];
    }
}

- (void)hideTabBar {
    if (!tabBarIsShow)
    { //already hidden
        return;
    }
    [UIView animateWithDuration:0.35
                     animations:^{
                         CGRect tabFrame = self.tabBar.frame;
                         tabFrame.origin.y = tabFrame.origin.y + tabFrame.size.height;
                         self.tabBar.frame = tabFrame;
                     }];
    tabBarIsShow = NO;
}

- (void)showTabBar {
    if (tabBarIsShow)
    { // already showing
        return;
    }
    [UIView animateWithDuration:0.35
                     animations:^{
                         CGRect tabFrame = self.tabBar.frame;
                         tabFrame.origin.y = tabFrame.origin.y - tabFrame.size.height;;
                         self.tabBar.frame = tabFrame;
                     }];
    tabBarIsShow = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --------------- UITabBarDelegate ----------------------
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
    NSLog(@"tab bar title  =  %@", item.title);
}
@end
