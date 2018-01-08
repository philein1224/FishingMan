//
//  FMMultiChooseMenu.h
//  FishingMan
//
//  Created by zxh on 2017/6/20.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FMMultiChooseMenuCallback) (NSArray * array);

@interface FMMultiChooseMenu : UIView

@property (copy, nonatomic) FMMultiChooseMenuCallback callback;

+ (instancetype)shareWithTarget:(id)target
                          array:(NSArray *)array
                       callback:(FMMultiChooseMenuCallback) callback;
- (void)show;
- (void)dismiss;

@end
