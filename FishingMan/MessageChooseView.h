//
//  MessageChooseView.h
//  ZiMaCaiHang
//
//  Created by zhangxh on 2017/3/22.
//  Copyright © 2017年 fightper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageChooseView : UIView
@property (copy, nonatomic) void(^showSingleTypeMessage)(NSString * type, NSString *typeName);
@end
