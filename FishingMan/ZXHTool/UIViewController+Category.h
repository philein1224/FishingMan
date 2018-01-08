//
//  UITableViewController+Category.h
//  FishingMan
//
//  Created by zhangxh on 2017/3/17.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Category)

- (void)setNavigationTitle:(NSString *)title;
- (void)addCustomNavigationBarBackButtonWithImage:(UIImage *)image target:(id)target selector:(SEL)selector;
@end
