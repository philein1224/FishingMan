//
//  CDSlideView.h
//
//  Created by zhangxh on 2017/3/22.
//  Copyright © 2017年 HongFan. All rights reserved.
//

#import "CDSlideView.h"
#import "UIImageView+WebCache.h"

@implementation CDSlideObject
@end

//CDSlideContentView显示在scrollView上面的内容视图对象///////////////////////////////////////////////////
@interface CDSlideContentView : UIView

@property (nonatomic, strong) CDSlideObject *slideObject;
@property (nonatomic, strong) UIImageView *imageView;
@property (copy, nonatomic) SlideContentSelected slideContentSelected;

- (void)reloadData;

@end

@implementation CDSlideContentView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.contentMode = UIViewContentModeScaleToFill;//UIViewContentModeScaleAspectFit;
        
        if (_slideObject.defaultImageName) {
            
            _imageView.image = [UIImage imageNamed:_slideObject.defaultImageName];
        }
        
        [self addSubview:_imageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [self addGestureRecognizer:tapGesture];
    }
    
    return self;
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap {
    
    if (self.slideContentSelected) {self.slideContentSelected(_slideObject);}
}

- (void)setSlideObject:(CDSlideObject *)slideObject {

    _slideObject = slideObject;
    [self reloadData];
}

- (void)reloadData {

    if (_slideObject.nameString) {
        
        self.imageView.image = [UIImage imageNamed:_slideObject.nameString];
    }else {
    
        NSString *urlString = [ZXHTool URLEncodingWithString:_slideObject.urlString];
        
        if ([[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString]) {
            
            self.imageView.image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
            
        }else {
        
            if (_slideObject.defaultImageName) {
                
                __weak typeof (self) weakSelf = self;
                
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:_slideObject.defaultImageName] options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    if (!error) {
                        
                        weakSelf.imageView.contentMode = UIViewContentModeScaleToFill;
                    }
                    
                    if (image && !error) {
                        
                        [[SDImageCache sharedImageCache] storeImage:image forKey:urlString toDisk:YES completion:^{
                            
                        }];
                    }
                    
                    if (error) {
                        
                        NSLog(@"XXX-CDSlideView imagereload error:%@",error);
                    }
                    
                }];
            }else {
                
                [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    if (image && !error) {
                        
                        [[SDImageCache sharedImageCache] storeImage:image forKey:urlString toDisk:YES completion:^{
                            
                        }];
                    }
                    
                    if (error) {
                        
                        NSLog(@"XXX-CDSlideView imagereload error:%@",error);
                    }
                }];
            }
        }
    }
}

@end

//////////////////////////CDSlideContentView end/////////////////////////////////////////////////////

@interface CDSlideView () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *contentViewArray;

@property (weak, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSTimeInterval timeInterval;

@end

@implementation CDSlideView

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        _timeInterval = 6;
        _contentViewArray = [[NSMutableArray alloc] initWithCapacity:3];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 3, _scrollView.frame.size.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        _scrollView.bounces = NO;
        _scrollView.delegate = self;
        
        [self addSubview:_scrollView];
        
        __weak __typeof(self)weakSelf = self;
        
        for (int i = 0; i < 3; i++) {
            
            CDSlideContentView *slideContentView = [[CDSlideContentView alloc] initWithFrame:CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height)];
            
            slideContentView.slideContentSelected = ^ (CDSlideObject *callbackObject) {
            
                if (weakSelf.slideContentSelected) {weakSelf.slideContentSelected(callbackObject);}
            };
            
            [_scrollView addSubview:slideContentView];
            [_contentViewArray addObject:slideContentView];
        }
        
        _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 15, frame.size.width, 15)];
        
        [self addSubview:_pageControl];
    }
    
    return self;
}

- (void)resetUIPageControlFrame:(CGRect)newFrame{
    
    _pageControl.frame = newFrame;
}


- (void)willMoveToSuperview:(UIView *)newSuperview {
    
    if (!newSuperview) {
        _scrollView.delegate = nil;
        _slideContentShowPage = nil;
    }
    if ([self.timer isValid]) {[self.timer invalidate],self.timer = nil;}
    [super willMoveToSuperview:newSuperview];
}

- (void)drawRect:(CGRect)rect {
    
    self.pageControl.hidden = self.hiddenPageControl;
    
    if (!self.timer) {
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(autoScrollMethod) userInfo:nil repeats:YES];
    }
}

- (void)autoScrollMethod {
    
    if (_slideObjectArray.count > 1) {
        
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * 2, 0) animated:YES];
    }
}

- (void)dealloc {

    NSLog(@"---[%@ dealloc]---",NSStringFromClass(self.class));
    if ([self.timer isValid]) {[self.timer invalidate],self.timer = nil;}
}

- (void)setSlideObjectArray:(NSArray *)slideObjectArray {

    _slideObjectArray = slideObjectArray;
    _pageControl.numberOfPages = _slideObjectArray.count;
    _currentIndexPage = 0;
    if (_slideObjectArray.count > 1) {
        
        _scrollView.scrollEnabled = YES;
    }else {
        _scrollView.scrollEnabled = NO;
    }
    
    if (_slideObjectArray.count <= 1) {
        
        self.hiddenPageControl = YES;
        _pageControl.hidden = self.hiddenPageControl;
    }
    
    [self reloadData];
}

- (void)reloadData {
    
    if (_slideObjectArray.count <= 1) {
        
        self.hiddenPageControl = YES;
        _pageControl.hidden = self.hiddenPageControl;
    }
    
    if (_slideObjectArray.count == 0) {return;}
    
    self.pageControl.hidden = self.hiddenPageControl;
    
    //如果_currentIndexPage小于0,就指向最后一个
    if (_currentIndexPage < 0) {_currentIndexPage = (int)_slideObjectArray.count - 1;}
    //如果超出数组下标,就指向第一个
    if (_currentIndexPage >= _slideObjectArray.count) {_currentIndexPage = 0;}
    
    int prevIndex = _currentIndexPage - 1;
    int nextIndex = _currentIndexPage + 1;
    
    //如果前一个小于0,就指向最后一个
    if (prevIndex < 0) {prevIndex = (int)_slideObjectArray.count - 1;}
    //如果超出数组下标,就指向第一个
    if (nextIndex >= _slideObjectArray.count) {nextIndex = 0;}
    
    //NSLog(@"prevIndex:%d,currentIndex:%d,nextIndex:%d",prevIndex,_currentIndexPage,nextIndex);
    
    CDSlideContentView *prevSlideContentView = (CDSlideContentView *)_contentViewArray[0];
    prevSlideContentView.slideObject = _slideObjectArray[prevIndex];
    
    CDSlideContentView *currSlideContentView = (CDSlideContentView *)_contentViewArray[1];
    currSlideContentView.slideObject = _slideObjectArray[_currentIndexPage];
    
    CDSlideContentView *nextSlideContentView = (CDSlideContentView *)_contentViewArray[2];
    nextSlideContentView.slideObject = _slideObjectArray[nextIndex];
    
    _scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
    _pageControl.currentPage = _currentIndexPage;
    
    if (self.slideContentShowPage) {
        
        self.slideContentShowPage(currSlideContentView.slideObject, _currentIndexPage);
    }
}

#pragma mark - 计算currentIndexPage

- (void)calculationPageWithScrollView:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x == scrollView.frame.size.width) {
        //如果相等就代表停留在中间,并未滑动,不进行处理
        return;
        
    }else if (scrollView.contentOffset.x < scrollView.frame.size.width) {
        
        _currentIndexPage = _currentIndexPage - 1;
    
        
    }else if (scrollView.contentOffset.x > scrollView.frame.size.width) {
        
        _currentIndexPage = _currentIndexPage + 1;
    }
    
    [self reloadData];
}

#pragma mark -scrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self resumeTimerAfterTimeInterval:_timeInterval];
    
    if (!decelerate) {[self calculationPageWithScrollView:scrollView];}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [self calculationPageWithScrollView:scrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    [self calculationPageWithScrollView:scrollView];
}

-(void)pauseTimer {
    
    //NSLog(@"---pauseTimer---");
    if (![self.timer isValid]) {return;}
    [self.timer setFireDate:[NSDate distantFuture]];
}
 
-(void)resumeTimer {
    
    //NSLog(@"---resumeTimer---");
    if (![self.timer isValid]) {return;}
    [self.timer setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)timeInterval {
    
    //NSLog(@"---resumeTimerAfterTimeInterval:%f---",timeInterval);
    if (![self.timer isValid]) {return;}
    [self.timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval]];
}






@end
