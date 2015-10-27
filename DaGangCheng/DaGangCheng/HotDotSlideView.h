//
//  HotDotSlideView.h
//  DaGangCheng
//
//  Created by huaxo on 14-10-24.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@class HotDotSlideView;

@protocol HotDotSlideViewDelegate <NSObject>
@optional
- (void)hotDotSlideView:(HotDotSlideView *)view didClick:(Post *)post;
- (void)hotDotSlideView:(HotDotSlideView *)view currentPage:(int)page total:(NSUInteger)total;

@end


@interface HotDotSlideView : UIView
@property (weak, nonatomic) id<HotDotSlideViewDelegate>delegate;
@property (weak, nonatomic) UITableView *delegateTab;
@end
