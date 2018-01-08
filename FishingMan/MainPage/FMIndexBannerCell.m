//
//  FMIndexBannerCell.m
//  FishingMan
//
//  Created by zhangxh on 2017/3/22.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "FMIndexBannerCell.h"

@implementation FMIndexBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.clipsToBounds = YES;
}

- (void)dealloc {

    NSLog(@"---[%@ dealloc]---",NSStringFromClass(self.class));
}

- (void)reloadData {

    [self createSlideView];
}

- (void)createSlideView {
    
    [self.slideView removeFromSuperview];
    self.slideView = nil;
    
    if (!self.slideView) {
        
        self.slideView = [[CDSlideView alloc] initWithFrame:CGRectMake(0, 0, ZXHScreenWidth, [FMIndexBannerCell realHeight])];
        
        NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:5];
        
        for (int i = 0; i < self.dataArray.count; i++) {
            
            NSDictionary *sliderModel = self.dataArray[i];
            
            CDSlideObject *slideObject = [[CDSlideObject alloc] init];
            slideObject.defaultImageName = @"mainSliderPlaceholder";
            slideObject.urlString = [ZXHTool URLEncodingWithString:[NSString stringWithFormat:@"%@", sliderModel[@"img"]]];
            slideObject.info = sliderModel;
            
            [imageArray addObject:slideObject];
        }
        
        __weak __typeof (self) weakSelf = self;
        
        self.slideView.slideContentSelected = ^(CDSlideObject *selectedSlide){
            
            if (weakSelf.cellClickedCallBack) {
                
                weakSelf.cellClickedCallBack(selectedSlide.info);
            }
        };
        
        CGRect rect = self.slideView.pageControl.frame;
        NSInteger pageWidth =  20 * self.dataArray.count;
        CGRect pageControlFrame = CGRectMake((ZXHScreenWidth - pageWidth) / 2,
                                             self.slideView.frame.size.height - rect.size.height,
                                             pageWidth,
                                             rect.size.height);
        [self.slideView resetUIPageControlFrame:pageControlFrame];
        self.slideView.hiddenPageControl = NO;
        self.slideView.pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.75];
        self.slideView.pageControl.pageIndicatorTintColor = [ZXHTool colorWithHexString:@"e0dfe0" withAlpha:0.5];
        
        self.slideView.slideObjectArray = imageArray;
        [self addSubview:self.slideView];
        
//        self.slideView.slideContentShowPage = ^(CDSlideObject *selectedSlide, int currentPage){
//
//            int width = weakSelf.frame.size.width / weakSelf.slideView.slideObjectArray.count * (currentPage+1);
//            
//            weakSelf.lineView.frame = CGRectMake(0, weakSelf.frame.size.height - 2, width, 2);
//        };
        
//        if (imageArray.count > 0) {
//            
//            self.lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.slideView.frame.size.height - 2, self.slideView.frame.size.width / imageArray.count, 2)];
//            self.lineView.backgroundColor = CDColorHEX(0x905AC7, 1);
//            [self addSubview:self.lineView];
//        }
    }
}

+ (double)realHeight {

    return ZXHRatioWithReal375 * 154.0;
}

@end
