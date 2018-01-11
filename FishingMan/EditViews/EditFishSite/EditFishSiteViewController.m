//
//  EditFishSiteViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/14.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "EditFishSiteViewController.h"
#import "EditRuleInfoViewController.h"
#import "FMPickerChooseMenu.h"
#import "FMMultiChooseMenu.h"

#import "LLImagePicker.h"
#import "CDServerAPIs+FishSite.h"

@interface EditFishSiteViewController ()<UIScrollViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *siteNameTextField;

@property (weak, nonatomic) IBOutlet UIView *pictureAddView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pictureAddViewHeight;

@property (weak, nonatomic) IBOutlet UILabel *siteAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteFeeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteFishTypeLabel;
@property (weak, nonatomic) IBOutlet UITextField *siteTelTextField;
@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UITextView *siteIntroduceTextView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *siteMoreInfoViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *moreInfoShowButton;
@property (weak, nonatomic) IBOutlet UIView   *siteMoreInfoContainer;

@property (weak, nonatomic) IBOutlet UISwitch *canParkSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *canNightSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *canEatSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *canHotelSwitch;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@property (assign, nonatomic) BOOL imageAllUploaded;

@property (strong, nonatomic) NSMutableArray * imageObjectArray; //原始图像对象列表
@property (strong, nonatomic) NSMutableArray * imageUrlStringArray; //图像上传后得到的链接地址列表
@end

@implementation EditFishSiteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.delegate  = self;
    self.siteMoreInfoViewHeight.constant = 40.0;
    self.siteMoreInfoContainer.hidden = YES;
    
    self.siteIntroduceTextView.delegate = self;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
//    [self.view addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(closeKeyboard)];
    [self.view addGestureRecognizer:pan];
    
    //创建图片添加区域
    self.imageObjectArray = [NSMutableArray array];
    self.imageUrlStringArray = [NSMutableArray array];
    
    //2、将图片地址放入专门的数组
    NSString * imageURLStr = @"http://diaoyudaxian01.b0.upaiyun.com/fish/201710/f972c018-c83f-4a52-8f21-338079ac27ff";
    [self.imageUrlStringArray addObject:imageURLStr];
    
    [self setUpPictureAddView];
}

- (void)closeKeyboard{
    
    if([self.siteNameTextField isFirstResponder]) {
        [self.siteNameTextField resignFirstResponder];
    }
    else if([self.siteTelTextField isFirstResponder]){
        [self.siteTelTextField resignFirstResponder];
    }
    else if([self.siteIntroduceTextView isFirstResponder]){
        [self.siteIntroduceTextView resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
        
        NSLog(@"site image list ======== %@",list);
        
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

- (IBAction)showSiteMoreInfoView:(id)sender {
    [self closeKeyboard];
    
    if(self.siteMoreInfoViewHeight.constant > 40.0){
        self.siteMoreInfoViewHeight.constant = 40.0;
        self.siteMoreInfoContainer.hidden = YES;
        [self.moreInfoShowButton setTitle:@"更多设置" forState:UIControlStateNormal];
    }
    else{
        self.siteMoreInfoViewHeight.constant = 220.0;
        self.siteMoreInfoContainer.hidden = NO;
        [self.moreInfoShowButton setTitle:@"收起" forState:UIControlStateNormal];
    }
}

//钓鱼地址
- (IBAction)siteAddressButtonAction:(id)sender {
    [self closeKeyboard];
    
}
//钓场的类型
- (IBAction)siteTypeButtonAction:(id)sender {
    [self closeKeyboard];
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"湖库",@"江河",@"堰塘",@"野塘",@"收费塘",@"斤塘",@"黑坑",@"农家乐",@"小溪",@"深潭",@"大海",@"其他水域",nil];
    [self chooseWithArray:array button:sender];
}
//钓场的收费类型
- (IBAction)siteFeeTypeButtonAction:(UIButton *)sender {
    [self closeKeyboard];
    
    NSArray *array0 = [[NSArray alloc]initWithObjects:@"免费",@"8",@"10",@"12",@"15",@"18",@"20",@"25",@"30",@"40",@"50",@"80",@"100",@"150",@"200",@"300",nil];
    NSArray *array1 = [[NSArray alloc]initWithObjects:@"天",@"斤",@"小时",nil];
    NSArray * array = [[NSArray alloc] initWithObjects:array0,array1,nil];
    
    [self doublechooseWithArray:array button:sender];
}
//钓场的鱼种类
- (IBAction)siteFishTypeButtonAction:(UIButton *)sender {
    [self closeKeyboard];
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"鲫鱼",@"鲤鱼",@"草鱼",@"鳙鲢",@"罗非鱼",@"青鱼",@"黑鱼",@"翘嘴",@"鳜鱼",@"马口鱼",@"鲶鱼",@"鲈鱼",@"鲮鱼",@"黄颡鱼",@"鳊鱼",@"白鲦",@"其他鱼种",nil];
    [self muiltychooseWithArray:array button:sender ];
}
//更多设置
- (IBAction)switchButtonAction:(UISwitch *)sender {
    [self closeKeyboard];
    
    NSString * string = @"";
    if (sender == _canParkSwitch) {
        string = sender.on?@"可以停车":@"不可以停车";
    }
    else if (sender == _canNightSwitch){
        string = sender.on?@"可以夜钓":@"不可以夜钓";
    }
    else if (sender == _canEatSwitch){
        string = sender.on?@"提供餐饮":@"不提供餐饮";
    }
    else if (sender == _canHotelSwitch){
        string = sender.on?@"提供住宿":@"不提供住宿";
    }
    CLog(@"string = %@", string);
}
//发表
- (IBAction)sendButtonAction:(id)sender {
    [self closeKeyboard];
    
    [self prepareSiteInfo];
}

- (void)prepareSiteInfo{
    
//    if(self.imageAllUploaded == NO){
//        [CDTopAlertView showMsg:@"图片暂未上传完毕" alertType:TopAlertViewWarningType];
//        return;
//    }
    
    //钓场名称
    if([ZXHTool isEmptyString:self.siteNameTextField.text]){
        [CDTopAlertView showMsg:@"请填写钓场名称" alertType:TopAlertViewWarningType];
        return;
    }
    
    //钓点图片至少上传一张
    if(self.imageUrlStringArray.count == 0){
        [CDTopAlertView showMsg:@"至少上传一张钓点图片" alertType:TopAlertViewWarningType];
        return;
    }
    
    //钓点位置
    if([ZXHTool isEmptyString:self.siteAddressLabel.text]){
        [CDTopAlertView showMsg:@"请选择钓点位置" alertType:TopAlertViewWarningType];
        return;
    }
    
    //钓场类型
    if([ZXHTool isEmptyString:self.siteTypeLabel.text]){
        [CDTopAlertView showMsg:@"请选择钓场类型" alertType:TopAlertViewWarningType];
        return;
    }
    
    //收费类型
    if([ZXHTool isEmptyString:self.siteFeeTypeLabel.text]){
        [CDTopAlertView showMsg:@"请选择收费类型" alertType:TopAlertViewWarningType];
        return;
    }
    
    //鱼种
    if([ZXHTool isEmptyString:self.siteFishTypeLabel.text]){
        [CDTopAlertView showMsg:@"请选鱼种类" alertType:TopAlertViewWarningType];
        return;
    }
    
    //电话
    if(![ZXHTool isEmptyString:self.siteFishTypeLabel.text]){
        if(![ZXHTool isPhoneNumber:self.siteTelTextField.text]){
            [CDTopAlertView showMsg:@"手机号码格式错误" alertType:TopAlertViewWarningType];
            return;
        }
    }
    
    //详细描述
    if([ZXHTool isEmptyString:self.siteIntroduceTextView.text]){
        [CDTopAlertView showMsg:@"请填写钓点钓场介绍" alertType:TopAlertViewWarningType];
        return;
    }
    
    
    
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionary];
    
    //登录用户的userId
    FMLoginUser * user = [FMLoginUser getCacheUserInfo];
    if (![ZXHTool isNilNullObject:user]) {
        [requestDic setObject:user.userId forKey:@"userId"];
    }
    
    [requestDic setObject:self.siteNameTextField.text forKey:@"title"];
    
    [requestDic setObject:self.siteAddressLabel.text forKey:@"address"];
    [requestDic setObject:@"104.063377" forKey:@"lng"];//经度longitude
    [requestDic setObject:@"30.487958" forKey:@"lat"];//纬度latitude
    
    [requestDic setObject:self.siteIntroduceTextView.text forKey:@"introduce"];
    [requestDic setObject:self.siteIntroduceTextView.text forKey:@"content"];
    
    for (int i = 0; i < self.imageUrlStringArray.count; i++){
        
        if (i == 4) {
            break;
        }
        NSString * picUrlStr = [self.imageUrlStringArray objectAtIndex:i];
        NSString * picKeyName = [NSString stringWithFormat:@"pic%d", i];
        [requestDic setObject:picUrlStr forKey:picKeyName];
    }
    
    [requestDic setObject:self.siteTypeLabel.text forKey:@"siteType"];
    [requestDic setObject:self.siteFeeTypeLabel.text forKey:@"siteFeeType"];
    [requestDic setObject:self.siteFishTypeLabel.text forKey:@"siteFishType"];
    
//    [requestDic setObject:[NSNumber numberWithInt:1] forKey:@"siteType"];
//    [requestDic setObject:[NSNumber numberWithInt:1] forKey:@"siteFeeType"];
//    [requestDic setObject:[NSNumber numberWithInt:1] forKey:@"siteFishType"];
    
    [requestDic setObject:self.siteTelTextField.text forKey:@"sitePhone"];
    
    //更多设置显示
    [requestDic setObject:[NSNumber numberWithBool:self.canParkSwitch.on] forKey:@"canPark"];
    [requestDic setObject:[NSNumber numberWithBool:self.canNightSwitch.on] forKey:@"canNight"];
    [requestDic setObject:[NSNumber numberWithBool:self.canEatSwitch.on] forKey:@"canEat"];
    [requestDic setObject:[NSNumber numberWithBool:self.canHotelSwitch.on] forKey:@"canHotel"];
    
    //publisherType            int         发布者类型（0官方、1场主、2钓友）
    [requestDic setObject:[NSNumber numberWithInt:2] forKey:@"publishType"];
    
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] fishSitePublishWithContent:(NSMutableDictionary *)requestDic
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


#pragma mark 选择的滚轮

//双选
- (void)doublechooseWithArray:(NSArray *)array button:(UIButton *)button{
    
    ZXH_WEAK_SELF
    FMPickerChooseMenu * picker = [FMPickerChooseMenu shareWithTarget:self
                                                           wholeArray:array
                                                           kindTitles:nil
                                                             callback:^(NSMutableArray * arrayOfDic){
                                                                 
                                                                 NSString *wholeStr = @"";
                                                                 
                                                                 for (int i = 0; i<arrayOfDic.count; i++) {
                                                                     
                                                                     NSString * value = arrayOfDic[i];
                                                                     if(i == 0){
                                                                         wholeStr = value;
                                                                     }
                                                                     else{
                                                                         wholeStr = [wholeStr stringByAppendingString:[NSString stringWithFormat:@"元/%@", value]];
                                                                     }
                                                                 }
                                                                 
                                                                 if([wholeStr containsString:@"免费"]){
                                                                     wholeStr = @"免费";
                                                                 }
                                                                 
                                                                 [weakself.siteFeeTypeLabel setText:wholeStr];
                                                             }];
    
    [picker show];
}
//单选
- (void)chooseWithArray:(NSArray *)array button:(UIButton *)button{
    ZXH_WEAK_SELF
    FMPickerChooseMenu * picker = [FMPickerChooseMenu shareWithTarget:self
                                                                array:array
                                                             callback:^(NSMutableArray * arrayOfDic){
                                                                 
                                                                 NSString * value = arrayOfDic[0];
                                                                 [weakself.siteTypeLabel setText:value];
                                                             }];
    [picker show];
}
//多选
- (void)muiltychooseWithArray:(NSArray *)array button:(UIButton *)button{
    ZXH_WEAK_SELF
    FMMultiChooseMenu * picker = [FMMultiChooseMenu shareWithTarget:self array:array callback:^(NSArray *array) {
        
        NSString * valueStr = @"";
        if (array.count > 0) {
            for (int i = 0; i < array.count; i++) {
                NSString * str = array[i];
                if (i == (array.count-1)) {
                    valueStr = [valueStr stringByAppendingString:[NSString stringWithFormat:@"%@", str]];
                }
                else{
                    valueStr = [valueStr stringByAppendingString:[NSString stringWithFormat:@"%@,", str]];
                }
            }
        }
        else{
            valueStr = @"";
        }
        
        [weakself.siteFishTypeLabel setText:valueStr];
    }];
    [picker show];
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
    
    if(self.siteTelTextField == textField){
        
        if ([newValue length] > 11) {
            return NO;
        }
    }
    
    return YES;
}
@end
