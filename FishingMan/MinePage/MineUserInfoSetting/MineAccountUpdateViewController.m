//
//  MineAccountUpdateViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/5/21.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "MineAccountUpdateViewController.h"

@interface MineAccountUpdateViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
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
}

- (void)backButtonClicked:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 修改密码按钮点击事件

- (IBAction)updateAccountButtonAction:(id)sender {
    
    NSString *phone = self.phoneTextField.text;
    if([phone length] != 11){
        [CDTopAlertView showMsg:@"手机号码有误哦～" alertType:TopAlertViewWarningType];
    }
    
    NSString *password = self.passwordTextField.text;
    if ([password length] > 16 ||
        [password length] < 6){
        
        [CDTopAlertView showMsg:@"请输入6～16位密码" alertType:TopAlertViewWarningType];
    }
    
    [[CDServerAPIs shareAPI] bindThirdPartyWithTelephoneNum:phone
                                                    Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
                                                        
                                                        CLog(@"绑定手机号码 responseObject = %@", responseObject);
                                                        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
                                                            
                                                        }
                                                    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
                                                        
                                                    }];
    
    
#warning 完了之后，就回调回去
    
    
    if(self.updateCallback){
    
        self.updateCallback(YES);
        
        [self.navigationController popViewControllerAnimated:YES];
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
