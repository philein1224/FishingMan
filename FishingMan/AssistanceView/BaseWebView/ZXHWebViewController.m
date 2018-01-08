//
//  ZXHWebViewController.m
//  FishingMan
//
//  Created by zhangxh on 2017/5/3.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "ZXHWebViewController.h"
#import "FMShareView.h"

@interface ZXHWebViewController ()<UIWebViewDelegate>
{
    UIView * bgView;
    UIImageView * imgView;
    
    BOOL didFinishLoad;
}
@property (weak, nonatomic) IBOutlet UILabel  *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareOrRefreshButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

//网页加载进度（假的）
@property (strong, nonatomic) UIProgressView * myProgressView;
@property (strong, nonatomic) NSTimer        * myTimer;
@property (weak, nonatomic) IBOutlet UIView  * topNaviBar;

@end

@implementation ZXHWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
    CGFloat progressBarHeight = 1.0f;
    CGRect navigationBarBounds = self.topNaviBar.bounds;
    CGRect barFrame = CGRectMake(0,
                                 navigationBarBounds.size.height - progressBarHeight,
                                 ZXHScreenWidth,
                                 progressBarHeight);
    
    self.myProgressView = [[UIProgressView alloc] initWithFrame:barFrame];
    self.myProgressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.myProgressView.progressTintColor = [UIColor colorWithRed:43.0/255.0 green:186.0/255.0  blue:0.0/255.0  alpha:1.0];
    self.myProgressView.trackTintColor = [UIColor clearColor];
    
    [self.topNaviBar addSubview:self.myProgressView];
    
    //左右三个按钮的图标
    [_backButton setImage:ZXHImageName(@"navBackGray") forState:UIControlStateNormal];
    [_backButton setImage:ZXHImageName(@"navBackGray") forState:UIControlStateHighlighted];
    
    _closeButton.hidden = YES;
    [_closeButton setImage:ZXHImageName(@"commonWeb_close") forState:UIControlStateNormal];
    [_closeButton setImage:ZXHImageName(@"commonWeb_close") forState:UIControlStateHighlighted];
    
    [_shareOrRefreshButton setImage:ZXHImageName(@"MainPage_分享") forState:UIControlStateNormal];
    [_shareOrRefreshButton setImage:ZXHImageName(@"MainPage_分享") forState:UIControlStateHighlighted];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // 移除 progress view
    // because UINavigationBar is shared with other ViewControllers
    [self.myProgressView removeFromSuperview];
    [self.myTimer invalidate];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    self.myProgressView.progress = 0;
    didFinishLoad = false;
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                    target:self
                                                  selector:@selector(timerCallback)
                                                  userInfo:nil
                                                   repeats:YES];
    
    [self reloadData];
}
- (void)timerCallback {
    
    [UIView animateWithDuration:0.1 animations:^{
        
        if (didFinishLoad) {
            if (self.myProgressView.progress >= 1) {
                self.myProgressView.hidden = true;
                [self.myTimer invalidate];
            }
            else {
                self.myProgressView.progress += 0.05;
            }
        }
        else {
            self.myProgressView.progress += 0.02;
            if (self.myProgressView.progress >= 0.90) {
                self.myProgressView.progress = 0.90;
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)reloadData{

    NSString *url = [ZXHTool URLEncodingWithString:self.urlString];
    
    [self.webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]]];
    
    CLog(@"url == %@", url);
}

- (IBAction)backButtonAction:(id)sender {
    
    if(self.webView.canGoBack){
        
        [self.webView goBack];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closeButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ShareOrRefreshButton:(id)sender {
    
    FMShareView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"FMShareView" owner:self options:nil] firstObject];
    [shareView setFrame:self.view.bounds];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:shareView];
}

//关闭按钮
-(void)removeBigImage
{
    bgView.hidden = YES;
}

- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
{
    //缩放:设置缩放比例
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}
- (void)showBigImage:(NSString *)imageUrl{
    //创建灰色透明背景，使其背后内容不可操作
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZXHScreenWidth, ZXHScreenHeight)];
    [bgView setBackgroundColor:[UIColor colorWithRed:0.3
                                               green:0.3
                                                blue:0.3
                                               alpha:0.7]];
    [self.view addSubview:bgView];
    
    //创建边框视图
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ZXHScreenWidth-20, 240)];
    //将图层的边框设置为圆脚
    borderView.layer.cornerRadius = 8;
    borderView.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    borderView.layer.borderWidth = 8;
    borderView.layer.borderColor = [[UIColor colorWithRed:0.9
                                                    green:0.9
                                                     blue:0.9
                                                    alpha:0.7] CGColor];
    [borderView setCenter:bgView.center];
    [bgView addSubview:borderView];
    
    //创建关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    closeBtn.backgroundColor = [UIColor redColor];
    [closeBtn addTarget:self action:@selector(removeBigImage) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setFrame:CGRectMake(borderView.frame.origin.x+borderView.frame.size.width-20, borderView.frame.origin.y-6, 26, 27)];
    [bgView addSubview:closeBtn];
    
    //创建显示图像视图
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(borderView.frame)-20, CGRectGetHeight(borderView.frame)-20)];
    imgView.userInteractionEnabled = YES;
    [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
               placeholderImage:ZXHImageName(@"temp.png")];
    [borderView addSubview:imgView];
    
    //添加捏合手势
    [imgView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)]];
    
}

#pragma mark  UIWebView Delegate ---------------------

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    CLog(@"CDBaseWebView shouldStartLoad URL:\n%@\n %ld\n",request.URL.absoluteString, navigationType);
    
//    //将url转换为string
//    NSString *requestString = [[request URL] absoluteString];
//    NSLog(@"requestString is %@", requestString);
//    
//    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
//    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
//        
//        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
//        NSLog(@"image url------%@", imageUrl);
//        
//        if (bgView) {
//            //设置不隐藏，还原放大缩小，显示图片
//            bgView.hidden = NO;
//            imgView.frame = CGRectMake(10, 10, ZXHScreenWidth-40, 220);
//            [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
//                       placeholderImage:ZXHImageName(@"temp.png")];
//        }
//        else
//            [self showBigImage:imageUrl];//创建视图并显示图片
//        
//        return NO;
//    }
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if ([self.webView canGoBack]) {
        
        self.closeButton.hidden = NO;
    }else {
        
        self.closeButton.hidden = YES;
    }
    
    didFinishLoad = true;
    
    
    //调整字号
    NSString *str = @"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '95%'";
    [webView stringByEvaluatingJavaScriptFromString:str];
    
    //js方法遍历图片添加点击事件 返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return objs.length;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    
    //注入自定义的js方法后别忘了调用 否则不会生效（不调用也一样生效了，，，不明白）
    NSString *resurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    CLog(@"resurlt = %@", resurlt);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    CLog(@"%ld \n %@ \n  %@ \n %@ \n", error.code, error.userInfo, error.localizedDescription, error.localizedFailureReason);
}

@end
