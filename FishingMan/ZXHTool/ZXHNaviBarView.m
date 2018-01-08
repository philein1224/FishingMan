//
//  ZXHNaviBarView.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/28.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "ZXHNaviBarView.h"

@interface ZXHNaviBarView ()

@property (weak, nonatomic) IBOutlet UIView      *bgAlphaView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIButton    *leftButton;
@property (weak, nonatomic) IBOutlet UIButton    *rightButton;
@property (weak, nonatomic) IBOutlet UILabel     *titleLabel;

@property (assign, nonatomic) double navOffsetY;

@property (assign, nonatomic) ZXHNaviBarViewStyle naviBarViewStyle;
@property (strong, nonatomic) UIColor            *naviBarViewColor;

@end

@implementation ZXHNaviBarView

- (void)initialViewStyle:(ZXHNaviBarViewStyle)viewStyle
                   color:(UIColor *)color
                   title:(NSString *)title
                 tartget:(id)target
     leftButtonImageName:(NSString *)LImageName
    rightButtonImageName:(NSString *)RImageName
              leftAction:(SEL)leftAction
             rightAction:(SEL)rightAction{
    
    //外部的xib视图必须放在本地的一个空UIView中，不然高度不对
    CGRect tframe = CGRectMake(0, 0, ZXHScreenWidth, 64);
    UIView *tempView = [[UIView alloc] init];
    tempView.frame = tframe;
    tempView.clipsToBounds = YES;
    self.frame = tempView.bounds;
    [tempView addSubview:self];
    [((UIViewController *)target).view addSubview:tempView];
    
    if (![ZXHTool isEmptyString:title]){
        _titleLabel.text = title;
    }
    
    _naviBarViewStyle = viewStyle;
    _naviBarViewColor = color;
    
    if(viewStyle == ZXHNaviBarStyleColorStatic ||
       viewStyle == ZXHNaviBarStyleColorChange){
        
        _bgAlphaView.backgroundColor = color;
    }
    if(viewStyle == ZXHNaviBarStyleBlurStatic ||
       viewStyle == ZXHNaviBarStyleBlurChange){
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = self.bounds;
        [_bgImageView addSubview:effectView];
        
        _bgImageView.alpha = 1.0;
    }
    
    _leftButton.hidden = YES;
    _rightButton.hidden = YES;
    
    if (leftAction) {
        _leftButton.hidden = NO;
        [_leftButton addTarget:target action:leftAction forControlEvents:UIControlEventTouchUpInside];
        
        //UIImage *image = [UIImage imageNamed:@"navBackGray"];
        if (![ZXHTool isEmptyString:LImageName]) {
            UIImage *image = [UIImage imageNamed:LImageName];
            _leftButton.exclusiveTouch = YES;
            [_leftButton setImage:image forState:UIControlStateNormal];
            [_leftButton setImage:image forState:UIControlStateHighlighted];
        }
    }
    if (rightAction) {
        _rightButton.hidden = NO;
        [_leftButton addTarget:target action:rightAction forControlEvents:UIControlEventTouchUpInside];
        
        if (![ZXHTool isEmptyString:LImageName]) {
            UIImage *image = [UIImage imageNamed:RImageName];
            _leftButton.exclusiveTouch = YES;
            [_leftButton setImage:image forState:UIControlStateNormal];
            [_leftButton setImage:image forState:UIControlStateHighlighted];
        }
    }
}

- (void)initialViewStyle:(ZXHNaviBarViewStyle)viewStyle
               WithColor:(UIColor *)color
             withTartget:(id)target
              LeftAction:(SEL)leftAction
             RightAction:(SEL)rightAction{
    
    //外部的xib视图必须放在本地的一个空UIView中，不然高度不对
    CGRect tframe = CGRectMake(0, 0, ZXHScreenWidth, 64);
    UIView *tempView = [[UIView alloc] init];
    tempView.frame = tframe;
    tempView.clipsToBounds = YES;
    self.frame = tempView.bounds;
    [tempView addSubview:self];
    [((UIViewController *)target).view addSubview:tempView];
    
    _naviBarViewStyle = viewStyle;
    _naviBarViewColor = color;
    
    if(viewStyle == ZXHNaviBarStyleColorStatic ||
       viewStyle == ZXHNaviBarStyleColorChange){
        
        _bgAlphaView.backgroundColor = color;
    }
    if(viewStyle == ZXHNaviBarStyleBlurStatic ||
       viewStyle == ZXHNaviBarStyleBlurChange){
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = self.bounds;
        [_bgImageView addSubview:effectView];
        
        _bgImageView.alpha = 1.0;
    }
    
    _leftButton.hidden = YES;
    _rightButton.hidden = YES;
    
    if (leftAction) {
        _leftButton.hidden = NO;
        [_leftButton addTarget:target action:leftAction forControlEvents:UIControlEventTouchUpInside];
        
//        UIImage *image = [UIImage imageNamed:@"navBackGray"];
        UIImage *image = [UIImage imageNamed:@"navBackWhite"];
        _leftButton.exclusiveTouch = YES;
        [_leftButton setImage:image forState:UIControlStateNormal];
        [_leftButton setImage:image forState:UIControlStateHighlighted];
    }
    if (rightAction) {
        _rightButton.hidden = NO;
        [_leftButton addTarget:target action:rightAction forControlEvents:UIControlEventTouchUpInside];
    }
}

//透明度变化
- (void)updateWithScrollViewContentOffsetY:(float)offsetY
{
    if(_naviBarViewStyle == ZXHNaviBarStyleColorStatic ||
       _naviBarViewStyle == ZXHNaviBarStyleBlurStatic){
        
    }
    else if(_naviBarViewStyle == ZXHNaviBarStyleColorChange ||
            _naviBarViewStyle == ZXHNaviBarStyleBlurChange){
        
        if(offsetY == 10000){
            self.bgAlphaView.alpha = _navOffsetY/64;
        }
        else
        {
            if(offsetY <= 64){
                _navOffsetY = offsetY;
                self.bgAlphaView.alpha = offsetY / 64;
            }
            else{
                _navOffsetY = offsetY;
                self.bgAlphaView.alpha = 1;
            }
        }
    }
}

@end
