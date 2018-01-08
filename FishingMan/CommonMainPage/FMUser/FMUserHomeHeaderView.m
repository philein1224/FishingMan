//
//  FMUserHomeHeaderView.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/23.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMUserHomeHeaderView.h"
#import "FMLoginUser.h"

@interface FMUserHomeHeaderView ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton    *followsButton;
@property (weak, nonatomic) IBOutlet UIButton    *fansButton;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;
@property (weak, nonatomic) IBOutlet UILabel     *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel     *levelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@end

@implementation FMUserHomeHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    _avatarImageView.layer.cornerRadius = _avatarImageView.frame.size.width/2.0 * ZXHRatioWithReal375;
}

- (NSString *)sexImageNameConvertFromType:(int)sexType{
    NSString * sexName = @"";
    switch (sexType) {
        case 0:
            sexName = @"Mine_men";
            break;
        case 1:
            sexName = @"Mine_women";
            break;
        case 3:
        default:
            sexName = @"Mine_unknown";
            break;
    }
    
    return sexName;
}

-(void)reloadData:(id)data userType:(FMUserType)userType{
    
    if (userType == FMUserTypeAdmin) {
        
        if (IS_LOGIN) {
            //已登录用户
            FMLoginUser * user = [FMLoginUser getCacheUserInfo];
            [ZXHViewTool setImageView:_avatarImageView WithImageURL:[NSURL URLWithString:user.avatarUrl] AndPlaceHolderName:@"Mine_avatar" CompletedBlock:nil];
            
            _nickNameLabel.text = [ZXHTool isEmptyString:user.nickName]?@"钓鱼大仙":user.nickName;
            
            _levelLabel.text = [FMLoginUser levelConvertFromType:user.level];
            
            _sexImageView.image = ZXHImageName([self sexImageNameConvertFromType:user.sex]);
            
        }
        else{
            //未登录
            _avatarImageView.image = ZXHImageName(@"Mine_avatar");
            
            _nickNameLabel.text = @"钓鱼大仙";
            
            _levelLabel.text = [FMLoginUser levelConvertFromType:0];
            _sexImageView.image = ZXHImageName(@"Mine_men");
        }
    }
    else if (userType == FMUserTypeFriend)
    {
#warning 普通朋友
        
        //TO DO
        //性别标志
        _sexImageView.image = ZXHImageName([self sexImageNameConvertFromType:0]);
    }
}

/**
 *  @author zxh, 17-05-22 00:05:37
 *
 *  头像点击事件
 *
 *  @param sender
 */
- (IBAction)userAvatarButtonAction:(id)sender{
    
    if (_callBack_userHomeActionType) {
        _callBack_userHomeActionType(self.avatarTapActionType);
    }
}
/**
 *  @author zxh, 17-05-22 00:05:37
 *
 *  关注
 *
 *  @param sender
 */
- (IBAction)followByMeButtonAction:(id)sender {
    
    if (_callBack_userHomeActionType) {
        _callBack_userHomeActionType(FMUserHomeFollows);
    }
}
/**
 *  @author zxh, 17-05-22 00:05:48
 *
 *  粉丝
 *
 *  @param sender 
 */
- (IBAction)followMeButtonAction:(id)sender {
    
    if (_callBack_userHomeActionType) {
        _callBack_userHomeActionType(FMUserHomeFans);
    }
}


@end
