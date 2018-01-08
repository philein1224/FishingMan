//
//  EditFishStoreViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/14.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "EditFishStoreViewController.h"
#import "EditRuleInfoViewController.h"
#import "LLImagePicker.h"
#import "CDServerAPIs+FishStore.h"

@interface EditFishStoreViewController ()<UIScrollViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *storeNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;

@property (weak, nonatomic) IBOutlet UIView *pictureAddView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureAddViewHeight;

@property (weak, nonatomic) IBOutlet UITextField *storeAddressTextField;
@property (weak, nonatomic) IBOutlet UIButton *storeAddressButton;

@property (weak, nonatomic) IBOutlet UITextField *storeTelTextField;
@property (weak, nonatomic) IBOutlet UITextView *storeIntroduceTextView;

@property (weak, nonatomic) IBOutlet UIButton *isFisherButton;
@property (weak, nonatomic) IBOutlet UIButton *isShopmanButton;

@property (assign, nonatomic) BOOL imageAllUploaded;

@property (strong, nonatomic) NSMutableArray * imageObjectArray; //原始图像对象列表
@property (strong, nonatomic) NSMutableArray * imageUrlStringArray; //图像上传后得到的链接地址列表
@end

@implementation EditFishStoreViewController
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.delegate  = self;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
//    [self.view addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:pan];
    
    self.storeIntroduceTextView.delegate = self;
    
    //创建图片添加区域
    self.imageObjectArray = [NSMutableArray array];
    self.imageUrlStringArray = [NSMutableArray array];
    
    //2、将图片地址放入专门的数组
    NSString * imageURLStr0 = @"http://diaoyudaxian01.b0.upaiyun.com/fish/201710/f972c018-c83f-4a52-8f21-338079ac27ff";
    NSString * imageURLStr1 = @"http://diaoyudaxian01.b0.upaiyun.com/fish/201711/2513f201-0c19-44de-9623-904598043e62";
    [self.imageUrlStringArray addObject:imageURLStr0];
    [self.imageUrlStringArray addObject:imageURLStr1];
    
    [self setUpPictureAddView];
}

- (void)closeKeyboard{
    
    if ([self.storeNameTextField isFirstResponder]) {
        [self.storeNameTextField resignFirstResponder];
    }
    else if ([self.storeAddressTextField isFirstResponder]){
        [self.storeAddressTextField resignFirstResponder];
    }
    else if ([self.storeTelTextField isFirstResponder]){
        [self.storeTelTextField resignFirstResponder];
    }
    else if ([self.storeIntroduceTextView isFirstResponder]){
        [self.storeIntroduceTextView resignFirstResponder];
    }
}

- (IBAction)ruleButtonAction:(id)sender {
    [self closeKeyboard];
    
    EditRuleInfoViewController * ruleInfoViewCtrl = [[EditRuleInfoViewController alloc] init];
    ruleInfoViewCtrl.navigationTitle = @"入驻规则";
    [self.navigationController pushViewController:ruleInfoViewCtrl animated:YES];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self closeKeyboard];
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark 选择和上传图片
- (void)setUpPictureAddView{
    
    CGFloat height = [LLImagePickerView defaultViewHeight];
    CLog(@"height = %f, xib height = %f", height, self.pictureAddView.frame.size.height);
    _pictureAddViewHeight.constant = height;
    
    /*
    CGRect menuframe = CGRectMake(0, 0, ZXHScreenWidth, height);//ZXHRatioWithReal375 * 88.0
    UIView *tempFooterView = [[UIView alloc]init];
    [tempFooterView setBackgroundColor:[UIColor greenColor]];
    tempFooterView.frame = menuframe;
    tempFooterView.clipsToBounds = YES;
    [tempFooterView addSubview:pickerV];
    */
    
    LLImagePickerView *pickerV = [[LLImagePickerView alloc]initWithFrame:CGRectMake(0, 0, ZXHScreenWidth, height)];
    pickerV.type = LLImageTypePhotoAndCamera;       //可以进行拍照📷和相册📁
    pickerV.maxImageSelected = 4;                   //最多选择4张图片
    pickerV.allowRepeatedSelection = NO;            //是否允许同样的图片视频重复选择
    
    ZXH_WEAK_SELF
    [pickerV observeSelectedMediaArray:^(NSArray<LLImagePickerModel *> *list) {
        NSLog(@"list ======== %@",list);
        
//        if (![ZXHTool isNilNullObject:list]) {
//            [weakself uploadImageWithImageObjArray:[NSMutableArray arrayWithArray:list]];
//        }
    }];
    
    pickerV.guestureRecognizedBlock = ^{
        [weakself closeKeyboard];
    };
    
    [self.pictureAddView addSubview:pickerV];
}

- (void)uploadImageWithImageObjArray:(NSMutableArray *)array{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    self.imageObjectArray = array;
    
    for (int i = 0; i < array.count; i++) {
        
        LLImagePickerModel *model = self.imageObjectArray[i];
        [self uploadImage:model.image];
    }
}

- (void)uploadImage:(UIImage *)image{
    
    //1、上传n次图像文件
    
    //缩小图片的KB大小
    NSData *uploadData = nil;
    if (image) {
        uploadData = UIImageJPEGRepresentation(image, 0.0001);
    }
    
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] uploadImageBlock:^(id<AFMultipartFormData> formData) {
        
        if (uploadData) {
            [formData appendPartWithFileData:uploadData name:@"imgFile" fileName:@"imgFile.png" mimeType:@"image/gif,image/jpeg,image/jpg,image/png"];
        }
    } Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        CLog(@"上传图片成功： %@",responseObject);
        
        //2、将图片地址放入专门的数组
        //@"http://diaoyudaxian01.b0.upaiyun.com/fish/201710/f972c018-c83f-4a52-8f21-338079ac27ff";
        NSString * imageURLStr = [NSString stringWithFormat:@"%@", responseObject[@"data"]];
        [weakself.imageUrlStringArray addObject:imageURLStr];
        
        [weakself checkIfUploadedSuccess:YES];
        
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        
        CLog(@"上传图片失败： %@",error.error);
        [weakself checkIfUploadedSuccess:NO];
    }];
}

static int count = 0;
- (void)checkIfUploadedSuccess:(BOOL)success{
    
    count = count + 1;
    
    //图片对象数组和图片地址数组一致时，表示图片已经全部上传完毕。
    if(self.imageUrlStringArray.count == self.imageObjectArray.count){
        
        self.imageAllUploaded = YES;
        
        count = 0;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        return;
    }
    //后台返回次数和图片对象数组一致时，表示图片上传有失败的情况。
    if(count == self.imageObjectArray.count){
        
        self.imageAllUploaded = NO;
        
        count = 0;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

//通过地图转化位置
- (IBAction)getStoreAddressButton{
    [self closeKeyboard];
    
    //判断定位功能是否开通，没有开通给予提示开通步骤
    CLog(@"通过地图转化位置");
}

//是否是钓鱼人活着渔具店主
- (IBAction)isFisherOrShopmanButtonAction:(UIButton *)senderButton {
    [self closeKeyboard];
    
    BOOL isFisher = NO;
    
    if(senderButton == _isFisherButton){
        _isFisherButton.selected = YES;
        _isShopmanButton.selected = NO;
        isFisher = YES;
    }
    else if(senderButton == _isShopmanButton){
        _isFisherButton.selected = NO;
        _isShopmanButton.selected = YES;
        isFisher = NO;
    }
    CLog(@"%d, %@", isFisher, isFisher? @"钓鱼人":@"渔具店主");
}

#pragma mark 提交渔具店入驻申请
//提交渔具店入驻申请
- (IBAction)sendButtonAction:(id)sender {
    [self closeKeyboard];
    
    [self prepareStoreInfo];
}

- (void)prepareStoreInfo{
    
    //    if(self.imageAllUploaded == NO){
    //        [CDTopAlertView showMsg:@"图片暂未上传完毕" alertType:TopAlertViewWarningType];
    //        return;
    //    }
    
    //钓场名称
    if([ZXHTool isEmptyString:self.storeNameTextField.text]){
        [CDTopAlertView showMsg:@"请填写渔具店名称" alertType:TopAlertViewWarningType];
        return;
    }
    
    //钓点图片至少上传一张
    if(self.imageUrlStringArray.count == 0){
        [CDTopAlertView showMsg:@"至少上传一张店铺图片" alertType:TopAlertViewWarningType];
        return;
    }
    
    //渔具店位置
    if([ZXHTool isEmptyString:self.storeAddressTextField.text]){
        [CDTopAlertView showMsg:@"请选择渔具店位置" alertType:TopAlertViewWarningType];
        return;
    }
    
    //渔具店电话
    if([ZXHTool isEmptyString:self.storeTelTextField.text]){
        [CDTopAlertView showMsg:@"请填写渔具店联系电话" alertType:TopAlertViewWarningType];
        return;
    }else{
        if(![ZXHTool isPhoneNumber:self.storeTelTextField.text]){
            [CDTopAlertView showMsg:@"手机号码格式错误" alertType:TopAlertViewWarningType];
            return;
        }
    }
    
    //渔具店简介
    if([ZXHTool isEmptyString:self.storeIntroduceTextView.text]){
        [CDTopAlertView showMsg:@"请填写渔具店介绍" alertType:TopAlertViewWarningType];
        return;
    }
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    [requestDic setObject:self.storeNameTextField.text forKey:@"title"];
    [requestDic setObject:self.storeIntroduceTextView.text forKey:@"introduce"];
    [requestDic setObject:self.storeIntroduceTextView.text forKey:@"content"];
    [requestDic setObject:self.storeAddressTextField.text forKey:@"address"];
    [requestDic setObject:@"104.163377" forKey:@"lng"];//经度longitude
    [requestDic setObject:@"30.687958" forKey:@"lat"];//纬度latitude
    [requestDic setObject:self.storeTelTextField.text forKey:@"sitePhone"];
    
    for (int i = 0; i < self.imageUrlStringArray.count; i++){
        
        if (i == 4) {
            break;
        }
        NSString * picUrlStr = [self.imageUrlStringArray objectAtIndex:i];
        NSString * picKeyName = [NSString stringWithFormat:@"pic%d", i];
        [requestDic setObject:picUrlStr forKey:picKeyName];
    }
    int publisherType = 0;    //发布者类型（0官方、1钓友、2店主）
    //publisherType            int         发布者类型（0官方、1场主、2钓友）
    [requestDic setObject:[NSNumber numberWithInt:publisherType] forKey:@"publishType"];
    
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] fishStorePublishWithContent:(NSMutableDictionary *)requestDic
                                                Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
                                                    
                                                    CLog(@"responseObject = %@", responseObject);
                                                    if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
                                                        [CDTopAlertView showMsg:[NSString stringWithFormat:@"发布成功"] alertType:TopAlertViewSuccessType];
                                                        [weakself dismissViewControllerAnimated:YES completion:^{}];
                                                    }
                                                    else{
                                                        
                                                        [CDTopAlertView showMsg:[NSString stringWithFormat:@"发布失败，%@", responseObject[@"msg"]] alertType:TopAlertViewFailedType];
                                                    }
                                                } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
                                                    
                                                    CLog(@"responseObject = %@", error.error);
                                                    [CDServerAPIs httpDataTask:dataTask error:error.error];
                                                }];
}

#pragma mark UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self closeKeyboard];
}

#pragma mark UITextView Delegate
-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView.text.length == 0) {
        self.placeHolderLabel.text = @"请输入店铺介绍";
        self.placeHolderLabel.hidden = NO;
    }else{
        self.placeHolderLabel.text = @"";
        self.placeHolderLabel.hidden = YES;
    }
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
    
    if(self.storeTelTextField == textField){
        
        if ([newValue length] > 11) {
            return NO;
        }
    }
    
    return YES;
}
@end
