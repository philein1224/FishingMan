//
//  DiscoveryPageTableViewCell.m
//  ZiMaCaiHang
//
//  Created by maoqian on 16/6/13.
//  Copyright © 2016年 fightper. All rights reserved.
//

#import "DiscoveryPageTableViewCell.h"

@interface DiscoveryPageTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UIImageView *iconImg;

@property (weak, nonatomic) IBOutlet UILabel *valueLbl;
@end

@implementation DiscoveryPageTableViewCell

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
    
    NSLog(@"cellDicData = %@", cellDicData);
    
    self.iconImg.image = ZXHImageName(cellDicData[@"keyIconName"]);
    
    self.titleLbl.text = cellDicData[@"keyName"];
    
    self.valueLbl.text = [NSString stringWithFormat:@"%@条新帖", cellDicData[@"keyValue"]];
}

@end
