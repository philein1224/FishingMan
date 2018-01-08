//
//  FMPictureChooseMenu.h
//  FishingMan
//
//  Created by zxh on 2017/6/20.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ChooseMenuType) {
    ChooseMenuTypeCancel = 0,
    ChooseMenuTypeCamera = 1,
    ChooseMenuTypePhoto = 2,
};

typedef void (^PictureChooseMenuCallback) (ChooseMenuType chooseType);

@interface FMPictureChooseMenu : UIView

@property (copy, nonatomic) PictureChooseMenuCallback callback;

+ (instancetype)shareWithTarget:(id)target callback:(PictureChooseMenuCallback) callback;
- (void)show;
- (void)dismiss;

@end
