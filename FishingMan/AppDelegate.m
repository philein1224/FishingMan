//
//  AppDelegate.m
//  FishingMan
//
//  Created by zhangxh on 2017/1/5.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "AppDelegate.h"

#import <MobAPI/MobAPI.h>
#define shareSDK_mobAPIAppKey    @"1c857b746b247"
#define shareSDK_mobAPIAppSecret @"f2110ca2e72583cfae5e16fd7372914d"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#define shareSDK_AppKey          @"1d43eaa743d8f"
#define shareSDK_AppSecret       @"d997535b76ecc41643ddfe78ef8ff130"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //获取mobAPI【天气】
    [MobAPI registerApp:shareSDK_mobAPIAppKey];
    
    //初始化分享
    [self initShareSDK];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark 初始化第三方平台数据

//新浪微博
#define   CD_SinaWeibo_AppKey        @"3141723789"
#define   CD_SinaWeibo_Secret        @"5580607250db935013abe3341dc9ac6d"
#define   CD_SinaWeibo_RedirectUri   @"http://weibo.com/u/1227739807"

- (void)initShareSDK{
    
    [ShareSDK registerApp:shareSDK_AppKey
     
     //支持的平台
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
     //支持的平台
                 onImport:^(SSDKPlatformType platformType)
    {
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            case SSDKPlatformTypeSinaWeibo:
                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                break;
            default:
                break;
        }
    }
     
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
    {
              switch (platformType)
              {
                  case SSDKPlatformTypeSinaWeibo:
                      //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                      [appInfo SSDKSetupSinaWeiboByAppKey:CD_SinaWeibo_AppKey
                                                appSecret:CD_SinaWeibo_Secret
                                              redirectUri:CD_SinaWeibo_RedirectUri
                                                 authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:@"wx6469ae5dc3611ff2"
                                            appSecret:@"1b608b82798c8abeece7602c516fb066"];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:@"1106087733"
                                           appKey:@"CsSLm4QPEZdt5afK"
                                         authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
    }];
}

#pragma mark 全局关闭
- (void)hideKeyBoard{
    for (UIWindow * window in [UIApplication sharedApplication].windows) {
        for (UIView * view in window.subviews) {
            [self dismissAllKeyBoardInView:view];
        }
    }
}
- (BOOL)dismissAllKeyBoardInView:(UIView *)view {
    if([view isFirstResponder]) {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews) {
        if([self dismissAllKeyBoardInView:subView]) {
            return YES;
        }
        CLog(@"关闭键盘循环");
    }
    return NO;
}

@end
