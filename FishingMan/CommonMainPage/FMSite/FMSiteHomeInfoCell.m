//
//  FMSiteHomeInfoCell.m
//  FishingMan
//
//  Created by zhangxh on 2017/5/17.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMSiteHomeInfoCell.h"
#import "FMFishSiteModel.h"

@interface FMSiteHomeInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *updatedDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteFeeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteFishTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteTelLabel;

@property (weak, nonatomic) IBOutlet UIButton *parkingButton;
@property (weak, nonatomic) IBOutlet UIButton *foodButton;
@property (weak, nonatomic) IBOutlet UIButton *bedButton;
@property (weak, nonatomic) IBOutlet UIButton *nightButton;

@end

@implementation FMSiteHomeInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)siteMapButtonAction:(id)sender {
    CLog(@" = %@", @"地图");
    if (self.callback) {
        self.callback(FMTargetPageEventTypeMap);
    }
}

- (IBAction)siteAddressButtonAction:(id)sender {
    CLog(@" = %@", @"地址");
    if (self.callback) {
        self.callback(FMTargetPageEventTypeAddress);
    }
}

- (IBAction)sitePhoneCallButtonAction:(id)sender {
    CLog(@" = %@", @"电话");
    
    ZXH_WEAK_SELF
    [ZXHViewTool addAlertWithTitle:@"温馨提示"
                           message:@"即将拨打电话?"
                       withTartget:[self getFirstViewController]
                   leftActionStyle:UIAlertActionStyleDefault
                  rightActionStyle:UIAlertActionStyleDestructive
                 leftActionHandler:^(UIAlertAction *action) {
                     
                 }
                rightActionHandler:^(UIAlertAction *action) {
                    
                    if (weakself.callback) {
                        weakself.callback(FMTargetPageEventTypeCall);
                    }
                }];
}

- (void)reloadData{
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:self.siteModel.modified / 1000];
    _updatedDateTimeLabel.text = [NSString stringWithFormat:@"更新时间：%@", [ZXHTool dateAndTimeToMinuteStringFromDate:date]];
    
    int vout = 4;
    if(vout == 0){
        _recommendLabel.text = @"⭐️⭐️⭐️⭐️⭐️";
    }
    else{
        NSString * recommend = @"";
        for (int i = 0; i<vout; i++) {
            recommend = [recommend stringByAppendingString:@"⭐️"];
        }
        _recommendLabel.text = recommend;
    }
    
    _siteFeeTypeLabel.text = self.siteModel.siteFeeType ? self.siteModel.siteFeeType:@"免费";
    
    _siteFishTypeLabel.text = self.siteModel.siteFishType ? self.siteModel.siteFishType:@"";
    
    _siteAddressLabel.text = self.siteModel.address ? self.siteModel.address:@"";
    
    _siteTelLabel.text = self.siteModel.sitePhone ? self.siteModel.sitePhone:@"";
    
    [_parkingButton setBackgroundImage:self.siteModel.canPark ? ZXHImageName(@"钓点_可停车icon"):ZXHImageName(@"钓点_可停车_灰色")
                              forState:UIControlStateNormal];
    [_foodButton setBackgroundImage:self.siteModel.canEat ? ZXHImageName(@"钓点_提供餐饮icon"):ZXHImageName(@"钓点_提供餐饮_灰色")
                           forState:UIControlStateNormal];
    [_bedButton setBackgroundImage:self.siteModel.canHotel ? ZXHImageName(@"钓点_提供住宿icon"):ZXHImageName(@"钓点_提供住宿_灰色")
                          forState:UIControlStateNormal];
    [_nightButton setBackgroundImage:self.siteModel.canNight ? ZXHImageName(@"钓点_可夜钓icon"):ZXHImageName(@"钓点_可夜钓_灰色")
                            forState:UIControlStateNormal];
}
@end
