//
//  FMFeedbackViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/3/18.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMFeedbackViewController.h"

#import <YWFeedbackFMWK/YWFeedbackKit.h>
#import <YWFeedbackFMWK/YWFeedbackViewController.h>

/**
 *  修改为你自己的appkey。
 *  同时，也需要替换yw_1222.jpg这个安全图片。
 */
static NSString * const kAppKey = @"23855996";

@interface FMFeedbackViewController ()
@property (nonatomic, strong) YWFeedbackKit *feedbackKit;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *feedbackButton;

@end

@implementation FMFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [ZXHTool barBackButtonItemWithTitle:nil
                                                                          color:[UIColor grayColor]
                                                                          image:ZXHImageName(@"navBackGray")
                                                                      addTarget:self
                                                                         action:@selector(backButtonClicked:)];
}

- (void)backButtonClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark getter
- (YWFeedbackKit *)feedbackKit {
    if (!_feedbackKit) {
        _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAppKey];
    }
    return _feedbackKit;
}

- (IBAction)feedbackEditViewController:(id)sender {
    
    _feedbackKit = [[YWFeedbackKit alloc] initWithAppKey:kAppKey];
    
    CLog(@"阿里百川 feedback version %@", [YWFeedbackKit version]);
    
    /** 设置App自定义扩展反馈数据 */
    self.feedbackKit.extInfo = @{@"loginTime":[[NSDate date] description],
                                 @"visitPath":@"登陆->关于->反馈",
                                 @"userid":@"yourid",
                                 @"应用自定义扩展信息":@"开发者可以根据需要设置不同的自定义信息，方便在反馈系统中查看"};
    
    __weak typeof(self) weakSelf = self;
    [self.feedbackKit makeFeedbackViewControllerWithCompletionBlock:^(YWFeedbackViewController *viewController, NSError *error) {
        
        if (viewController != nil) {
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            [weakSelf presentViewController:nav animated:YES completion:nil];
            
            [viewController setCloseBlock:^(UIViewController *aParentController){
                [aParentController dismissViewControllerAnimated:YES completion:nil];
            }];
        }
        else {
            /** 使用自定义的方式抛出error时，此部分可以注释掉 */
            NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
            NSLog(@"%@", title);
        }
    }];
}

/** 查询未读数 */
- (void)fetchUnreadCount {
    
    __weak typeof(self) weakSelf = self;
    
    [self.feedbackKit getUnreadCountWithCompletionBlock:^(NSInteger unreadCount, NSError *error) {
        
        if (error == nil) {
            
            NSLog(@"%@", [NSString stringWithFormat:@"未读数：%ld", (long)unreadCount]);
        } else {
            
            NSString *title = [error.userInfo objectForKey:@"msg"]?:@"接口调用失败，请保持网络通畅！";
            
            NSLog(@"%@", title);
        }
    }];
}

#pragma mark UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellId"];
    
    if(!cell){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellId"];
    }
    
    return cell;
    
//
//    if(!cell){
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"FMSiteHomeInfoCell" owner:nil options:nil] firstObject];
//    }
    
    return nil;
}

@end
