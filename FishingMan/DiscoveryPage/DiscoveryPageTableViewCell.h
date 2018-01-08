//
//  DiscoveryPageTableViewCell.h
//  ZiMaCaiHang
//
//  Created by maoqian on 16/6/13.
//  Copyright © 2016年 fightper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoveryPageTableViewCell : UITableViewCell

/**
 *  根据数据配置cell
 *
 *  @param cellDicData 单元数据
 */
-(void) loadData:(NSDictionary *) cellDicData;

@end
