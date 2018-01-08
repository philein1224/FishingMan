//
//  LocalFishUserTBCell.m
//  FishingMan
//
//  Created by zhangxh on 2017/3/23.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "LocalFishUserTBCell.h"

@interface LocalFishUserTBCell (){
    
    BOOL isFollowedByMe;     //本地用户是否关注朋友。未关注：可以关注；已关注：取消关注
}
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *avatarImageButton;
@property (weak, nonatomic) IBOutlet UILabel  *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel  *friendAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel  *friendDistanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@end

@implementation LocalFishUserTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //圆角
    self.avatarImageView.layer.cornerRadius = self.avatarImageButton.frame.size.width/2.0;
    self.avatarImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

/**
 *  @author zxh, 17-05-22 13:05:10
 *
 *  未关注或者已关注
 *
 *  @param sender
 */
- (IBAction)followButtonAction:(id)sender {
    
    if(self.callback_UserTBCell){
        
        self.callback_UserTBCell(isFollowedByMe);
    }
    
    switch (self.friendType) {
            
        case FMFriendTypeFollows:
        {
            [_followButton setTitle:@"加关注" forState:UIControlStateNormal];
            [_followButton setTitleColor:ZXHColorHEX(@"007AFF", 1) forState:UIControlStateNormal];
        }
            break;
            
        case FMFriendTypeFans:
        {
            [_followButton setTitle:@"已关注" forState:UIControlStateNormal];
            [_followButton setTitleColor:ZXHColorHEX(@"007AFF", 1) forState:UIControlStateNormal];
        }
            break;
            
        case FMFriendTypeNormal:
        default:
        {
            //还未做任何行为
        }
            break;
    }
}

- (void)reloadData{
    
}

@end
