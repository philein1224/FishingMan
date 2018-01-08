//
//  FMLoginRegisterViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/5/4.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMLoginRegisterViewController.h"
#import "FMLoginUser.h"

@interface FMLoginRegisterViewController ()<UITextFieldDelegate>
{
    NSMutableArray * viewModeSteps;        //用户操作步骤，用于返回操作
    int wholeSecondsLeft;                  //正在进行跑秒的剩余总时间（秒）
    NSString * currentPhoneNumber;      //当前手机号码
}

@property (weak, nonatomic) IBOutlet UIImageView *BGImageView;


//1、检测手机号码
@property (weak, nonatomic) IBOutlet UIView      *phoneNumberCheckView;
@property (weak, nonatomic) IBOutlet UITextField *check_phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton    *check_checkButton;

//1.1、第三方登录
@property (weak, nonatomic) IBOutlet UIView      *weixinGroup;
@property (weak, nonatomic) IBOutlet UIButton    *weixinButton;
@property (weak, nonatomic) IBOutlet UIView      *QQGroup;
@property (weak, nonatomic) IBOutlet UIButton    *QQButton;
@property (weak, nonatomic) IBOutlet UIView      *weiboGroup;
@property (weak, nonatomic) IBOutlet UIButton    *weiboButton;

//2、登陆
@property (weak, nonatomic) IBOutlet UIView      *logionWithPWDView;
@property (weak, nonatomic) IBOutlet UILabel     *login_phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *login_passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton    *login_loginButton;


//3、注册／忘记密码
@property (weak, nonatomic) IBOutlet UIView      *registerOrModifyPWDView;
@property (weak, nonatomic) IBOutlet UILabel     *register_titleLabel;
@property (weak, nonatomic) IBOutlet UILabel     *register_phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *register_smsCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *register_passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton    *timerButton;
@property (weak, nonatomic) NSTimer              *timer;
@property (weak, nonatomic) IBOutlet UIButton    *register_registerOrModifyPWDButton;

@end

@implementation FMLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //顶部导航栏
    [ZXHViewTool addNaviBarWithViewStyle:ZXHNaviBarStyleColorStatic
                                 bgColor:[UIColor clearColor]
                                   title:nil
                                 tartget:self
                         leftButtonImage:@"navBackGray"
                        rightButtonImage:nil
                              leftAction:@selector(backButtonClicked:)
                             rightAction:nil];
    
    //高斯模糊
    if(1){
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = [UIApplication sharedApplication].keyWindow.bounds;
        [_BGImageView addSubview:effectView];
    }
    
    //1、检测手机号码是否注册
    _check_phoneTextField.delegate = self;
    UITapGestureRecognizer * tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [_phoneNumberCheckView addGestureRecognizer:tap0];
    UIPanGestureRecognizer * pan0 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [_phoneNumberCheckView addGestureRecognizer:pan0];
    
    _check_checkButton.enabled = NO;
    [_check_checkButton setBackgroundColor:[UIColor lightGrayColor]];
    
    //2、账号登录
    _login_passwordTextField.delegate = self;
    _login_passwordTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [_logionWithPWDView addGestureRecognizer:tap1];
    UIPanGestureRecognizer * pan1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [_logionWithPWDView addGestureRecognizer:pan1];
    
    _login_loginButton.enabled = NO;
    [_login_loginButton setBackgroundColor:[UIColor lightGrayColor]];
    
    //3、账号注册／忘记密码
    _register_smsCodeTextField.delegate = self;
    _register_passwordTextField.delegate = self;
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [_registerOrModifyPWDView addGestureRecognizer:tap2];
    UIPanGestureRecognizer * pan2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    [_registerOrModifyPWDView addGestureRecognizer:pan2];
    
    _register_registerOrModifyPWDButton.enabled = NO;
    [_register_registerOrModifyPWDButton setBackgroundColor:[UIColor lightGrayColor]];
    
    //默认第一步骤检测手机号码
    viewModeSteps = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithInt:_loginRegisterViewMode], nil];
    [self showTheCorrectViewWithViewMode:_loginRegisterViewMode];
    
    //读秒的总秒数
    wholeSecondsLeft = 120;
}

- (void)closeKeyboard{
    [_check_phoneTextField resignFirstResponder];
    [_login_passwordTextField resignFirstResponder];
    [_register_smsCodeTextField resignFirstResponder];
    [_register_passwordTextField resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//页面的切换处理
- (void)showTheCorrectViewWithViewMode:(FMLoginRegisterViewMode)viewMode{
    
    switch (viewMode) {
            
        case FMLoginRegisterViewMode_PhoneNumCheck:
        {
            _phoneNumberCheckView.hidden = NO;
            _registerOrModifyPWDView.hidden = YES;
            _logionWithPWDView.hidden = YES;
        }
            break;
        case FMLoginRegisterViewMode_LoginWithPWD:
        {
            _phoneNumberCheckView.hidden = YES;
            _registerOrModifyPWDView.hidden = YES;
            _logionWithPWDView.hidden = NO;
            _login_phoneNumberLabel.text = [ZXHTool phoneNumberFormat:currentPhoneNumber];
        }
            break;
        case FMLoginRegisterViewMode_Register:
        {
            _phoneNumberCheckView.hidden = YES;
            _registerOrModifyPWDView.hidden = NO;
            _register_titleLabel.text = @"注册";
            _register_phoneNumberLabel.text = [ZXHTool phoneNumberFormat:currentPhoneNumber];;
            _logionWithPWDView.hidden = YES;
        }
            break;
        case FMLoginRegisterViewMode_Forget:
        {
            _phoneNumberCheckView.hidden = YES;
            _registerOrModifyPWDView.hidden = NO;
            _register_titleLabel.text = @"忘记密码";
            _register_phoneNumberLabel.text = [ZXHTool phoneNumberFormat:currentPhoneNumber];;
            _logionWithPWDView.hidden = YES;
        }
            break;
            
        default:
            break;
    }
}

//关闭按钮
- (IBAction)closeButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
//返回按钮
- (void)backButtonClicked:(UIButton *)button{
    
    //记录
    NSInteger lastIndex = [viewModeSteps count];
    if (lastIndex > 1) {
        CLog(@"viewModeSteps = %@", viewModeSteps);
        
        CLog(@"lastIndex = %ld", lastIndex);
        NSNumber * num = viewModeSteps[lastIndex-1];
        CLog(@"num = %ld", [num integerValue]);
        [viewModeSteps removeObjectAtIndex:lastIndex-1];
        CLog(@"lastIndex-1 = %ld", lastIndex-1);
        
        CLog(@"viewModeSteps = %@", viewModeSteps);
        
        //去掉
        lastIndex = [viewModeSteps count];
        num = viewModeSteps[lastIndex-1];
        
        [self showTheCorrectViewWithViewMode:[num integerValue]];
    }
    else if (lastIndex == 1){
        [self showTheCorrectViewWithViewMode:0];
        
        [self dismissViewControllerAnimated:YES completion:^{

        }];
    }
}

#pragma mark  1、手机号码校验页面
- (IBAction)phoneNumberCheckAction:(id)sender {
    [_check_phoneTextField resignFirstResponder];
    
    //记录手机号码
    currentPhoneNumber = _check_phoneTextField.text;
    
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] requestWhetherRegisteredPhone:currentPhoneNumber Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        CLog(@"是否已经注册：%@", responseObject);
        
        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
            
            if([responseObject[@"data"][@"registered"] boolValue]){
                //已经注册
                _loginRegisterViewMode = FMLoginRegisterViewMode_LoginWithPWD;
                
                //记录
                [viewModeSteps addObject:[NSNumber numberWithInt:_loginRegisterViewMode]];
                
                [weakself showTheCorrectViewWithViewMode:_loginRegisterViewMode];
            }
            else{
                //未注册
                _loginRegisterViewMode = FMLoginRegisterViewMode_Register;
                
                //记录
                [viewModeSteps addObject:[NSNumber numberWithInt:_loginRegisterViewMode]];
                
                [weakself showTheCorrectViewWithViewMode:_loginRegisterViewMode];
            }
        }else{
            [CDTopAlertView showMsg:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] isErrorState:YES inView:weakself.view];
        }
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        [CDServerAPIs httpDataTask:dataTask error:error.error];
    }];
}

#pragma mark  2、登录时的密码输入页面
- (IBAction)loginWithPasswordAction:(id)sender {
    
    [_login_passwordTextField resignFirstResponder];
    
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] requestLoginWithPhone:currentPhoneNumber Password:_login_passwordTextField.text Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        CLog(@"登录结果：%@", responseObject);
        
        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
            CLog(@"登录成功");
            
            //登录成功
            NSDictionary *dic = responseObject[@"data"];
            if(![ZXHTool isNilNullObject:dic]){
                //登录完成时，更新个人信息
                FMLoginUser * user = [FMLoginUser mj_objectWithKeyValues:dic];
                [FMLoginUser setCacheUserInfo:user];
            }
            
            [weakself dismissViewControllerAnimated:YES completion:^{
                
            }];
        }else{
            CLog(@"登录失败");
            [CDTopAlertView showMsg:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] isErrorState:YES inView:weakself.view];
        }
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        [CDServerAPIs httpDataTask:dataTask error:error.error];
    }];
}
- (IBAction)forgetLoginPassword:(id)sender{
    
    [_login_passwordTextField resignFirstResponder];
    
    _loginRegisterViewMode = FMLoginRegisterViewMode_Forget;
    
    //记录
    [viewModeSteps addObject:[NSNumber numberWithInt:_loginRegisterViewMode]];
    
    [self showTheCorrectViewWithViewMode:_loginRegisterViewMode];
}

#pragma mark  3、注册、忘记密码的页面
- (IBAction)timerStartAction:(id)sender{
    
//    register【注册】
//    forgetPwd【忘记密码】
//    FMLoginRegisterViewMode_Register = 2,          //注册
//    FMLoginRegisterViewMode_Forget = 3,            //忘记登录密码
    
    NSString * type = @"register";
    if(_loginRegisterViewMode == FMLoginRegisterViewMode_Register){
        type = @"register";
    }
    else if (_loginRegisterViewMode == FMLoginRegisterViewMode_Forget){
        type = @"forgetPwd";
    }
    
    //请求短信验证码
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] requestSMSCodeForPhone:currentPhoneNumber withType:type Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        CLog(@"responseObject %@", responseObject);
        
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
//注册／找回密码
- (IBAction)registerOrForgetAction:(id)sender {
    
    [_register_smsCodeTextField resignFirstResponder];
    [_register_passwordTextField resignFirstResponder];
    
    if ([ZXHTool isEmptyString:_register_smsCodeTextField.text]) {
        [CDTopAlertView showMsg:@"请输入验证码" alertType:TopAlertViewFailedType];
    }
    if ([ZXHTool isEmptyString:_register_passwordTextField.text]) {
        [CDTopAlertView showMsg:@"请输入密码" alertType:TopAlertViewFailedType];
    }
    
    NSString * type = @"register";
    if(_loginRegisterViewMode == FMLoginRegisterViewMode_Register){
        type = @"register";
    }
    else if (_loginRegisterViewMode == FMLoginRegisterViewMode_Forget){
        type = @"forgetPwd";
    }
    
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] requestRegisterWithSMSCode:_register_smsCodeTextField.text
                                              Phone:currentPhoneNumber
                                           Password:_register_passwordTextField.text
                                         InviteCode:nil   //邀请码
                                           withType:type Success:^(NSURLSessionDataTask *dataTask, id responseObject) {

       if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
           
           //注册完成后的回调处理
           if(_loginRegisterViewMode == FMLoginRegisterViewMode_Register){
               
               [CDTopAlertView showMsg:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] isErrorState:NO inView:[[UIApplication sharedApplication] keyWindow]];
               
               //jsonString:{"code":"1000","data":{"id":7,"tel":"13618060758"}}
               //jsonString:{"code":"1000","data":{"id":14,"level":0,"point":"0","tel":"13618060758"}}
               NSDictionary *dic = responseObject[@"data"];
               if(![ZXHTool isNilNullObject:dic]){
                   //注册完成时，更新个人信息
                   FMLoginUser * user = [FMLoginUser mj_objectWithKeyValues:dic];
                   [FMLoginUser setCacheUserInfo:user];
               }
               
               [weakself dismissViewControllerAnimated:YES completion:^{
                   
               }];
           }
           //忘记密码完成后的回调处理
           else if (_loginRegisterViewMode == FMLoginRegisterViewMode_Forget){
               
               [CDTopAlertView showMsg:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] isErrorState:NO inView:[[UIApplication sharedApplication] keyWindow]];
               
               //jsonString:{"code":"1000","data":{"id":7,"tel":"13618060758"}}
               //jsonString:{"code":"1000","data":{"id":14,"level":0,"point":"0","tel":"13618060758"}}
               NSDictionary *dic = responseObject[@"data"];
               if(![ZXHTool isNilNullObject:dic]){
                   //忘记密码完成时，更新个人信息
                   FMLoginUser * user = [FMLoginUser mj_objectWithKeyValues:dic];
                   [FMLoginUser setCacheUserInfo:user];
               }
               
               [weakself dismissViewControllerAnimated:YES completion:^{
                   
               }];
           }
       }
       else{
           [CDTopAlertView showMsg:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] isErrorState:YES inView:weakself.view];
       }
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        CLog(@"error %ld, %@", error.errorCode, error.errorMessage);
        
        [CDServerAPIs httpDataTask:dataTask error:error.error];
    }];
}

#pragma mark  4、第三方登录
/*
 电话1
 邮件2
 QQ3
 微信4
 微博5
 用户名6
 */
- (IBAction)thirdLoginButtonAction:(UIButton *)sender {
    
    int identifyType = 0;
    if(_weixinButton == sender){
        identifyType = 4;
    }
    else if(_QQButton == sender){
        identifyType = 3;
    }
    else if(_weiboButton == sender){
        identifyType = 5;
    }

    
    NSString * dateString = [ZXHTool millisecondStringFromDateString:@"2017/07/20"];
    CLog(@"date plan string %@", dateString);
    
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] requestThirdPartyLoginWithUID:nil
                                                identifier:@"sdi5s6337s93j39123"
                                              identifyType:identifyType
                                                   Avartar:@"http://wx.qlogo.cn/mmopen/S1FLibdMXLaZqgxH0tfCRHVy7rVXm8cWdqoHR2lCZD4yopZicvJffEYicPCknlP7T1icNxO2vc6iaK330ICicMhaic6OYGemgmXR6ibI/0"
                                                  NickName:@"feigege"
                                                  Birthday:dateString
                                                       Sex:0 Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
                                                           
                                                           CLog(@"responseObject %@", responseObject);
                                                           /*
                                                            data =     {
                                                            avatarUrl = "http://wx.qlogo.cn/mmopen/S1FLibdMXLaZqgxH0tfCRHVy7rVXm8cWdqoHR2lCZD4yopZicvJffEYicPCknlP7T1icNxO2vc6iaK330ICicMhaic6OYGemgmXR6ibI/0";
                                                            birthday = 1500480000000;
                                                            id = 22;
                                                            nickName = feigege;
                                                            sex = 0;
                                                            };
                                                            */
                                                           if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
                                                               
                                                               [CDTopAlertView showMsg:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] isErrorState:NO inView:weakself.view];
                                                               
                                                               //第三方登录成功
                                                               NSDictionary *dic = responseObject[@"data"];
                                                               if(![ZXHTool isNilNullObject:dic]){
                                                                   //登录完成时，更新个人信息
                                                                   FMLoginUser * user = [FMLoginUser mj_objectWithKeyValues:dic];
                                                                   [FMLoginUser setCacheUserInfo:user];
                                                               }
                                                               
                                                               [weakself dismissViewControllerAnimated:YES completion:nil];
                                                           }
                                                           else{
                                                               [CDTopAlertView showMsg:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] isErrorState:YES inView:weakself.view];
                                                           }
                                                           
                                                       } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
                                                           CLog(@"error %ld, %@", error.errorCode, error.errorMessage);
                                                           
                                                           [CDServerAPIs httpDataTask:dataTask error:error.error];
                                                       }];
}



#pragma mark UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@" "]) {
        return NO;
    }
    
    NSMutableString * newValue = [NSMutableString stringWithString:textField.text];
    if ([string isEqualToString:@""]) {
        [newValue replaceCharactersInRange:range withString:@""];
    }
    else{
        [newValue  insertString:string atIndex:range.location];
    }
    
    switch (_loginRegisterViewMode) {
        case FMLoginRegisterViewMode_PhoneNumCheck:
        {//手机号码校验
            
            if ([newValue length] > 11) {
                return NO;
            }
            else if ([newValue length] == 11){
                
                _check_checkButton.enabled = YES;
                [_check_checkButton setBackgroundColor:ZXHColorHEX(@"36D8FF", 1)];
            }
            else{
                _check_checkButton.enabled = NO;
                [_check_checkButton setBackgroundColor:[UIColor lightGrayColor]];
            }
        }
            break;
        case FMLoginRegisterViewMode_LoginWithPWD:
        {//登录使用登录密码
            
            if ([newValue length] > 16) {
                
                return NO;
            }
            if([newValue length] >= 6)
            {
                _login_loginButton.enabled = YES;
                [_login_loginButton setBackgroundColor:ZXHColorHEX(@"36D8FF", 1)];
            }
            else
            {
                _login_loginButton.enabled = NO;
                [_login_loginButton setBackgroundColor:[UIColor lightGrayColor]];
            }
        }
            break;
        case FMLoginRegisterViewMode_Register:
        case FMLoginRegisterViewMode_Forget:
        {//注册//忘记登录密码
            
            if(textField == _register_smsCodeTextField){
               
                if([newValue length] >= 4 && _register_passwordTextField.text.length >= 6) {
                    _register_registerOrModifyPWDButton.enabled = YES;
                    [_register_registerOrModifyPWDButton setBackgroundColor:ZXHColorHEX(@"36D8FF", 1)];
                }
                else {
                    _register_registerOrModifyPWDButton.enabled = NO;
                    [_register_registerOrModifyPWDButton setBackgroundColor:[UIColor lightGrayColor]];
                }
            }
            
            else if(textField == _register_passwordTextField){
                
                if ([newValue length] > 16) {
                    
                    return NO;
                }
                if([newValue length] >= 6 && _register_smsCodeTextField.text.length >= 4) {
                    _register_registerOrModifyPWDButton.enabled = YES;
                    [_register_registerOrModifyPWDButton setBackgroundColor:ZXHColorHEX(@"36D8FF", 1)];
                }
                else {
                    _register_registerOrModifyPWDButton.enabled = NO;
                    [_register_registerOrModifyPWDButton setBackgroundColor:[UIColor lightGrayColor]];
                }
            }
        }
            break;
        default:
            break;
    }
    
    return YES;
}

@end
