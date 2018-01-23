//
//  EditViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/12.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "EditViewController.h"
#import "EditRuleInfoViewController.h"
#import "ZXHTypeSelectView.h"
#import "EditTitleView.h"
#import "EditContentTableViewCell.h"
#import "EditContentModel.h"
#import "EditFooterMenuView.h"
#import "FMDatePickerView.h"

//图片加载
#import "TZImagePickerController.h"
#import "LLImagePickerConst.h"
#import "LLImagePickerManager.h"
#import "LLImagePickerModel.h"

#import "CDServerAPIs+MainPage.h"

@interface EditViewController ()
<UITableViewDelegate,UIScrollViewDelegate,
UITableViewDataSource,
TZImagePickerControllerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) EditTitleView *titleEditView;
@property (strong, nonatomic) EditFooterMenuView * editFooterMenuView;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
@property (weak, nonatomic) IBOutlet UIButton *selectTypeButton;


/** 是否允许 同个图片或视频进行多次选择. default is YES */
@property (nonatomic, assign) BOOL allowRepeatedSelection;
/** 最大资源选择个数,（包括 preShowMedias 预先展示数据）. default is 30 */
@property (nonatomic, assign) NSInteger maxImageSelected;
/** 总的媒体数组 */
@property (nonatomic, strong) NSMutableArray *mediaArray;
/** 单次选择的媒体数组 */
@property (nonatomic, strong) NSMutableArray *singleGroupMediaArray;
/** 记录从相册中已选的Image Asset */
@property (nonatomic, strong) NSMutableArray *selectedImageAssets;
/** 记录从相册中已选的Image model */
@property (nonatomic, strong) NSMutableArray *selectedImageModels;
/** 记录从相册中已选的Video model*/
@property (nonatomic, strong) NSMutableArray *selectedVideoModels;
/** 是否允许 在选择图片的同时可以选择视频文件. default is NO */
@property (nonatomic, assign) BOOL allowPickingVideo;
/** 是否 添加在 present 出来的控制器（注意：没有装在NavigationController中 默认是 NO） */
@property (nonatomic, assign) BOOL isAddPresentVC;
@property (nonatomic, strong) UIViewController *rootVC;


@property (nonatomic, strong) NSMutableArray * allTextOrImageContentArray; //所有项目的元素【图片+文字】
@property (nonatomic, assign) NSInteger alreadyImageSelected;//已经选择了的图片数量

@property (nonatomic, assign) NSInteger indexOfCurrentUpload;//当前正在上传的静态资源
@property (assign, nonatomic) BOOL imageAllUploaded; //所有图片是否已上传完毕
@property (strong, nonatomic) NSMutableArray * imageUrlStringArray; //图像上传后得到的链接地址列表

@property (copy, nonatomic) void (^uploadingFinished)(BOOL finished);//上传结束后回调

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //重新加载之前未完成的数据
    _allTextOrImageContentArray = [[NSMutableArray alloc]init];
    self.imageUrlStringArray = [NSMutableArray array];
    
    //1、标题&顶部的导航栏
    NSMutableArray * allTypeNameArray = ALL_ARTICLE_TYPE_NAME_ARRAY;
    [self.selectTypeButton setTitle:allTypeNameArray[self.articleType] forState:UIControlStateNormal];
    [self refreshSelectTypeButton];
    
    //2、注册文章列表Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"EditContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"EditContentTableViewCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    //3、钓获文章特有数据设置视图，放在tableView的headerView
    CGRect titleframe = CGRectZero;
    if (self.articleType == FMArticleTypeHarvest) {
        titleframe = CGRectMake(0, 0, ZXHScreenWidth, 50 + 392 -176);
    }
    else{
        titleframe = CGRectMake(0, 0, ZXHScreenWidth, 50);
    }
    
    UIView *tempHeaderView = [[UIView alloc]init];
    tempHeaderView.frame = titleframe;
    tempHeaderView.clipsToBounds = YES;
    
    self.titleEditView = [[[NSBundle mainBundle] loadNibNamed:@"EditTitleView" owner:nil options:nil] firstObject];
    self.titleEditView.articleType = self.articleType;
    self.titleEditView.frame = titleframe;
    
    ZXH_WEAK_SELF
    self.titleEditView.closeKeyboardBlock = ^{
        [weakself closeKeyboard];
    };
    
    if (self.articleType == FMArticleTypeHarvest){
        
        //是否显示另外四种参数设置
        self.titleEditView.moreMaterialShowAndHide = ^(BOOL isShow){
            
            if(isShow){
                tempHeaderView.frame = CGRectMake(0, 0, ZXHScreenWidth, 50 + 392);
            }
            else{
                tempHeaderView.frame = CGRectMake(0, 0, ZXHScreenWidth, 50 + 392 -176);
            }
            weakself.tableView.tableHeaderView = tempHeaderView;
        };
    }
    
    [tempHeaderView addSubview:self.titleEditView];
    [self.tableView beginUpdates];
    self.tableView.tableHeaderView = tempHeaderView;
    [self.tableView endUpdates];
    
    //4、钓获文章的底部功能设置视图，放在tableView的footerView
    CGRect menuframe = CGRectMake(0, 0, ZXHScreenWidth, 80);
    UIView *tempFooterView = [[UIView alloc]init];
    tempFooterView.frame = menuframe;
    tempFooterView.clipsToBounds = YES;
    
    self.editFooterMenuView = [[[NSBundle mainBundle] loadNibNamed:@"EditFooterMenuView" owner:nil options:nil] firstObject];
    self.editFooterMenuView.frame = tempFooterView.bounds;
    [tempFooterView addSubview:self.editFooterMenuView];
    
    self.editFooterMenuView.editFooterMenuViewCallback = ^(NSInteger menuType){
        
        [weakself editFooterMenuCallback:menuType];
    };
    
    [self.tableView beginUpdates];
    self.tableView.tableFooterView = tempFooterView;
    [self.tableView endUpdates];
    
    //5、图片选择视图
    [self initMultiMediaPickerView];
    
    //6、图片上传回调循环
    self.uploadingFinished = ^(BOOL finished) {
        
        weakself.indexOfCurrentUpload = weakself.indexOfCurrentUpload + 1;
        if(weakself.indexOfCurrentUpload < weakself.singleGroupMediaArray.count){
            LLImagePickerModel *model = weakself.singleGroupMediaArray[weakself.indexOfCurrentUpload];
            [weakself uploadImage:model.image name:model.name];
        }
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)closeKeyboard{
    
    [_titleEditView closeKeyboard];
    
    [self hideKeyBoard];
}

- (void)hideKeyBoard{
    
    NSInteger rowNumber = [self.tableView numberOfRowsInSection:0];
    if (rowNumber == 0) {
        return;
    }
    
    for (NSInteger i = 0; i < rowNumber; i++) {
        
        EditContentModel * model = [_allTextOrImageContentArray objectAtIndex:i];
        if (model.editContentType == EditContentTypeText) {
            
            EditContentTableViewCell * cell = (EditContentTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            if([cell closeKeyboard]){
               break;
            }
            else{
                continue;
            }
        }
        else{
            continue;
        }
    }
}

#pragma mark 文章类型选择菜单
- (IBAction)selectTypeButtonAction:(id)sender {
    
    [self closeKeyboard];
    
    NSMutableArray * allTypeNameArray = ALL_ARTICLE_TYPE_NAME_ARRAY;
    
    ZXH_WEAK_SELF
    [ZXHTypeSelectView show:allTypeNameArray withSelected:_articleType callback:^(NSInteger type, NSString * typeName) {
        
        [weakself.selectTypeButton setTitle:typeName forState:UIControlStateNormal];
        weakself.articleType = type;
        [weakself refreshSelectTypeButton];
    }];
}
- (void)refreshSelectTypeButton{
    
    if(self.articleType == FMArticleTypeHarvest){
        _arrowImageView.hidden = YES;
        _selectTypeButton.hidden = YES;
    }
    else{
        _arrowImageView.hidden = NO;
        _selectTypeButton.hidden = NO;
    }
}

#pragma mark 发帖规则
- (IBAction)ruleButtonAction:(id)sender {
    
    [self closeKeyboard];
    
    EditRuleInfoViewController * ruleInfoViewCtrl = [[EditRuleInfoViewController alloc] init];
    ruleInfoViewCtrl.navigationTitle = @"发帖规则";
    [self.navigationController pushViewController:ruleInfoViewCtrl animated:YES];
}

#pragma mark 取消发帖
- (IBAction)backButtonAction:(id)sender {
    
    [self closeKeyboard];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark 发布帖子
//过滤按钮上的文字
- (NSString *)buttonTitle:(UIButton *)button{
    
    if([ZXHTool isEmptyString:button.titleLabel.text] ||
       [button.titleLabel.text isEqualToString:@"请选择"] ||
       [button.titleLabel.text isEqualToString:@"出钓时间"]){
        return @"";
    }
    return button.titleLabel.text;
}
//检查钓获文章必传参数
- (BOOL)checkInputItemsWithArticleType:(FMArticleType)type{
    
    if([ZXHTool isEmptyString:self.titleEditView.articleTitleTextField.text]){
        [CDTopAlertView showMsg:@"请填写文章标题" alertType:TopAlertViewWarningType];
        return NO;
    }
    
    //针对钓获文章的检测
    if (type == FMArticleTypeHarvest){
        
        if([ZXHTool isEmptyString:[self buttonTitle:self.titleEditView.fishTimeBtn]]){
            [CDTopAlertView showMsg:@"请选择出钓时间" alertType:TopAlertViewWarningType];
            return NO;
        }
        if([ZXHTool isEmptyString:[self buttonTitle:self.titleEditView.fishWaterBtn]]){
            [CDTopAlertView showMsg:@"请选择钓场水域" alertType:TopAlertViewWarningType];
            return NO;
        }
        if([ZXHTool isEmptyString:[self buttonTitle:self.titleEditView.fishFoodBtn]]){
            [CDTopAlertView showMsg:@"请选择所用鱼饵" alertType:TopAlertViewWarningType];
            return NO;
        }
        if([ZXHTool isEmptyString:[self buttonTitle:self.titleEditView.fishTypeBtn]]){
            [CDTopAlertView showMsg:@"请选择钓获鱼种" alertType:TopAlertViewWarningType];
            return NO;
        }
    }
    
    //无文字／图片内容
    if(_allTextOrImageContentArray.count == 0){
        [CDTopAlertView showMsg:@"请编辑文章内容" alertType:TopAlertViewWarningType];
        return NO;
    }
    
    return YES;
}
//发布钓鱼的文章[渔获和普通文章]
- (IBAction)sendButtonAction:(id)sender {
    
    [self closeKeyboard];
    
    if(![self checkInputItemsWithArticleType:self.articleType]){
        //文章发表的判断
        return;
    }
    
    NSMutableDictionary * publishInfo = [[NSMutableDictionary alloc] init];
    
    //登录用户的userId
    FMLoginUser * user = [FMLoginUser getCacheUserInfo];
    if (![ZXHTool isNilNullObject:user]) {
        [publishInfo setObject:user.userId forKey:@"userId"];
    }
    
    //钓鱼收获发表
    if (self.articleType == FMArticleTypeHarvest){
        
        NSString * time = [ZXHTool millisecondStringFromDateString2:[self buttonTitle:self.titleEditView.fishTimeBtn]];
        [publishInfo setObject:time forKey:@"fishTime"];
        
        [publishInfo setObject:[self buttonTitle:self.titleEditView.fishWaterBtn] forKey:@"waterType"];
        [publishInfo setObject:[self buttonTitle:self.titleEditView.fishFoodBtn] forKey:@"bait"];
        [publishInfo setObject:[self buttonTitle:self.titleEditView.fishTypeBtn] forKey:@"fishType"];
        
        //所有元素上传
        if (self.titleEditView.allItemsShowed){
            
            [publishInfo setObject:[self buttonTitle:self.titleEditView.fishFuncBtn] forKey:@"fishingFunc"];
            [publishInfo setObject:[self buttonTitle:self.titleEditView.fishLinesBtn] forKey:@"fishLines"];
            [publishInfo setObject:[self buttonTitle:self.titleEditView.fishPoleLengthBtn] forKey:@"fishPoleLength"];
            [publishInfo setObject:[self buttonTitle:self.titleEditView.fishPoleBrandBtn] forKey:@"fishPoleBrand"];
        }
        
        [publishInfo setObject:@"104.063377" forKey:@"lng"];//经度longitude
        [publishInfo setObject:@"30.487958" forKey:@"lat"];//纬度latitude
        [publishInfo setObject:@"华阳街道麓山大道一段洛森堡映山张小辉" forKey:@"locationAddress"];
    }
    
    [publishInfo setObject:[NSNumber numberWithInt:self.articleType] forKey:@"articleType"];//文章类型
    [publishInfo setObject:self.titleEditView.articleTitleTextField.text forKey:@"title"];//文章标题
    
#pragma mark 图片和文字的内容
    
    //图文资料json
    NSMutableArray * plainContentArray;
    if(_allTextOrImageContentArray.count >= 1){
        
        plainContentArray = [NSMutableArray array];
        
        for (EditContentModel *editModel in _allTextOrImageContentArray) {
            
            if(editModel.editContentType == EditContentTypeImage){
                [plainContentArray addObject:editModel.imageUrl];
            }
            else if (editModel.editContentType == EditContentTypeText){
                [plainContentArray addObject:editModel.text];
            }
        }

#warning 测试数据 start
        NSString * imageURLStr = @"http://diaoyudaxian01.b0.upaiyun.com/fish/201712/8aed8074-b081-4615-834a-b9e22e22e725";
        [plainContentArray addObject:imageURLStr];
        
        NSString * imageURLStr1 = @"http://diaoyudaxian01.b0.upaiyun.com/fish/201712/a47136e5-c547-4951-a9c9-c83bba2e06cf";
        [plainContentArray addObject:imageURLStr1];
        
        NSString * imageURLStr2 = @"http://diaoyudaxian01.b0.upaiyun.com/fish/201710/f972c018-c83f-4a52-8f21-338079ac27ff";
        [plainContentArray addObject:imageURLStr2];
        
        NSString * imageURLStr3 = @"http://diaoyudaxian01.b0.upaiyun.com/fish/201712/1ad6db12-5a57-4481-95f0-bab4619a4724";
        [plainContentArray addObject:imageURLStr3];
#warning 测试数据 end
        
    }else{
        return;
    }
    
    NSString * jsonContent = [ZXHTool dataToJsonString: plainContentArray];
    
//    NSString * jsonContent = [ZXHTool stringFromArray:plainContentArray];
    
//    NSData *data = [jsonContent dataUsingEncoding:NSUTF8StringEncoding];
//    jsonContent =  [data base64EncodedStringWithOptions:0];
    
    [publishInfo setObject:jsonContent forKey:@"content"];
    
#pragma mark 推荐图片
    
    //推荐图片
    NSMutableArray * recommendImgArray;
    recommendImgArray = [NSMutableArray array];
    NSString * imageURLStr1 = @"http://diaoyudaxian01.b0.upaiyun.com/fish/201712/a47136e5-c547-4951-a9c9-c83bba2e06cf";
    [recommendImgArray addObject:imageURLStr1];
    
    NSString * imageURLStr2 = @"http://diaoyudaxian01.b0.upaiyun.com/fish/201710/f972c018-c83f-4a52-8f21-338079ac27ff";
    [recommendImgArray addObject:imageURLStr2];
    
    NSString * imageURLStr3 = @"http://diaoyudaxian01.b0.upaiyun.com/fish/201712/1ad6db12-5a57-4481-95f0-bab4619a4724";
    [recommendImgArray addObject:imageURLStr3];
    
    NSString * recommendJsonContent = [ZXHTool dataToJsonString: recommendImgArray];
    
//    NSString * recommendJsonContent = [ZXHTool stringFromArray:recommendImgArray];
    
//    NSData *data1 = [recommendJsonContent dataUsingEncoding:NSUTF8StringEncoding];
//    recommendJsonContent =  [data1 base64EncodedStringWithOptions:0];
    
    [publishInfo setObject:recommendJsonContent forKey:@"recommends"];
    
        
    
    NSLog(@"ahsdhashdash ==== %@", [ZXHTool dataToJsonString:publishInfo]);
    
    //恢复回去
    NSArray * array = [ZXHTool dataConvertFromJsonString:jsonContent];
    CLog(@"恢复jsonContent 为数组 = %@", array);
    
    ZXH_WEAK_SELF
    [[CDServerAPIs shareAPI] articlePublishWithType:self.articleType ArticleContent:publishInfo Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        
        if([CDServerAPIs httpResponse:responseObject showAlert:YES DataTask:dataTask]){
        
            CLog(@"钓鱼方法：%@", self.titleEditView.fishFuncBtn.titleLabel.text);
            
            [CDTopAlertView showMsg:[NSString stringWithFormat:@"发布成功"] alertType:TopAlertViewSuccessType];
            [weakself backButtonAction:nil];
        }
        else{
            
            CLog(@"钓鱼文章上传 失败");
            
            [CDTopAlertView showMsg:[NSString stringWithFormat:@"上传失败，%@", responseObject[@"msg"]] alertType:TopAlertViewWarningType];
        }
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        
        CLog(@"钓鱼文章上传 失败：%@", error.error);
        [CDServerAPIs httpDataTask:dataTask error:error.error];
    }];
    
    
 /*
    return;
    
    UIImage * image = [UIImage imageNamed:@"0icon_D@2x.png"];
    NSData * uploadData = UIImagePNGRepresentation(image);
    NSString * uploadName = @"0icon_D@2x.png";
    
    
    //https相关的证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"diaoyuxiehui" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //AFSSLPinningModeNone AFSSLPinningModeCertificate
    if (certData) {
        NSSet *set = [NSSet setWithObjects:certData, nil];
        securityPolicy.pinnedCertificates = set;
    }
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO; //YES
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy = securityPolicy;
    
    //声明返回的结果是JSON格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //声明请求的数据是JSON类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain", @"text/html", @"multipart/form-data", @"boundary=AaB03x", nil];
    
//    NSString * url = @"https://diaoyuxiehui.cn/articalFish/uploadImgFile";
    NSString * url = @"https://diaoyuxiehui.cn/user/editUserInfo";
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    NSLog(@"==== %@", manager.requestSerializer.HTTPRequestHeaders);
    
    NSMutableDictionary * requestDic = [[NSMutableDictionary alloc] init];
    
    [requestDic setObject:@"18" forKey:@"id"];
//    [requestDic setObject:@"xiaohui" forKey:@"nikeName"];
//    [requestDic setObject:@"男" forKey:@"sex"];
//    [requestDic setObject:@"2017/08/18" forKey:@"birthday"];
//    
//    [requestDic setObject:@"2" forKey:@"avatarUrl"]; //待定
//    [requestDic setObject:@"2" forKey:@"address"];
    
    
    
    [manager POST:url parameters:requestDic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:uploadData
                                    name:@"imgFile"
                                fileName:@"imgFile.png"
                                mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        CLog(@"\n 1打印数据:%@", responseObject);
        NSData *doubi = responseObject;
        NSString *shabi =  [[NSString alloc]initWithData:doubi encoding:NSUTF8StringEncoding];
        CLog(@"\n 2打印数据:%@", shabi);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        CLog(@"3打印数据:%@",error);
    }];
    
    
    
    
    return;
    
    [[CDServerAPIs shareAPI] uploadImageBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:uploadData name:uploadName fileName:uploadName mimeType:@"image/png"];
        
    } Success:^(NSURLSessionDataTask *dataTask, id responseObject) {
        CLog(@"上传图片： %@",responseObject);
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        CLog(@"上传图片： %@",error.error);
    }];
  */
}



#pragma mark 底部编辑菜单工具栏按钮回调处理方法
- (void)editFooterMenuCallback:(NSInteger)actionType{
    
    [self closeKeyboard];
    
    switch (actionType) {
        case 2000:{
            //添加文字
            [self addMoreImage:NO];
        }
           break;
        case 2001:{
            //打开相册
            [self openAlbum];
        }
            break;
        case 2002:{
            //打开相机
            [self openCamera];
        }
            break;
        case 2003:{
            //增加定位
#warning 增加定位
        }
            break;
        case 2004:{
            //进入编辑模式
            [self.tableView setEditing:!self.tableView.editing animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 图文内容的处理
- (void)initMultiMediaPickerView{
    _maxImageSelected = 10;        //文章最多能选择多少张图片
    _alreadyImageSelected = 0;
    _allowRepeatedSelection = YES; //【允许重复选择】已经选择的,不会有打勾
    _isAddPresentVC = NO;
    _allowPickingVideo = NO;      //是否允许选择视频
    _mediaArray = [NSMutableArray array];
    _singleGroupMediaArray = [NSMutableArray array];
    _selectedImageAssets = [NSMutableArray array];
    _selectedVideoModels = [NSMutableArray array];
    _selectedImageModels = [NSMutableArray array];
    _rootVC = [self getTopController];
}

- (UIViewController *)getTopController{
    
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

// 相册
- (void)openAlbum {
    
    if(_alreadyImageSelected >= _maxImageSelected){
        NSString * alert = [NSString stringWithFormat:@"你已添加%ld张图片,不能继续添加了", _alreadyImageSelected];
        [ZXHViewTool alertViewTitle:@"温馨提醒"
                            Tartget:self
                            Message:alert
                         ActionName:@"确认"
                        ActionStyle:UIAlertActionStyleDefault
                      ActionHandler:^(UIAlertAction *action) {
                          
                      }];
        return;
    }
    
    NSInteger count = 0;
    if (!_allowRepeatedSelection) {
        count = _maxImageSelected - (_mediaArray.count - _selectedImageModels.count);
    }else {
        count = _maxImageSelected - _alreadyImageSelected;
    }
    
    TZImagePickerController *imagePickController = [[TZImagePickerController alloc] initWithMaxImagesCount:count delegate:self];
    //是否 在相册中显示拍照按钮
    imagePickController.allowTakePicture = NO;
    //是否 可以选择显示原图
    imagePickController.allowPickingOriginalPhoto = NO;
    //是否 在相册中可以选择视频
    imagePickController.allowPickingVideo = _allowPickingVideo;
    if (!_allowRepeatedSelection) {
        imagePickController.selectedAssets = _selectedImageAssets;
    }
    
    [ (_isAddPresentVC ? [self getTopController] : self.rootVC) presentViewController:imagePickController animated:YES completion:nil];
}

// 照相机
- (void)openCamera {
    
    if(_alreadyImageSelected >= _maxImageSelected){
        NSString * alert = [NSString stringWithFormat:@"你已添加%ld张图片,不能继续添加了", _alreadyImageSelected];
        [ZXHViewTool alertViewTitle:@"温馨提醒"
                            Tartget:self
                            Message:alert
                         ActionName:@"确认"
                        ActionStyle:UIAlertActionStyleDefault
                      ActionHandler:^(UIAlertAction *action) {
                          
                      }];
        return;
    }
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        [ (_isAddPresentVC ? [self getTopController] : self.rootVC) presentViewController:picker animated:YES completion:nil];
        
    }else{
        [ZXHViewTool alertViewTitle:@"温馨提醒"
                            Tartget:self
                            Message:@"该设备不支持拍照"
                         ActionName:@"确认"
                        ActionStyle:UIAlertActionStyleDefault
                      ActionHandler:^(UIAlertAction *action) {
                          
                      }];
    }
}

#pragma mark 增加图片／视频／增加文字

- (void)addMoreImage:(BOOL)isImage{
    
    if(isImage){
        
        NSInteger alreadyCount = _allTextOrImageContentArray.count;
        
        for (int i = 0; i < _mediaArray.count; i++) {
            
            LLImagePickerModel * model = _mediaArray[i];
            CLog(@"name == %@", model.name);
            
            EditContentModel *editModel = [[EditContentModel alloc] init];
            editModel.index = alreadyCount + i;
            
            editModel.imageName = model.name;
            UIImage *image = model.image;
            editModel.image = image;
            editModel.width = ZXHScreenWidth - 8 * 2;
            editModel.height = image.size.height * (ZXHScreenWidth - 8 * 2) / image.size.width;
            editModel.editContentType = EditContentTypeImage;
            [_allTextOrImageContentArray insertObject:editModel atIndex:_allTextOrImageContentArray.count];
        }
        
        _alreadyImageSelected = _alreadyImageSelected + _mediaArray.count;
        _singleGroupMediaArray = [NSMutableArray arrayWithArray:_mediaArray];
        [_mediaArray removeAllObjects];
        
        //开始处理上传图片
        [self uploadImageWithImageObjArray:_singleGroupMediaArray];
    }
    else{
        //增加文字
        EditContentModel *editModel = [[EditContentModel alloc] init];
        editModel.index = _allTextOrImageContentArray.count;
        editModel.text = @"增加文字介绍";
        editModel.width = ZXHScreenWidth - 8 * 2;
        editModel.height = 80;   //文字的默认高度
        editModel.editContentType = EditContentTypeText;
        
        [_allTextOrImageContentArray insertObject:editModel atIndex:_allTextOrImageContentArray.count];
    }
    
    [self.editFooterMenuView updateStatus:_allTextOrImageContentArray.count editing:self.tableView.editing];
    
    [self.tableView reloadData];
}

#pragma mark 上传图片／视频
//上传第一张图片
- (void)uploadImageWithImageObjArray:(NSMutableArray *)array{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _indexOfCurrentUpload = 0;
    LLImagePickerModel *model = array[0];
    [self uploadImage:model.image name:model.name];
}
- (void)uploadImage:(UIImage *)image name:name{
    
    CLog(@"name1 = %@", name);
    NSString * imageName = name;
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
        //http://diaoyudaxian01.b0.upaiyun.com/fish/201710/67050f78-8744-4e84-869b-677d1cc7b5cc
        
        //2、将图片地址放入专门的数组
        NSString * imageURLStr = [NSString stringWithFormat:@"%@", responseObject[@"data"]];
        [weakself.imageUrlStringArray addObject:imageURLStr];
        
        //上传成功后，同步地址到标准数据数组
        [weakself updateAllTextOrImageContentArrayWithImageUrl:imageURLStr imageName:imageName];
        
        [weakself checkIfUploadedSuccess:YES];
        
    } Failure:^(NSURLSessionDataTask *dataTask, CDHttpError *error) {
        
        CLog(@"上传图片失败： %@",error.error);
        [weakself checkIfUploadedSuccess:NO];
    }];
}

-(void)updateAllTextOrImageContentArrayWithImageUrl:(NSString *)imageURLStr imageName:(NSString *)imageName{
    
    for (EditContentModel *editModel in _allTextOrImageContentArray) {
        
        if (editModel.editContentType == EditContentTypeImage && [editModel.imageName isEqualToString:imageName]) {
            editModel.imageUrl = imageURLStr;
            CLog(@"同步数据： %@, %@",editModel.imageName, imageName);
        }
    }
}

static int count = 0;
- (void)checkIfUploadedSuccess:(BOOL)success{
    
    if(self.uploadingFinished){
        self.uploadingFinished(YES);
    }
    
    count = count + 1;
    
    //图片对象数组和图片地址数组一致时，表示图片已经全部上传完毕。
    if(self.imageUrlStringArray.count == _singleGroupMediaArray.count){
        
        self.imageAllUploaded = YES;
        
        count = 0;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        return;
    }
    //后台返回次数和图片对象数组一致时，表示图片上传有失败的情况。
    if(count == _singleGroupMediaArray.count){
        
        self.imageAllUploaded = NO;
        
        count = 0;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
}

#pragma mark - 相册：TZImagePickerController Delegate
//处理从相册单选或多选的照片
- (void)imagePickerController:(TZImagePickerController *)picker
       didFinishPickingPhotos:(NSArray<UIImage *> *)photos
                 sourceAssets:(NSArray *)assets
        isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    if ([_selectedImageAssets isEqualToArray: assets]) {
        return;
    }
    //每次回传的都是所有的asset 所以要初始化赋值
    if (!_allowRepeatedSelection) {
        _selectedImageAssets = [NSMutableArray arrayWithArray:assets];
    }
    NSMutableArray *models = [NSMutableArray array];
    //2次选取照片公共存在的图片
    NSMutableArray *temp = [NSMutableArray array];
    NSMutableArray *temp2 = [NSMutableArray array];
    for (NSInteger index = 0; index < assets.count; index++) {
        
        PHAsset *asset = assets[index];
        [[LLImagePickerManager manager] getMediaInfoFromAsset:asset completion:^(NSString *name, id pathData) {
            
            LLImagePickerModel *model = [[LLImagePickerModel alloc] init];
            model.name = name;
            model.uploadType = pathData;
            model.image = photos[index];
            
            //区分gif
            if ([NSString isGifWithImageData:pathData]) {
                model.image = [UIImage ll_setGifWithData:pathData];
            }
            
            if (!_allowRepeatedSelection) {
                //用数组是否包含来判断是不成功的。。。
                for (LLImagePickerModel *md in _selectedImageModels) {
                    if ([md.name isEqualToString:model.name]) {
                        [temp addObject:md];
                        [temp2 addObject:model];
                        break;
                    }
                }
            }
            [models addObject:model];
            
            if (index == assets.count - 1) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (!_allowRepeatedSelection) {
                        //删除公共存在的，剩下的就是已经不存在的
                        [_selectedImageModels removeObjectsInArray:temp];
                        //总媒体数组删先除掉不存在，这样不会影响排列的先后顺序
                        [_mediaArray removeObjectsInArray:_selectedImageModels];
                        //将这次选择的进行赋值，深复制
                        _selectedImageModels = [models mutableCopy];
                        //这次选择的删除公共存在的，剩下的就是新添加的
                        [models removeObjectsInArray:temp2];
                        //总媒体数组中在后面添加新数据
                        [_mediaArray addObjectsFromArray:models];
                    }else {
                        [_selectedImageModels addObjectsFromArray:models];
                        [_mediaArray addObjectsFromArray:models];
                    }
                    
                    [self addMoreImage:YES];
                });
            }
        }];
    }
}

#pragma mark - 拍照：UIImagePickerController Delegate
///拍照、选视频图片、录像 后的回调（这种方式选择视频时，会自动压缩，但是很耗时间）
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //原图URL
    NSURL *imageAssetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    ///视频 和 录像
    if ([mediaType isEqualToString:@"public.movie"]) {
        
        NSURL *videoAssetURL = [info objectForKey:UIImagePickerControllerMediaURL];
        PHAsset *asset;
        //录像没有原图 所以 imageAssetURL 为nil
        if (imageAssetURL) {
            PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageAssetURL] options:nil];
            asset = [result firstObject];
        }
        
        ZXH_WEAK_SELF
        [[LLImagePickerManager manager] getVideoPathFromURL:videoAssetURL PHAsset:asset enableSave:NO completion:^(NSString *name, UIImage *screenshot, id pathData) {
            LLImagePickerModel *model = [[LLImagePickerModel alloc] init];
            model.image = screenshot;
            model.name = name;
            model.uploadType = pathData;
            model.isVideo = YES;
            model.mediaURL = videoAssetURL;
            
            [weakself.mediaArray addObject:model];
            [weakself addMoreImage:YES];
        }];
    }
    
    else if ([mediaType isEqualToString:@"public.image"]) {
        
        UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
        //如果 picker 没有设置可编辑，那么image 为 nil
        if (image == nil) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        PHAsset *asset;
        //拍照没有原图 所以 imageAssetURL 为nil
        if (imageAssetURL) {
            PHFetchResult *result = [PHAsset fetchAssetsWithALAssetURLs:@[imageAssetURL] options:nil];
            asset = [result firstObject];
        }
        
        ZXH_WEAK_SELF
        [[LLImagePickerManager manager] getImageInfoFromImage:image PHAsset:asset completion:^(NSString *name, NSData *data) {
            LLImagePickerModel *model = [[LLImagePickerModel alloc] init];
            model.image = image;
            model.name = name;
            model.uploadType = data;
            
            [weakself.mediaArray addObject:model];
            [weakself addMoreImage:YES];
        }];
    }
}





#pragma mark 滚动 UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    CLog(@"scrollViewWillBeginDragging");
    [self closeKeyboard];
}

#pragma mark 列表 UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditContentModel *editModel = [_allTextOrImageContentArray objectAtIndex:indexPath.row];
    
    return editModel.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_allTextOrImageContentArray.count == 0) {
        
        [self.tableView setEditing:NO animated:YES];
    }
    
    [self.editFooterMenuView updateStatus:_allTextOrImageContentArray.count editing:self.tableView.editing];
    
    return _allTextOrImageContentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"EditContentTableViewCell";
    EditContentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EditContentTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.showsReorderControl = YES;
    
    EditContentModel *tempEditModel = [_allTextOrImageContentArray objectAtIndex:indexPath.row];
    cell.editModel = tempEditModel;
    [cell reloadData];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle ==UITableViewCellEditingStyleDelete){
        
      [_allTextOrImageContentArray removeObjectAtIndex:indexPath.row];         //删除数组里的数据
        
        [self.tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];    //删除对应数据的cell
        [self.tableView endUpdates];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleNone | UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    NSUInteger fromRow = [fromIndexPath row];  //要移动的那个cell integer
    NSUInteger toRow = [toIndexPath row];      //要移动位置的那个clell integer
    
    //调整添加数据的那个可变数组
    id object = [_allTextOrImageContentArray objectAtIndex:fromRow];   // 获取数据
    [_allTextOrImageContentArray removeObjectAtIndex:fromRow];         //在当前位置删除
    [_allTextOrImageContentArray insertObject:object atIndex:toRow];   //插入的位置
}

@end
