//
//  FMPictureChooseMenu.m
//  FishingMan
//
//  Created by zxh on 2017/6/20.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMPictureChooseMenu.h"

#define ZXHScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ZXHScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define ContentYOffset  143

@interface FMPictureChooseMenu ()

@property (weak, nonatomic) IBOutlet UIView *alphaBGView;
@property (weak, nonatomic) IBOutlet UIView *activeContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *activeContainerHeight;

@end

@implementation FMPictureChooseMenu

- (void)dealloc{
    
    CLog(@"---[%@ dealloc]---",NSStringFromClass(self.class));
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self.alphaBGView addGestureRecognizer:tap];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self.alphaBGView addGestureRecognizer:pan];
}

+ (instancetype)shareWithTarget:(id)target callback:(PictureChooseMenuCallback) callback{
    
    FMPictureChooseMenu *chooseMenu = [[[NSBundle mainBundle] loadNibNamed:@"FMPictureChooseMenu" owner:self options:nil] firstObject];
    
    chooseMenu.callback = callback;
    
    chooseMenu.alphaBGView.alpha = 0.0;
    chooseMenu.activeContainerView.frame = CGRectMake(0,
                                                      ZXHScreenHeight,
                                                      ZXHScreenWidth,
                                                      ContentYOffset);
    chooseMenu.frame = CGRectMake(0,
                                  0,
                                  ZXHScreenWidth,
                                  ZXHScreenHeight);
    
    /*** 背景高斯模糊 ***/
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = [[UIApplication sharedApplication] keyWindow].bounds;
//    [commentView.bgImageView addSubview:effectView];
    
    return chooseMenu;
}

- (void)show{
   
//    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.frame = CGRectMake(0, 0, ZXHScreenWidth, ZXHScreenHeight);
    self.alphaBGView.alpha = 0.0;
    
    self.activeContainerView.frame = CGRectMake(0,
                                                ZXHScreenHeight,
                                                ZXHScreenWidth,
                                                ContentYOffset);
    
    [UIView animateWithDuration:0.5 animations:^{
    
        self.activeContainerView.frame = CGRectMake(0,
                                                    ZXHScreenHeight - ContentYOffset,
                                                    ZXHScreenWidth,
                                                    ContentYOffset);
        
        self.alphaBGView.alpha = 0.4;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss{
    
    self.alphaBGView.alpha = 0.4;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.activeContainerView.frame = CGRectMake(0,
                                                    ZXHScreenHeight,
                                                    ZXHScreenWidth,
                                                    ContentYOffset);
        
        self.alphaBGView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (IBAction)chooseButtonAction:(UIButton*)button{
    
    ChooseMenuType chooseType;
    switch (button.tag) {
        case 1:
        {
            chooseType = ChooseMenuTypeCamera;
        }
            break;
        case 2:
        {
            chooseType = ChooseMenuTypePhoto;
        }
            break;
        case 0:
        default:
        {
            chooseType = ChooseMenuTypeCancel;
        }
            break;
    }
    if(self.callback){
        self.callback(chooseType);
    }
    
    [self dismiss];
}



@end
