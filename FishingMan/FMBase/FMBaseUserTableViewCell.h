//
//  FMBaseUserTableViewCell.h
//  FishingMan
//
//  Created by zhangxh on 2017/5/25.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FMFriendType){
    
    FMFriendTypeNormal = 0,       //还未做任何行为
    FMFriendTypeFollows = 1,      //关注
    FMFriendTypeFans = 2          //粉丝
};


@interface FMBaseUserTableViewCell : UITableViewCell

@property (assign, nonatomic) FMFriendType friendType;

@property (copy, nonatomic) void (^callback_UserTBCell)(BOOL isFollowedByMe); //是否被我关注

@end
