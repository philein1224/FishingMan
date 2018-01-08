//
//  MessageChooseView.m
//  ZiMaCaiHang
//
//  Created by zhangxh on 2017/3/22.
//  Copyright © 2017年 fightper. All rights reserved.
//

#import "MessageChooseView.h"
#import "UIImage+Blur.h"
#import "UIImage+Screenshot.h"

static float const kAlertDuration = 5.f;

static float const kAnimateDuration = .9f;
static float const kBlurParameter = 10.0f;

@interface MessageChooseView ()

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *groupView;

@property (weak, nonatomic) IBOutlet UIButton *activeButton;   //活动消息

@property (weak, nonatomic) IBOutlet UIButton *systemButton;   //系统消息


@end

@implementation MessageChooseView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.activeButton.layer.borderColor = CDColorHEX(0x333333, 1).CGColor;
    self.activeButton.layer.borderWidth = 0.6;
    [self.activeButton setTitleColor:CDColorHEX(0x333333, 1) forState:UIControlStateNormal];
    [self.activeButton setTitleColor:CDColorHEX(0xBC00FC, 1) forState:UIControlStateHighlighted];
    [self.activeButton setTitleColor:CDColorHEX(0xBC00FC, 1) forState:UIControlStateSelected];
    [self.activeButton addTarget:self action:@selector(normalStatus:) forControlEvents:UIControlEventTouchUpInside];
    [self.activeButton addTarget:self action:@selector(upOutsideStatus:) forControlEvents:UIControlEventTouchUpOutside];
    [self.activeButton addTarget:self action:@selector(pressingStatus:) forControlEvents:UIControlEventTouchDown];
    
    self.systemButton.layer.borderColor = CDColorHEX(0x333333, 1).CGColor;
    self.systemButton.layer.borderWidth = 0.6;
    [self.systemButton setTitleColor:CDColorHEX(0x333333, 1) forState:UIControlStateNormal];
    [self.systemButton setTitleColor:CDColorHEX(0xBC00FC, 1) forState:UIControlStateHighlighted];
    [self.systemButton setTitleColor:CDColorHEX(0xBC00FC, 1) forState:UIControlStateSelected];
    
    [self.systemButton addTarget:self action:@selector(normalStatus:) forControlEvents:UIControlEventTouchUpInside];
    [self.systemButton addTarget:self action:@selector(upOutsideStatus:) forControlEvents:UIControlEventTouchUpOutside];
    [self.systemButton addTarget:self action:@selector(pressingStatus:) forControlEvents:UIControlEventTouchDown];

    [self loadingBlurry];
}

- (void)pressingStatus:(UIButton *)button{
        button.layer.borderColor = CDColorHEX(0xBC00FC, 1).CGColor;
}

- (void)upOutsideStatus:(UIButton *)button{
    button.layer.borderColor = CDColorHEX(0x333333, 1).CGColor;
}

- (void)normalStatus:(UIButton *)button{
        button.layer.borderColor = CDColorHEX(0x333333, 1).CGColor;
    
    
    if(self.showSingleTypeMessage){
        
        NSString * msgType = @"";
        if(self.activeButton == button){
            msgType = @"ACTIVITY";
        }
        else if(self.systemButton == button){
            msgType = @"MESSAGE";
        }
        else{
            msgType = @"NEWS";
        }
        
        self.showSingleTypeMessage(msgType, button.currentTitle);
    }
}

- (void)loadingBlurry{
    
    UIImage *viewshot = [UIImage screenshot];
    
    //旧方法
//    NSString *path1=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/4444.png"];
//    [UIImagePNGRepresentation(viewshot) writeToFile:path1 atomically:YES];
//    
//    NSData *imageData = UIImageJPEGRepresentation(viewshot, 0.0001);
//    UIImage *blurredSnapshot = [[UIImage imageWithData:imageData] blurredImage:kBlurParameter];
//    self.backgroundImageView.image = blurredSnapshot;
    
    //新发放
    self.backgroundImageView.image = viewshot;
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0,
                                  0,
                                  _backgroundImageView.frame.size.width,
                                  _backgroundImageView.frame.size.height);
    [_backgroundImageView addSubview:effectView];
    
    self.backgroundImageView.alpha = 0.0;
    
    self.groupView.alpha = 0.0;
    
    [self insertSubview:self.groupView aboveSubview:self.backgroundImageView];
    
    
    [UIView animateWithDuration:kAnimateDuration animations:^{
        self.backgroundImageView.alpha = 1.0;
        self.groupView.alpha = 1.0;
    } completion:^(BOOL finished) {
        if (finished) {
            CLog(@"wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww");
        }
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
