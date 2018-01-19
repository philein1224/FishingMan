//
//  FMVersionUpdate.m
//  FishingMan
//
//  Created by zhangxh on 2017/3/15.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMVersionUpdate.h"
#import "UIImageView+WebCache.h"
#import "FMShareCollectionCell.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#define kRowHeight  72.00 * ZXHRatioWithReal375

@interface FMVersionUpdate (){
    
    NSMutableArray *shareTypeArray;
}
@property (weak, nonatomic) IBOutlet UIImageView *alphaBGImageView;
@property (weak, nonatomic) IBOutlet UIView *alphaBGView;
@property (weak, nonatomic) IBOutlet UIImageView *shareAdImgView;
@property (weak, nonatomic) IBOutlet UIView *advertiseFlag;   //广告标签
@end

@implementation FMVersionUpdate

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    /*** 点击空白区域关闭视图 ***/
//    UITapGestureRecognizer *tap0Recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
//    [self.alphaBGView addGestureRecognizer:tap0Recognizer];
    
    /*** 广告图片 ***/
    [self.shareAdImgView sd_setImageWithURL:nil placeholderImage:ZXHImageName(@"shareAd.jpg")];
    
    /*** 广告标签 ***/
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.advertiseFlag.bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _advertiseFlag.bounds;
    maskLayer.path = maskPath.CGPath;
    _advertiseFlag.layer.mask = maskLayer;
    
    /*** 背景高斯模糊 ***/
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = [[UIApplication sharedApplication] keyWindow].bounds;
    [_alphaBGImageView addSubview:effectView];
}
//下次再说
- (IBAction)nextTimeToUpdate:(id)sender {
    
    [self closeView];
}
//立即更新
- (IBAction)appUpdateAction:(id)sender {
    
    NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/partynow/id%@?mt=8", APP_BUNDLE_IDENTITY];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    [self closeView];
}

- (IBAction)closeButtonAction:(id)sender {
    
    [self closeView];
}

/**
 *  @author zxh, 17-03-16 16:03:59
 *
 *  关闭退出分享页面
 */
- (void)closeView{
    
    [UIView animateWithDuration:0.5 animations:^(){
        self.alpha = 0.0;
    }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                     }];
}

@end
