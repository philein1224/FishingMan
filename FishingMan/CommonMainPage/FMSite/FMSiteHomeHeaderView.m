//
//  FMSiteHomeHeaderView.m
//  FishingMan
//
//  Created by zhangxh on 2017/4/23.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMSiteHomeHeaderView.h"
#import "FMFishSiteModel.h"

@interface  FMSiteHomeHeaderView()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *siteNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *surroundLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritesLabel;

@end

@implementation FMSiteHomeHeaderView

- (void)reloadData{
    
    [ZXHViewTool setImageView:_bgImageView WithImageURL:[NSURL URLWithString:self.siteModel.pic0] AndPlaceHolderName:@"background_image" CompletedBlock:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
    self.siteNameLabel.text = [NSString stringWithFormat:@"%@", self.siteModel.title?self.siteModel.title:@""];
    self.surroundLabel.text = [NSString stringWithFormat:@"围观人数：%d", 800];
    self.favoritesLabel.text = [NSString stringWithFormat:@"收藏人数：%d", 60];
}

@end
