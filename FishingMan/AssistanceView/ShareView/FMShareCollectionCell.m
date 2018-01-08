//
//  FMShareCollectionCell.m
//  FishingMan
//
//  Created by zhangxh on 2017/3/16.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMShareCollectionCell.h"

@interface FMShareCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *shareIcon;
@property (weak, nonatomic) IBOutlet UILabel     *shareTypeLabel;

@end

@implementation FMShareCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)loadData:(NSDictionary *)shareTypeInfo{
    
    self.shareTypeLabel.text = shareTypeInfo[@"keyName"];
    self.shareIcon.image = ZXHImageName(shareTypeInfo[@"keyIconName"]);
}

@end
