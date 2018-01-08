//
//  CDSlideView.h
//
//  Created by zhangxh on 2017/3/22.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDSlideObject : NSObject

@property (copy, nonatomic) NSString *nameString;//本地图片名字    \  |     |
@property (copy, nonatomic) NSString *urlString;//网络图片地址     /  |二选一|
@property (copy, nonatomic) NSString *descString;

@property (copy, nonatomic) NSString *defaultImageName; //不带2x或者3x后缀

@property (strong, nonatomic) id info; //用于存放需要传递的信息

@end

typedef void(^SlideContentSelected)(CDSlideObject *slideObject);

typedef void(^SlideContentShowPage)(CDSlideObject *slideObject, int currentPage);

@interface CDSlideView : UIView

@property (strong, nonatomic) NSArray *slideObjectArray;//CDSlideObject
@property (assign, nonatomic) int currentIndexPage; //default==0

@property (copy, nonatomic) SlideContentSelected slideContentSelected;
@property (copy, nonatomic) SlideContentShowPage slideContentShowPage;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (assign, nonatomic) BOOL hiddenPageControl;

- (void)resetUIPageControlFrame:(CGRect)newFrame;

@end
