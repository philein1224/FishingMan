//
//  FMWeatherFutureCollectionCell.h
//  ZiMaCaiHang
//
//  Created by fightper on 16/6/7.
//  Copyright © 2016年 fightper. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMWeatherFutureModel.h"

@interface FMWeatherFutureCollectionCell : UICollectionViewCell

@property (strong, nonatomic) FMWeatherFutureModel * weatherFutureModel;

@property (assign, nonatomic) BOOL isHiddenLine;

- (void)reloadData;

@end
