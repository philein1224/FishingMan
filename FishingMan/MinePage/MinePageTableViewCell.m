//
//  MinePageTableViewCell.m
//  ZiMaCaiHang
//
//  Created by maoqian on 16/6/13.
//  Copyright © 2016年 fightper. All rights reserved.
//

#import "MinePageTableViewCell.h"

@interface MinePageTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UILabel *valueLbl;

@property (weak, nonatomic) IBOutlet UILabel *flagCountLabel;

@end

@implementation MinePageTableViewCell

- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

/**
 *  根据数据配置cell
 *
 *  @param cellDicData 单元数据
 */
-(void) loadData:(NSDictionary *) cellDicData{
    
    self.iconImg.image = ZXHImageName(cellDicData[@"keyIconName"]);
    
    self.titleLbl.text = cellDicData[@"keyName"];
    
    
    NSString * keyValueType = [cellDicData objectForKey:@"keyValueType"];
    if([ZXHTool isEmptyString:keyValueType]){
        
        self.valueLbl.hidden = NO;
        self.flagCountLabel.hidden = YES;
        self.valueLbl.text = [NSString stringWithFormat:@"%@", cellDicData[@"keyValue"]];
    }
    else{
        
        self.valueLbl.hidden = YES;
        if ([keyValueType isEqualToString:@"countType"] &&
            ![ZXHTool isEmptyString:cellDicData[@"keyValue"]] &&
            ![cellDicData[@"keyValue"] isEqualToString:@"0"]) {
            
            self.flagCountLabel.text = [NSString stringWithFormat:@"%@", cellDicData[@"keyValue"]];
            self.flagCountLabel.hidden = NO;
            [self.flagCountLabel.layer setCornerRadius:7];
            [self.flagCountLabel.layer setMasksToBounds:YES];
        }
        else{
            self.valueLbl.hidden = YES;
            self.flagCountLabel.hidden = YES;
        }
    }
    
    
    
    CLog(@"xxx self.valueLbl.text = %@", self.valueLbl.text);
}

@end
