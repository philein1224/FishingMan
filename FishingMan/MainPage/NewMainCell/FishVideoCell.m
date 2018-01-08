//
//  FishVideoCell.m
//  ZXHTools
//
//  Created by zhangxh on 2016/11/16.
//  Copyright © 2016年 HongFan. All rights reserved.
//

#import "FishVideoCell.h"
#import "FMArticleModel.h"


@interface FishVideoCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pic0;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCityLabel;

@property (weak, nonatomic) IBOutlet UIButton *praiseButton;
@property (weak, nonatomic) IBOutlet UILabel *praiseCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;

@end

@implementation FishVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadData{
}
@end
