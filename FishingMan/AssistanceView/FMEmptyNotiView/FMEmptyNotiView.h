//
//  FMEmptyNotiView.h
//  FishingMan
//
//  Created by zxh on 2017/6/20.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

///PayView展示类型
typedef NS_ENUM(NSInteger, EmptyShowType) {
    
    EmptyXiangMuShowType = 0,           //无项目
    EmptyDingDanShowType = 1,           //无订单
    EmptyKaQuanShowType = 2,            //无卡券
    EmptyDataShowType = 3,              //无数据（客户列表）
};

@interface FMEmptyNotiView : UIView

+ (FMEmptyNotiView *)initEmptyListView:(EmptyShowType)emptyShowType withFrame:(CGRect)frame;

@end
