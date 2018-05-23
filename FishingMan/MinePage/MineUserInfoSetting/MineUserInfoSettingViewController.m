//
//  MineUserInfoSettingViewController.m
//  FishingMan
//
//  Created by zxh on 2017/6/7.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "MineUserInfoSettingViewController.h"
#import "FMPictureChooseMenu.h"
#import <Photos/Photos.h>
#import "FMDatePickerView.h"
#import "FMPickerChooseMenu.h"
#import "MineAccountUpdateViewController.h"

@interface MineUserInfoSettingViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;   //18个字符
@property (weak, nonatomic) IBOutlet UIButton    *sexButton;
@property (weak, nonatomic) IBOutlet UIButton    *birthdayButton;

@property (weak, nonatomic) IBOutlet UIButton    *accountUpdateButton;
@property (weak, nonatomic) IBOutlet UIView      *accountUpdateGroupView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountUpdateGroupViewHeight;

@property (weak, nonatomic) IBOutlet UIButton    *saveButton;         //保存提交按钮
@property (strong, nonatomic) UIImage *avatarImage;                   //新的头像图片
@property (assign, nonatomic) BOOL     hasChanged;                    //新的头像图片

@property (strong, nonatomic) NSDate  *birthDate;                     //birthDate

@end

@implementation MineUserInfoSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [ZXHTool barBackButtonItemWithTitle:nil
                                                                          color:[UIColor grayColor]
                                                                          image:ZXHImageName(@"navBackGray")
                                                                      addTarget:self
                                                                         action:@selector(backButtonClicked:)];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:tap];
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:pan];
    
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (void)closeKeyboard{
    [_nickNameTextField resignFirstResponder];
}

- (void)backButtonClicked:(UIButton *)sender{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData{
    
    if(IS_LOGIN){
        
        FMLoginUser * user = [FMLoginUser getCacheUserInfo];
        [ZXHViewTool setImageView:_avatarImageView WithImageURL:[NSURL URLWithString:user.avatarUrl] AndPlaceHolderName:@"Mine_avatar" CompletedBlock:nil];
        
        _nickNameTextField.text = user.nickName;
        
        //性别 default男
        [_sexButton setTitle:[FMLoginUser sexConverter:user.sex] forState:UIControlStateNormal];
        [_sexButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        
        //生日 请选择生日
        [_birthdayButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        if (user.birthday == 0) {
            [_birthdayButton setTitle:[ZXHTool dateStringFromDate:[NSDate date]] forState:UIControlStateNormal];
        }
        else{
            [_birthdayButton setTitle:[FMLoginUser birthdayConverter:user.birthday] forState:UIControlStateNormal];
        }
        
        //提升账号是否隐藏,取决于是否已经有了手机号
        if([ZXHTool isEmptyString:user.tel]){
            [_accountUpdateButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            _accountUpdateGroupView.hidden = NO;
            _accountUpdateGroupViewHeight.constant = 45;
        }else{
            _accountUpdateGroupView.hidden = YES;
            _accountUpdateGroupViewHeight.constant = 0;
        }
    }
    
//    [_saveButton setBackgroundColor:[UIColor lightGrayColor]];
//    _saveButton.enabled = NO;
}

#pragma mark 头像相关
//修改头像
- (IBAction)modifyAvatarButtonAction:(id)sender {
    
    [_nickNameTextField resignFirstResponder];
    
    ZXH_WEAK_SELF
    FMPictureChooseMenu * pictureChooseMenu = [FMPictureChooseMenu shareWithTarget:self callback:^(ChooseMenuType chooseType) {
        
        switch (chooseType) {
            case ChooseMenuTypeCamera:
            {
                [weakself cameraButtonClicked];
            }
                break;
            case ChooseMenuTypePhoto:
            {
                [weakself photoButtonClicked];
            }
                break;
            case ChooseMenuTypeCancel:
            default:
                break;
        }
    }];
    
    [pictureChooseMenu show];
}

//拍照
- (void)cameraButtonClicked {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:^{}];
    }else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请开启照相服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

//从相册选择照片
- (void)photoButtonClicked {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = YES;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:^{}];
    }else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请开启照相服务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

#pragma mark - imagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image) {
        
        [self reloadAvatarImage:image];
    }
    
    picker.delegate = nil;
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    picker.delegate = nil;
}

//将图片显示在头像视图上
- (void)reloadAvatarImage:(UIImage *)image{
    
    self.avatarImageView.image = image;
    _hasChanged = YES;
    _avatarImage = image;
}

#pragma mark 修改性别相关
//修改性别
- (IBAction)modifySexButtonAction:(id)sender {
    
    [_nickNameTextField resignFirstResponder];
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"男",@"女",@"保密",nil];
    
    ZXH_WEAK_SELF
    FMPickerChooseMenu * picker = [FMPickerChooseMenu shareWithTarget:self
                                                                array:array
                                                             callback:^(NSMutableArray * arrayOfDic){
                                                                 
                                                                 NSString * valueStr = arrayOfDic[0];
                                                                 [weakself.sexButton setTitle:valueStr forState:UIControlStateNormal];
    }];
    
    [picker show];
}

#pragma mark 修改生日
//修改生日
- (IBAction)modifyBirthdayButtonAction:(id)sender {
    
    [_nickNameTextField resignFirstResponder];
    
    ZXH_WEAK_SELF
    FMDatePickerView * datePicker = [FMDatePickerView shareWithTarget:self mode:UIDatePickerModeDate callback:^(NSDate *date) {
        weakself.birthDate = date;
        NSString * valueStr = [ZXHTool dateStringFromDate:date];
        [weakself.birthdayButton setTitle:valueStr forState:UIControlStateNormal];
    }];
    
    [datePicker show];
}

#pragma mark 提升账号级别（第三方转成手机注册）
//提升账号级别（第三方转成手机注册）
- (IBAction)accountUpdateButtonAction:(id)sender {
    
    [_nickNameTextField resignFirstResponder];
    
    self.hidesBottomBarWhenPushed = YES;
    
    MineAccountUpdateViewController * updateVc = [[MineAccountUpdateViewController alloc]initWithNibName:@"MineAccountUpdateViewController" bundle:nil];
    
    updateVc.updateCallback = ^(BOOL updated) {
        
    };
    [self.navigationController pushViewController:updateVc animated:YES];
}

#pragma mark 更新信息
- (IBAction)saveButtonAction:(id)sender {
    
    [_nickNameTextField resignFirstResponder];
    
    //0、必须要处于登录状态
    FMLoginUser * loginUser = [FMLoginUser getCacheUserInfo];
    if(!IS_LOGIN_WITH_ALERT) {
        return;
    }
    
    //1、头像图片
    NSString * avatarUrl = @"http://diaoyudaxian01.b0.upaiyun.com/fish/201801/045d7499-92c3-4791-b3e0-62c6422f7058";
    
    //2、昵称
    NSString * nickName = [NSString stringWithFormat:@"%@", _nickNameTextField.text];
    if([ZXHTool isEmptyString:nickName]){
       nickName = @"";
    }
    
    //3、性别
    int sexFlag = [FMLoginUser sexTypeConvertFromName:self.sexButton.currentTitle];
    
    //4、生日日期对象
    if(self.birthDate == nil){
        self.birthDate = [NSDate date];
    }
    
    //5、住址
    NSString * address = @"";
    if([ZXHTool isEmptyString:address]){
        address = @"";
    }
    
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] modifyUserInfoWithNikeName:nickName
                                                    sex:sexFlag
                                              avatarUrl:avatarUrl
                                                address:address
                                               birthday:_birthDate
                                                success:^(NSURLSessionDataTask *dataTask, id responseObject) {
                                                       
                                                       /*
                                                        data =     {
                                                        address = "";
                                                        avatarUrl = "http://diaoyudaxian01.b0.upaiyun.com/fish/201708/aed90885-e34b-44b3-afa5-b0fa0b660e4c";
                                                        birthday = 1503201874238;
                                                        id = 18;
                                                        nickName = 123456;
                                                        orderFieldNextType = ASC;
                                                        sex = 0;
                                                        */
                                                       
                                                       CLog(@"修改资料 responseObject = %@", responseObject);
                                                       
                                                       if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
                                                           
                                                           NSDictionary *dic = responseObject[@"data"];
                                                           if(![ZXHTool isNilNullObject:dic]){
                                                                   //修改完成时，更新个人信息
                                                               FMLoginUser * tempUser = [FMLoginUser mj_objectWithKeyValues:dic];
                                                               
                                                               FMLoginUser * user = [FMLoginUser getCacheUserInfo];
                                                               user.address = tempUser.address;
                                                               
                                                               if (![ZXHTool isEmptyString:tempUser.avatarUrl]) {
                                                                   user.avatarUrl = tempUser.avatarUrl;
                                                               }
                                                               
                                                               user.birthday = tempUser.birthday;
                                                               user.nickName = tempUser.nickName;
                                                               user.orderFieldNextType = tempUser.orderFieldNextType;
                                                               user.sex = tempUser.sex;
                                                               [FMLoginUser setCacheUserInfo:user];
                                                           }
                                                           
                                                           NSString * msg = [ZXHTool isEmptyString:responseObject[@"msg"]] ? @"更新成功":responseObject[@"msg"];
                                                           [CDTopAlertView showMsg:[NSString stringWithFormat:@"%@", msg]alertType:TopAlertViewSuccessType];
                                                           [weakself.navigationController popViewControllerAnimated:YES];
                                                           
                                                       }else{
                                                           CLog(@"修改失败");
                                                           [CDTopAlertView showMsg:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] isErrorState:YES];
                                                       }
                                                  } failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
                                                      
                                                      [CDServerAPIs httpDataTask:dataTask error:error.error];
                                                      CLog(@"修改资料 error %@", error.error);
                                                  }];
}

- (void)updateSaveButtonStatus{
    
    if (([_nickNameTextField.text length] >= 1 && [_nickNameTextField.text length] <= 18)
        ) {
        
        [_saveButton setBackgroundColor:ZXHColorHEX(@"36D8FF", 1)];
        _saveButton.enabled = YES;
    }
    else{
        [_saveButton setBackgroundColor:[UIColor lightGrayColor]];
        _saveButton.enabled = NO;
    }
}

#pragma mark UITextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //不能输入空格
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
    
    if ([newValue length] > 18) {
        [self updateSaveButtonStatus];
        return NO;
    }
    else{
        [self updateSaveButtonStatus];
    }
    
    return YES;
}

@end
