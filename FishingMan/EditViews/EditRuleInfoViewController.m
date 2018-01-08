//
//  EditRuleInfoViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/12.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "EditRuleInfoViewController.h"

@interface EditRuleInfoViewController ()

@end

@implementation EditRuleInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if(self.navigationController.navigationBarHidden)
    {
        CLog(@"啊还是觉得哈时间打手机");
    }
    else{
        CLog(@"打手机");
    }
    [self addCustomNavigationBarBackButtonWithImage:ZXHImageName(@"navBackGray")
                                             target:self
                                           selector:@selector(backButtonClicked)];
}

- (void)backButtonClicked {
    //退出时导航栏显示不要动画
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
