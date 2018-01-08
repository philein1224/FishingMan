//
//  FMLoginPWDModifyViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/5/21.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMLoginPWDModifyViewController.h"
#import "FMLoginUser.h"

@interface FMLoginPWDModifyViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPWDTextFeild;
@property (weak, nonatomic) IBOutlet UITextField *newerPWDTextFeild;
@property (weak, nonatomic) IBOutlet UIButton    *modifyPWDButton;

@end

@implementation FMLoginPWDModifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitle = @"修改密码";
    
    self.navigationItem.leftBarButtonItem = [ZXHTool barBackButtonItemWithTitle:nil
                                                                          color:[UIColor grayColor]
                                                                          image:ZXHImageName(@"navBackGray")
                                                                      addTarget:self
                                                                         action:@selector(backButtonClicked:)];
    
    _oldPWDTextFeild.tag = 1001;
    _newerPWDTextFeild.tag = 1002;
    _modifyPWDButton.enabled = NO;
    [_modifyPWDButton setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)backButtonClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 修改密码按钮点击事件

- (IBAction)modifyPWDButtonAction:(id)sender {
    
    [_newerPWDTextFeild resignFirstResponder];
    [_oldPWDTextFeild resignFirstResponder];
    
    NSString *newValue = self.newerPWDTextFeild.text;
    NSString *oldValue = self.oldPWDTextFeild.text;
    
    if ([newValue length] > 12 ||
        [oldValue length] > 12 ||
        [newValue length] < 6 ||
        [oldValue length] < 6 ){
        
        [CDTopAlertView showMsg:@"请输入6～16位密码" alertType:TopAlertViewWarningType];
        return;
    }
    
    if([newValue isEqualToString:oldValue]){
    
        [CDTopAlertView showMsg:@"新、老密码不能相同" alertType:TopAlertViewWarningType];
        return;
    }
    
        //登录用户的userId
    FMLoginUser * user = [FMLoginUser getCacheUserInfo];
    if ([ZXHTool isNilNullObject:user]) {
        return;
    }
    
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] requestModifyOldPassword:oldValue WithNewPassword:newValue WithUserID:user.userId Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        CLog(@"修改结果：%@", responseObject);
        
        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
            CLog(@"修改成功");
            
            if (1000 == [responseObject[@"code"] intValue]) {
                
                //修改成功
                [CDTopAlertView showMsg:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] alertType:TopAlertViewSuccessType];
                
                //返回上一页
                [self.navigationController popViewControllerAnimated:YES];
            }
            else{
                //修改失败
                [CDTopAlertView showMsg:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] isErrorState:YES inView:weakself.view];
            }
        }else{
            CLog(@"修改密码之网络失败");
            [CDTopAlertView showMsg:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] isErrorState:YES inView:weakself.view];
        }
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        [CDServerAPIs httpDataTask:dataTask error:error.error];
    }];
}

#pragma mark - textfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSMutableString * newValue = [NSMutableString stringWithString:textField.text];
    if ([string isEqualToString:@""]) {
        [newValue replaceCharactersInRange:range withString:@""];
    }
    else{
        [newValue  insertString:string atIndex:range.location];
    }
    
    
    NSString *otherValue = @"";
    
    if (textField.tag == 1001) {
        
        otherValue = self.newerPWDTextFeild.text;
        
        if ([newValue length] > 16) {
            
            return NO;
        }
    }
    else if (textField.tag == 1002){
        
        otherValue = self.oldPWDTextFeild.text;
        
        if ([newValue length] > 16) {
            
            return NO;
        }
    }
    
    if ([newValue length] > 12 || [otherValue length] > 12) {
        
        return NO;
    }
    
    if([newValue length] >= 6 && [otherValue length] >= 6)
    {
        self.modifyPWDButton.enabled = YES;
        [_modifyPWDButton setBackgroundColor:ZXHColorHEX(@"36D8FF", 1)];
    }
    else
    {
        self.modifyPWDButton.enabled = NO;
        [_modifyPWDButton setBackgroundColor:[UIColor lightGrayColor]];
    }
    
    return YES;
}
@end
