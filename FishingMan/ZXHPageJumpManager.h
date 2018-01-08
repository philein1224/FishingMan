//
//  ZXHPageJumpManager.h
//  FishingMan
//
//  Created by zhangxh on 2017/4/22.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
 
    ZXHPageJumpType_NOTFORWARD = 0,      //不处理
    ZXHPageJumpType_USERPAGE,            //用户对外主页
    ZXHPageJumpType_URL,                //网页
    ZXHPageJumpType_REGISTER,            //注册登录页
    
}ZXHPageJumpType;

@interface ZXHPageJumpManager : NSObject

@end
