//
//  MacroDefine.h
//  ZXHTools
//
//  Created by zhangxh on 2016/11/16.
//  Copyright © 2016年 HongFan. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef MacroDefine_h
#define MacroDefine_h

#pragma mark --- 颜色 ---

#define   ZXHColorRGB(r,g,b,a)      [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]
//#define   ZXHColorHEX(c,a)          ZXHColorRGB((float)((c&0xFF0000)>>16),(float)((c&0xFF00)>>8),(float)(c&0xFF),a)
#define   ZXHColorHEX(colorStr, a)  [ZXHTool colorWithHexString:colorStr withAlpha:a]

#pragma mark --- 长度单位 ---
#define   ZXHScreenBounds          [UIScreen mainScreen].bounds
#define   ZXHScreenWidth           [[UIScreen mainScreen] bounds].size.width
#define   ZXHScreenHeight          [[UIScreen mainScreen] bounds].size.height

#pragma mark --- iPhoneX ---
#define   CDIsIphoneX                       ([[UIScreen mainScreen] bounds].size.height == 812.0 ? YES : NO)
#define   CDSafeAreaNavBarHeight            ([[UIScreen mainScreen] bounds].size.height == 812.0 ? 88 : 64)
#define   CDSafeAreaToTopHeight             ([[UIScreen mainScreen] bounds].size.height == 812.0 ? 24 : 0)
#define   CDSafeAreaToBottomHeight          ([[UIScreen mainScreen] bounds].size.height == 812.0 ? 34 : 0)

//根据375计算比例
#define   ZXHRatioWithReal375      (ZXHScreenWidth/375.0)
//宽度增长系数(==1.0, 1.0><1.2, >1.2)
#define   Ratio_OF_WIDTH_FOR_IPHONE       (ZXHScreenWidth/320.0)
//是否为iPhone4的屏幕
#define   ZXHIsIphone4             ZXHScreenHeight == 480 ? YES : NO
#define   ZXHIsIphone45            Ratio_OF_WIDTH_FOR_IPHONE == 1.0 ? YES : NO
#define   ZXHIsIphone6             Ratio_OF_WIDTH_FOR_IPHONE > 1.0 && Ratio_OF_WIDTH_FOR_IPHONE < 1.2 ? YES : NO
#define   ZXHIsIphone6Plus         Ratio_OF_WIDTH_FOR_IPHONE > 1.2 ? YES : NO



#pragma mark --- 图片 ---
#define   ZXHImageName(name)       [UIImage imageNamed:name]


#ifdef DEBUG
#define   CLog(format, ...)        printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define   CLog(format, ...)
#endif


#define   ZXH_WEAK_SELF           __weak __typeof(self) weakself = self;


#define APP_BUNDLE_IDENTITY        @"1171339177"


//文章类型的名称
#define   ALL_ARTICLE_TYPE_NAME_ARRAY     [[NSMutableArray alloc] initWithObjects:@"钓获展示",@"技巧问答",@"钓具DIY",@"钓具测评",@"饵料配方",@"路亚",@"钓友美食",@"随便侃侃",nil];

/**
文章类型【含：查询文章的列表类型】
@"钓获展示",@"技巧问答",@"钓具DIY",@"钓具测评",@"饵料配方",@"路亚",@"钓友美食",@"随便侃侃"
 **/
typedef NS_OPTIONS(NSInteger, FMArticleType) {
    
    //基本文章类型
    FMArticleTypeHarvest          = 0,    //钓获展示
    FMArticleTypeQA               = 1,    //技巧问答
    FMArticleTypeDIY              = 2,    //钓具DIY
    FMArticleTypeTest             = 3,    //钓具测评
    FMArticleTypeBait             = 4,    //饵料配方
    FMArticleTypeLure             = 5,    //路亚
    FMArticleTypeDeliciousFood    = 6,    //钓友美食
    FMArticleTypeChatCasually     = 7,    //随便侃侃
};

/**
 公共资源模块类型【文章1\钓点2\渔具店3】
 **/
typedef NS_OPTIONS(NSInteger, FMSourceType) {
    
    FMSourceArticleType          = 1,    //文章类型
    FMSourceFishSiteType         = 2,    //钓点类型
    FMSourceFishStoreType        = 3,    //渔具店类型
};

/**
 公共资源模块举报类型【文章、钓点、渔具店通用】
 **/
typedef NS_OPTIONS(NSInteger, FMReportType) {
    FMReportPolitics          = 1,    //政治
    FMReportReligion          = 2,    //宗教
    FMReportHorror            = 3,    //恐怖极端
    FMReportViolence          = 4,    //暴力
    FMReportPornographic      = 5,    //色情
    FMReportOther             = 6,    //其他举报
    //以上主要用于文章内容举报
    
    FMFeedbackLocationError     = 11,   //位置错误
    FMFeedbackInfoError         = 12,   //钓点、商店信息错误
    FMFeedbackInfoRepeated      = 13,   //钓点、商店重复
    FMFeedbackClosed            = 14,   //钓点、商店已经关闭
    FMFeedbackOther             = 15,   //其他信息
    //以上主要用于钓点和渔具店信息的反馈
    
};


#endif
