//
//  FishMultiImageCell.m
//  ZXHTools
//
//  Created by zhangxh on 2016/11/16.
//  Copyright © 2016年 HongFan. All rights reserved.
//

#import "FishMultiImageCell.h"
#import "FMArticleModel.h"

@interface FishMultiImageCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pic0;
@property (weak, nonatomic) IBOutlet UIImageView *pic1;
@property (weak, nonatomic) IBOutlet UIImageView *pic2;


@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCityLabel;

@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@property (weak, nonatomic) IBOutlet UILabel *praiseCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@end

@implementation FishMultiImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)reloadData{
    
    //1、图片
    for (int i = 0; i < self.articleModel.imageCount; i++) {
        if (i == 0) {
            [ZXHViewTool setImageView:self.pic0
                         WithImageURL:[NSURL URLWithString:self.articleModel.pic0]
                   AndPlaceHolderName:@"articleImagePlaceholder"
                       CompletedBlock:nil];
            continue;
        }
        else if (i == 1){
            [ZXHViewTool setImageView:self.pic1
                         WithImageURL:[NSURL URLWithString:self.articleModel.pic1]
                   AndPlaceHolderName:@"articleImagePlaceholder"
                       CompletedBlock:nil];
            continue;
        }
        else if (i == 2){
            [ZXHViewTool setImageView:self.pic2
                         WithImageURL:[NSURL URLWithString:self.articleModel.pic2]
                   AndPlaceHolderName:@"articleImagePlaceholder"
                       CompletedBlock:nil];
            continue;
        }
        break;
    }
    //2、文章标题
    NSString * typeName = [ZXHTool articleTypeNameFromArticleType:self.articleModel.articleType];
    self.titleLabel.text = [NSString stringWithFormat:@"%@ + %@",typeName,self.articleModel.title];
//    self.titleLabel.text = self.articleModel.title;
    
    //3、创建时间 1509502676000
    NSDate * dateTime = [ZXHTool dateFromTimeInterval:self.articleModel.created / 1000];
    self.creatTimeLabel.text = [ZXHTool compareCurrentTimeWithDate:dateTime];
    
    //4、用户的信息
    [self updateUserInfo];
    
    //5、点赞的数量
    self.praiseCountLabel.text = [NSString stringWithFormat:@"%d", self.articleModel.likeCount];
    
    //6、评论的数量
    self.commentCountLabel.text = [NSString stringWithFormat:@"%d",self.articleModel.commentCount];
    
    //7、用户的地址
    self.userCityLabel.text = [NSString stringWithFormat:@"成都"];
}

- (void)updateUserInfo{
    
    //用户头像
    [ZXHViewTool setImageView:self.avatarImageView
                 WithImageURL:[NSURL URLWithString:self.articleModel.user.avatarUrl]
           AndPlaceHolderName:@"Mine_avatar"
               CompletedBlock:nil];
    //用户的昵称
    self.nickNameLabel.text = [NSString stringWithFormat:@"%@", self.articleModel.user.nickName];
}

@end
