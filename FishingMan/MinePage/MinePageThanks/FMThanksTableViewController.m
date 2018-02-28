//
//  FMThanksTableViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/3/18.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMThanksTableViewController.h"
#import "FMThanksTableViewCell.h"
#import "CDServerAPIs+Friend.h"

@interface FMThanksTableViewController ()

@end

@implementation FMThanksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = [ZXHTool barBackButtonItemWithTitle:nil
                                                                          color:[UIColor grayColor]
                                                                          image:ZXHImageName(@"navBackGray")
                                                                      addTarget:self
                                                                         action:@selector(backButtonClicked:)];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FMThanksTableViewCell" bundle:nil] forCellReuseIdentifier:@"FMThanksTableViewCell"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    /*
     FMFriendTypeNormal = 0,       //还未做任何行为
     FMFriendTypeFollows = 1,      //关注
     FMFriendTypeFans = 2          //粉丝
     */
    BOOL isMyFans = NO;
    switch (_friendType) {
        case FMFriendTypeFollows:
        {
        isMyFans = NO;
        }
            break;
        case FMFriendTypeFans:
        {
        isMyFans = YES;
        }
            break;
        default:
            break;
    }
    
    [[CDServerAPIs shareAPI] friendListWithPage:1 isMyFans:isMyFans Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 关注、取消关注

- (void)doFollowOrCancelFollowWithStatus:(BOOL)isFollowedByMe{
    
    if(isFollowedByMe){//已关注，则取消关注
        
        [CDTopAlertView showMsg:@"已取消关注" alertType:TopAlertViewSuccessType];
    }
    else{//未关注，则进行关注
        
        [CDTopAlertView showMsg:@"已关注成功" alertType:TopAlertViewSuccessType];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FMThanksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FMThanksTableViewCell" forIndexPath:indexPath];
    
    cell.friendType = self.friendType;
    
    [cell reloadData];
    
    ZXH_WEAK_SELF
    cell.callback_UserTBCell = ^(BOOL isFollowedByMe){
        
        CLog(@"关注还是取消关注 哈哈哈哈哈");
        [weakself doFollowOrCancelFollowWithStatus:isFollowedByMe];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}



@end
