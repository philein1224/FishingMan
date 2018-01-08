//
//  UITableViewController+Category.m
//  FishingMan
//
//  Created by zhangxh on 2017/3/17.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "UIViewController+Category.h"

@implementation UIViewController (Category)

- (void)setNavigationTitle:(NSString *)title{
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.textColor = [UIColor grayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = title;
    self.navigationItem.titleView = titleLabel;
}


/**
 *  @author zxh, 17-04-28 22:04:15
 *
 *  给puh和present出来的视图控制器添加自定义返回按钮
 *  1、如果被显示的视图导航栏隐藏，则在原视图上添加返回按钮
 *  2、如果被显示的视图导航栏未隐藏，则在导航栏上添加返回自定义leftBarButtonItem
 *  @param image    按钮图标
 *  @param target   上一级视图控制器
 *  @param selector 无
 */
- (void)addCustomNavigationBarBackButtonWithImage:(UIImage *)image
                                           target:(id)target
                                         selector:(SEL)selector {
    
    //系统导航栏隐藏状态的处理
    if(((UIViewController *) target).navigationController.navigationBarHidden){
        UIButton *backButton = [ZXHTool buttonFrame:CGRectMake(0, 10, 64, 64)
                                                 image:image
                                        highlightImage:image
                                             addTarget:target
                                                action:selector];
        [((UIViewController *) target).view addSubview:backButton];
    }
    //系统导航栏显示状态的处理
    else{
        ((UIViewController *) target).navigationItem.leftBarButtonItem = [ZXHTool barBackButtonItemWithTitle:nil
                                                                                                       color:[UIColor redColor]
                                                                                                       image:image
                                                                                                   addTarget:target
                                                                                                      action:selector];
    }
}

@end
