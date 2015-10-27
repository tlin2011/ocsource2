//
//  UIScrollView+touch.m
//  JYSlideSegmentController
//
//  Created by huaxo on 14-10-8.
//  Copyright (c) 2014年 Alvin. All rights reserved.
//

#import "UIScrollView+touch.h"

@implementation UIScrollView (touch)
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isMemberOfClass:[UIButton class]]) {
        return YES;
    }
    return NO;
}
@end
