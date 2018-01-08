//
//  CDAnimations.m
//
//  Created by fightper on 2015.
//  Copyright (c) 2015年 fightper. All rights reserved.
//

#import "CDAnimations.h"
#include <QuartzCore/CoreAnimation.h>

NSString * const CDAnimationTypeToTop    = @"CDAnimationTypeToTop";
NSString * const CDAnimationTypeToBottom = @"CDAnimationTypeToBottom";
NSString * const CDAnimationTypeToLeft   = @"CDAnimationTypeToLeft";
NSString * const CDAnimationTypeToRight  = @"CDAnimationTypeToRight";

@implementation UIView (CDAnimation)

- (void)setHidden:(BOOL)hidden animation:(NSString*)animationType {
    
    CATransition *animation = [CATransition animation];
    //[animation setDelegate:self];
    [animation setType:kCATransitionPush];
    
    if ([animationType isEqualToString:CDAnimationTypeToTop]) {
        
        [animation setSubtype:kCATransitionFromTop];
        
    }else if([animationType isEqualToString:CDAnimationTypeToBottom]){
        
        [animation setSubtype:kCATransitionFromBottom];
        
    }else if([animationType isEqualToString:CDAnimationTypeToLeft]){
        
        [animation setSubtype:kCATransitionFromRight];
        
    }else if([animationType isEqualToString:CDAnimationTypeToRight]){
        
        [animation setSubtype:kCATransitionFromLeft];
    }
    
    [animation setDuration:UINavigationControllerHideShowBarDuration];
    [[self layer] addAnimation:animation forKey:animationType];
    self.hidden = hidden;
}

@end