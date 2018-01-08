//
//  FMStoreHomeInfoCell.m
//  FishingMan
//
//  Created by zhangxh on 2017/5/17.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMStoreHomeInfoCell.h"
#import "FMFishStoreModel.h"

@interface FMStoreHomeInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *updatedDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *recommendLabel;
@property (weak, nonatomic) IBOutlet UITextView *storeDetailTextView;
@property (weak, nonatomic) IBOutlet UILabel *siteAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteTelLabel;

@end

@implementation FMStoreHomeInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)siteMapButtonAction:(id)sender {
    CLog(@" = %@", @"地图");
}

- (IBAction)siteAddressButtonAction:(id)sender {
    CLog(@" = %@", @"地址");
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
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:self.storeModel.modified / 1000];
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
    
    _siteAddressLabel.text = self.storeModel.address ? self.storeModel.address:@"";
    
    _siteTelLabel.text = self.storeModel.sitePhone ? self.storeModel.sitePhone:@"";
}

@end
