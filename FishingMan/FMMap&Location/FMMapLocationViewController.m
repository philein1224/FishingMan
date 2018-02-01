//
//  FMMapLocationViewController.m
//  FishingMan
//
//  Created by zhangxh on 2018/1/23.
//  Copyright © 2018年 HongFan. All rights reserved.
//

#import "FMMapLocationViewController.h"

@interface FMMapLocationViewController ()

@property (weak, nonatomic) IBOutlet UILabel     * naviTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel     * addressInfoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint * customNaviHeight;

@end

@implementation FMMapLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeButtonAction:(id)sender {
    //退出时导航栏显示不要动画
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  @author zxh, 17-11-22 11:05:00
 *
 *  初始化自定义状态风格，并兼容iPhoneX
 */
- (void)setUpNaviStyle{
    
        //1、⚠️默认隐藏系统导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];

        //2、动态naviBar的高度
    if(CDSafeAreaNavBarHeight == 88.0){
        self.customNaviHeight.constant = CDSafeAreaNavBarHeight;
    }
    
        //3、设置标题
    _naviTitleLabel.text = @"定位";
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
