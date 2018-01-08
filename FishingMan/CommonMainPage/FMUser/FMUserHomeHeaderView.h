//
//  FMUserHomeHeaderView.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/23.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FMUserHomeActionType){
    
    FMUserHomeActionNormal = 0,       //还未做任何行为
    FMUserHomePreviewAvatar = 1,      //预览头像（好友的个人中心）
    FMUserHomeSettingAvatar = 2,      //设置头像（用户自己的个人中心->设置个人资料页面）
    FMUserHomeFollows = 3,            //关注
    FMUserHomeFans = 4                //粉丝
};

typedef NS_ENUM(NSInteger, FMUserType){
    FMUserTypeAdmin = 0,
    FMUserTypeFriend = 1,
};

@interface FMUserHomeHeaderView : UIView

@property (assign, nonatomic) FMUserHomeActionType avatarTapActionType;

@property (copy, nonatomic) void(^ callBack_userHomeActionType)(FMUserHomeActionType userHeaderActionType);

-(void)reloadData:(id)data userType:(FMUserType)userType;
@end
