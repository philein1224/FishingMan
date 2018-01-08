//
//  CDAnimations.h
//
//  Created by fightper on 2015.
//  Copyright (c) 2015年 fightper. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const CDAnimationTypeToTop;
extern NSString * const CDAnimationTypeToBottom;
extern NSString * const CDAnimationTypeToRight;
extern NSString * const CDAnimationTypeToLeft;

@interface UIView (CDAnimation)

- (void)setHidden:(BOOL)hidden animation:(NSString *)animationType;

@end