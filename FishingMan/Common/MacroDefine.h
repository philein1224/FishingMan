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
#define   CLog(format, ...)        NSLog(format, ## __VA_ARGS__)
#else
#define   CLog(format, ...)
#endif


#define   ZXH_WEAK_SELF           __weak __typeof(self) weakself = self;

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

#endif
