//
//  CDTopAlertView.m
//  ZiMaCaiHang
//
//  Created by fightper on 16/6/21.
//  Copyright © 2016年 fightper. All rights reserved.
//

#import "CDTopAlertView.h"
#import "ZXHViewTool.h"
#import "CDAnimations.h"

#define   CD_TopAlertViewYellowColor ZXHColorHEX(@"B42038", 1)
#define   CD_TopAlertViewGreenColor  ZXHColorHEX(@"3CBB76", 1)
#define   CD_TopAlertViewRedColor    ZXHColorHEX(@"B42038", 1)

@interface CDTopAlertView ()

@property (weak, nonatomic) IBOutlet UIView *alertBgView;
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;


@end

@implementation CDTopAlertView

+ (CDTopAlertView *)showMsg:(NSString *)message bgColor:(UIColor *)color {

    CDTopAlertView *topAlertView = [[[NSBundle mainBundle] loadNibNamed:@"CDTopAlertView" owner:nil options:nil] firstObject];
    
    topAlertView.frame = CGRectMake(0, 0, ZXHScreenWidth, 64);
    [[UIApplication sharedApplication].keyWindow addSubview:topAlertView];
    [topAlertView show:message bgColor:color];
    
    return topAlertView;
}

+ (CDTopAlertView *)showMsg:(NSString *)message bgColor:(UIColor *)color andImage:(UIImage *)img{
    
    CDTopAlertView *topAlertView = (CDTopAlertView *)[ZXHViewTool customViewWithXIBName:@"CDTopAlertView" owner:nil];
    topAlertView.frame = CGRectMake(0, 0, ZXHScreenWidth, 64);
    [[UIApplication sharedApplication].keyWindow addSubview:topAlertView];
    [topAlertView show:message bgColor:color];
    
    [topAlertView.tipImageView setImage:img];
    
    return topAlertView;
}

+ (CDTopAlertView *)showMsg:(NSString *)message isErrorState:(BOOL)isError{
    
    CDTopAlertView *topAlertView = (CDTopAlertView *)[ZXHViewTool customViewWithXIBName:@"CDTopAlertView" owner:nil];
    topAlertView.frame = CGRectMake(0, 0, ZXHScreenWidth, 64);
    [[UIApplication sharedApplication].keyWindow addSubview:topAlertView];
    
    if (isError) {
        
        [topAlertView show:message bgColor:CD_TopAlertViewRedColor];
        
        [topAlertView.tipImageView setImage:ZXHImageName(@"顶部错误提示")];
    }
    else{
        
        [topAlertView show:message bgColor:CD_TopAlertViewGreenColor];
        
        [topAlertView.tipImageView setImage:ZXHImageName(@"顶部正确提示")];
    }
    
    return topAlertView;
}

+ (CDTopAlertView *)showMsg:(NSString *)message isErrorState:(BOOL)isError inView:(UIView *)view{
    CDTopAlertView *topAlertView = (CDTopAlertView *)[ZXHViewTool customViewWithXIBName:@"CDTopAlertView" owner:nil];
    topAlertView.frame = CGRectMake(0, 0, ZXHScreenWidth, 64);
    [view addSubview:topAlertView];
    
    if (isError) {
        
        [topAlertView show:message bgColor:CD_TopAlertViewRedColor];
        
        [topAlertView.tipImageView setImage:ZXHImageName(@"顶部错误提示")];
    }
    else{
        
        [topAlertView show:message bgColor:CD_TopAlertViewGreenColor];
        
        [topAlertView.tipImageView setImage:ZXHImageName(@"顶部正确提示")];
    }
    
    return topAlertView;
}

+ (CDTopAlertView *)showMsg:(NSString *)message alertType:(TopAlertViewType)type{
    
    CDTopAlertView *topAlertView = (CDTopAlertView *)[ZXHViewTool customViewWithXIBName:@"CDTopAlertView" owner:nil];
    topAlertView.frame = CGRectMake(0, 0, ZXHScreenWidth, 64);
    [[UIApplication sharedApplication].keyWindow addSubview:topAlertView];
    
    
    if (type == TopAlertViewSuccessType){
        [topAlertView show:message bgColor:CD_TopAlertViewGreenColor];
        [topAlertView.tipImageView setImage:ZXHImageName(@"顶部正确提示")];
    }
    else if (type == TopAlertViewFailedType){
        [topAlertView show:message bgColor:CD_TopAlertViewRedColor];
        [topAlertView.tipImageView setImage:ZXHImageName(@"顶部错误提示")];
    }
    else {
        
        [topAlertView show:message bgColor:CD_TopAlertViewYellowColor];
        [topAlertView.tipImageView setImage:ZXHImageName(@"顶部错误提示")];
    }
    
    return topAlertView;
}



- (void)awakeFromNib {

    [super awakeFromNib];
}

- (void)dealloc {
    
    CLog(@"---[%@ dealloc]---",NSStringFromClass(self.class));
}

- (void)show:(NSString *)message bgColor:(UIColor *)color {
    
    self.alertBgView.hidden = YES;

    self.alertLabel.text = message;
    self.alertBgView.backgroundColor = color;
    
    [self.alertBgView setHidden:NO animation:CDAnimationTypeToBottom];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
            
            CGRect frame = self.alertBgView.frame;
            frame.origin.y = -frame.size.height;
            self.alertBgView.frame = frame;
            
        } completion:^(BOOL finished) {
            
            [self removeFromSuperview];
        }];
    });
    
}







@end
