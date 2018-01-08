//
//  LocalFishSiteTBCell.m
//  FishingMan
//
//  Created by zhangxh on 2017/3/22.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "LocalFishSiteTBCell.h"

@interface LocalFishSiteTBCell()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *telephoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteFishTypeLabel;



@end

@implementation LocalFishSiteTBCell

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
    
    if(![ZXHTool isEmptyString:self.model.pic0]){
        [ZXHViewTool setImageView:self.avatarImageView
                     WithImageURL:[NSURL URLWithString:self.model.pic0]
               AndPlaceHolderName:@""
                   CompletedBlock:nil];
    }
    
    self.nameLabel.text = self.model.title;
    self.siteTypeLabel.text = self.model.siteType;
    self.siteFeeLabel.text = self.model.siteFeeType;
    self.siteFishTypeLabel.text = self.model.siteFishType;
    
    self.distanceLabel.text = [ZXHTool distanceStringFromLat1:30.487958 Lng1:104.063377 ToLat2:30.485455 Lng2:104.063371];
    
    self.telephoneLabel.text = self.model.sitePhone?self.model.sitePhone:@"无";
    self.addressLabel.text = self.model.address;
}
@end
