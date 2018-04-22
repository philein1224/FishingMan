//
//  MineAccountUpdateViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/5/21.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "MineAccountUpdateViewController.h"

@interface MineAccountUpdateViewController ()<UITextFieldDelegate>{
    
    int wholeSecondsLeft;                  //正在进行跑秒的剩余总时间（秒）
}

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

//验证码
@property (weak, nonatomic) IBOutlet UITextField *register_smsCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton    *timerButton;
@property (weak, nonatomic) NSTimer              *timer;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton    *updateAccountButton;

@end

@implementation MineAccountUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitle = @"提升账户";
    
    self.navigationItem.leftBarButtonItem = [ZXHTool barBackButtonItemWithTitle:nil
                                                                          color:[UIColor grayColor]
                                                                          image:ZXHImageName(@"navBackGray")
                                                                      addTarget:self
                                                                         action:@selector(backButtonClicked:)];
    
    _phoneTextField.tag = 1001;
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _passwordTextField.tag = 1002;
    _updateAccountButton.enabled = NO;
    [_updateAccountButton setBackgroundColor:[UIColor lightGrayColor]];
    
        //读秒的总秒数
    wholeSecondsLeft = 120;
}

- (void)backButtonClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 短信验证码相关

- (IBAction)timerStartAction:(id)sender {
    
    NSString *phone = self.phoneTextField.text;
    if([phone length] != 11){
        [CDTopAlertView showMsg:@"手机号码有误哦～" alertType:TopAlertViewWarningType];
        return;
    }
    
    //请求短信验证码
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] requestSMSCodeForPhone:phone withType:@"bindTelephone" Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        CLog(@"请求绑定手机账号的短信验证码 responseObject %@", responseObject);
        
        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
            
            [CDTopAlertView showMsg:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] isErrorState:NO inView:weakself.view];
        }
        else{
            [CDTopAlertView showMsg:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] isErrorState:YES inView:weakself.view];
        }
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        CLog(@"error %ld, %@", error.errorCode, error.errorMessage);
        
        [CDServerAPIs httpDataTask:dataTask error:error.error];
    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerButtonRefresh:) userInfo:nil repeats:YES];
}

#pragma mark 修改密码按钮点击事件

- (IBAction)updateAccountButtonAction:(id)sender {
    
    NSString *phone = self.phoneTextField.text;
    if([phone length] != 11){
        [CDTopAlertView showMsg:@"手机号码有误哦～" alertType:TopAlertViewWarningType];
        return;
    }
    
    NSString * validCode = _register_smsCodeTextField.text;
    if([ZXHTool isEmptyString:validCode]){
        [CDTopAlertView showMsg:@"输入验证码哦～" alertType:TopAlertViewWarningType];
        return;
    }
    
    NSString *password = self.passwordTextField.text;
    if ([password length] > 16 ||
        [password length] < 6){
        
        [CDTopAlertView showMsg:@"请输入6～16位密码" alertType:TopAlertViewWarningType];
        return;
    }
    
    
    [[CDServerAPIs shareAPI] bindThirdPartyWithTelephoneNum:phone
                                                  ValidCode:validCode
                                                   Password:password
                                                    Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
                                                        
                                                        CLog(@"绑定手机号码 responseObject = %@", responseObject);
                                                        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
                                                            
                                                        }
                                                    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
                                                        
                                                    }];
}
- (void)timerButtonRefresh:(NSTimer *)timer{
    
    wholeSecondsLeft = wholeSecondsLeft - 1;
    
    [self.timerButton setEnabled:NO];
    
        //重新加载s75数据
    if (wholeSecondsLeft <= 0) {
        
        if(wholeSecondsLeft < 0){
                //每次刷新 抢购都将熄灭并重建
            [self.timer invalidate];
            self.timer = nil;
        }
        
        [self timerDataRefreshWithLeftSeconds:wholeSecondsLeft];
    }
    else{
        
        [self timerDataRefreshWithLeftSeconds:wholeSecondsLeft];
    }
}
- (void)timerDataRefreshWithLeftSeconds:(int)secondsLeft{
    
    if(0 > secondsLeft){
        [self.timerButton setEnabled:YES];
        self.timerButton.titleLabel.text = @"验证码";
        [self.timerButton setTitle:@"验证码" forState:UIControlStateNormal];
        [self.timerButton setTitleColor:ZXHColorHEX(@"FFFFFF", 1) forState:UIControlStateDisabled];
        [self.timerButton setBackgroundColor:ZXHColorHEX(@"00FFFF", 1)];
    }
    else{
        self.timerButton.titleLabel.text = [NSString stringWithFormat:@"%ds", secondsLeft];
        [self.timerButton setTitle:[NSString stringWithFormat:@"%ds", secondsLeft] forState:UIControlStateDisabled];
        [self.timerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        [self.timerButton setBackgroundColor:[UIColor lightGrayColor]];
    }
}

#pragma mark - textfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField.tag == 1001){
        
        NSMutableString * newValue = [NSMutableString stringWithString:textField.text];
        
        if ([string isEqualToString:@""]) {
            [newValue replaceCharactersInRange:range withString:@""];
        }
        else{
            [newValue  insertString:string atIndex:range.location];
        }
        
        if ([newValue length] == 0 || [newValue length] > 11) {
            
            return NO;
        }
        
        if([self.passwordTextField.text length] >= 6 && [self.passwordTextField.text length] <= 16
           && [newValue length] == 11) {
            
            self.updateAccountButton.enabled = YES;
            [_updateAccountButton setBackgroundColor:ZXHColorHEX(@"36D8FF", 1)];
        }
        else {
            
            self.updateAccountButton.enabled = NO;
            [_updateAccountButton setBackgroundColor:[UIColor lightGrayColor]];
        }
    }
    else if (textField.tag == 1002) {
        
        NSMutableString * newValue = [NSMutableString stringWithString:textField.text];
        
        if ([string isEqualToString:@""]) {
            [newValue replaceCharactersInRange:range withString:@""];
        }
        else{
            [newValue  insertString:string atIndex:range.location];
        }
        
        if ([newValue length] > 16) {
            
            return NO;
        }
        
        if([newValue length] >= 6 && [newValue length] <= 16
           && [self.phoneTextField.text length] == 11) {
            
            self.updateAccountButton.enabled = YES;
            [_updateAccountButton setBackgroundColor:ZXHColorHEX(@"36D8FF", 1)];
        }
        else {
            
            self.updateAccountButton.enabled = NO;
            [_updateAccountButton setBackgroundColor:[UIColor lightGrayColor]];
        }
    }
    
    return YES;
}
@end
