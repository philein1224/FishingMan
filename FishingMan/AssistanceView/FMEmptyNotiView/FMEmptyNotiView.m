//
//  FMEmptyNotiView.m
//  FishingMan
//
//  Created by zxh on 2017/6/20.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMEmptyNotiView.h"

@interface FMEmptyNotiView()

@property (weak, nonatomic) IBOutlet UIImageView *backImgView;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (assign, nonatomic) EmptyShowType emptyShowType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@end

@implementation FMEmptyNotiView

+ (FMEmptyNotiView *)initEmptyListView:(EmptyShowType)emptyShowType withFrame:(CGRect)frame{
    
    FMEmptyNotiView *emptyListView = [[[NSBundle mainBundle] loadNibNamed:@"FMEmptyNotiView" owner:nil options:nil] lastObject];
    
    if (emptyListView) {
        
        emptyListView.emptyShowType = emptyShowType;
        emptyListView.heightConstraint.constant = frame.size.height;
        [emptyListView showViewByShowType];
    }
    
    return emptyListView;
}

- (void)awakeFromNib{

    [super awakeFromNib];
}

- (void)showViewByShowType{
    
    if (self.emptyShowType == EmptyXiangMuShowType) {
        
        self.backImgView.image = ZXHImageName(@"wuxiangmu");
        [self.tipLabel setText:@"暂无项目"];
    }
    else if(self.emptyShowType == EmptyKaQuanShowType){
        
        self.backImgView.image = ZXHImageName(@"zanwukaquan");
        [self.tipLabel setText:@"暂无卡券"];
    }
    else if(self.emptyShowType == EmptyDingDanShowType){
        
        self.backImgView.image = ZXHImageName(@"wudingdan");
        [self.tipLabel setText:@"暂无订单"];
    }
    else if(self.emptyShowType == EmptyDataShowType){
        
        self.backImgView.image = ZXHImageName(@"wuxiangmu");
        [self.tipLabel setText:@"暂无数据"];
    }
}

@end
