//
//  FMSettingTableViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/1/5.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMSettingTableViewController.h"
#import "MinePageTableViewCell.h"
#import "FMLoginPWDModifyViewController.h"
#import "FMLoginUser.h"

@interface FMSettingTableViewController ()
{
    NSMutableArray * mine1stArray;
    
    float HEADER_HEIGHT;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//登录／退出按钮
@property (weak, nonatomic) IBOutlet UIButton    *logoutButtonAction;

@end

@implementation FMSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [ZXHTool barBackButtonItemWithTitle:nil
                                                                          color:[UIColor grayColor]
                                                                          image:ZXHImageName(@"navBackGray")
                                                                      addTarget:self
                                                                         action:@selector(backButtonClicked:)];
    
    /*** 注册表单元 ***/
    [self.tableView registerNib:[UINib nibWithNibName:@"MinePageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MinePageTableViewCell"];
    
    /*** 列表视图背景 ***/
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:ZXHColorRGB(248, 248, 248, 1)];
    
    /*** 列表去掉多余cell ***/
    UIView *tempfooterview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZXHScreenWidth, 49)];
    tempfooterview.backgroundColor = ZXHColorRGB(248, 248, 248, 1);
    self.tableView.tableFooterView = tempfooterview;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    /*** 刷新按钮 ***/
    [self reloadLoginOutButton];
    
    /*** 加载个人中心数据 ***/
    [self loadListData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backButtonClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

//刷新加载退出／登录按钮
- (void)reloadLoginOutButton{
    
    if(IS_LOGIN){
        [_logoutButtonAction setTitle:@"退 出" forState:UIControlStateNormal];
    }
    else{
        [_logoutButtonAction setTitle:@"赶快登录" forState:UIControlStateNormal];
    }
}

/**
 *  @author zxh, 16-07-27 15:07:29
 *
 *  初始化底部按钮
 */
-(void)initFootView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ZXHScreenWidth, 73)];
    
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBtn.frame = CGRectMake(15, 8, ZXHScreenWidth - 30, 45);
    [logoutBtn setTitle:@"退 出" forState:UIControlStateNormal];
    logoutBtn.backgroundColor = ZXHColorHEX(@"ac16f3",1);
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [logoutBtn addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.layer.masksToBounds = YES;
    logoutBtn.layer.cornerRadius = 3.4f;
    [view addSubview:logoutBtn];
    
//    self.tableView.tableFooterView = view;
    [self.tableView addSubview:view];
}

/**
 *  @author zxh, 17-03-15 22:03:17
 *
 *  退出登录状态
 *
 *  @param sender
 */
- (IBAction)logoutAction:(UIButton *)sender{
    
    if(!IS_LOGIN_WITHOUT_ALERT){
        return;
    }
    else{
        ZXH_WEAK_SELF
        [ZXHViewTool addAlertWithTitle:@"大仙"
                               message:@"您确认退出登录?"
                           withTartget:self
                       leftActionStyle:UIAlertActionStyleDefault
                      rightActionStyle:UIAlertActionStyleDestructive
                     leftActionHandler:^(UIAlertAction *action) {
                         
                     }
                    rightActionHandler:^(UIAlertAction *action) {
                        
                        [weakself logOutFromServer];
                        //清除缓存
                        [FMLoginUser removeCacheUserInfo];
                        [weakself reloadLoginOutButton];
                        [weakself.navigationController popViewControllerAnimated:YES];
                    }];
    }
}

- (void)logOutFromServer{
    
    [[CDServerAPIs shareAPI] requestLoginOutSuccess:^(NSURLSessionDataTask *dataTask, id responseObject) {
        CLog(@"登出成功 成功 = %@", responseObject);
        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
            NSLog(@"登出成功");
        }
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        CLog(@"登出成功 失败 = %@", error.error);
    }];
    
}

#pragma mark - 数据生成
- (void)loadListData{
    
    NSMutableArray * mine1stNameArray = [[NSMutableArray alloc] init];
    [mine1stNameArray addObject:@"修改密码"];
    [mine1stNameArray addObject:@"当前版本"];
    
    mine1stArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *tempDic0 = [[NSMutableDictionary alloc]init];
    [tempDic0 setObject:mine1stNameArray[0] forKey:@"keyName"];
    [tempDic0 setObject:@"" forKey:@"keyValue"];
    [tempDic0 setObject:[NSString stringWithFormat:@"%@icon", mine1stNameArray[0]] forKey:@"keyIconName"];
    [tempDic0 setObject:[NSNumber numberWithBool:YES] forKey:@"keyFlag"];
    [mine1stArray addObject:tempDic0];
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    currentVersion = [NSString stringWithFormat:@"v %@", currentVersion];
    
    NSMutableDictionary *tempDic1 = [[NSMutableDictionary alloc]init];
    [tempDic1 setObject:mine1stNameArray[1] forKey:@"keyName"];
    [tempDic1 setObject:currentVersion forKey:@"keyValue"];
    [tempDic1 setObject:[NSString stringWithFormat:@"%@icon", mine1stNameArray[1]] forKey:@"keyIconName"];
    [tempDic1 setObject:[NSNumber numberWithBool:YES] forKey:@"keyFlag"];
    [mine1stArray addObject:tempDic1];
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0) {
        return mine1stArray.count + 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row == 0){
        return 8;
    }
    return ZXHRatioWithReal375 * 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
            if(cell == nil){
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
                
                [cell setBackgroundColor:ZXHColorRGB(248, 248, 248, 1)];
            }
            return cell;
        }
        else{
            MinePageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MinePageTableViewCell" forIndexPath:indexPath];
            [cell loadData:mine1stArray[indexPath.row-1]];
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1) {
            
            if(IS_LOGIN_WITHOUT_ALERT){
                
                FMLoginPWDModifyViewController * pwdModifyVC = [[FMLoginPWDModifyViewController alloc] initWithNibName:@"FMLoginPWDModifyViewController" bundle:nil];
                [self.navigationController pushViewController:pwdModifyVC animated:YES];
            }
        }
        else if (indexPath.row == 2){
            
            CLog(@"当前版本");
            
        }
    }
}
@end
