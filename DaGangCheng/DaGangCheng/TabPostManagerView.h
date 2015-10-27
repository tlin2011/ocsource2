//
//  TabPostManagerView.h
//  DaGangCheng
//
//  Created by huaxo on 15-3-10.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class TabPostManagerView;

@protocol TabPostManagerViewDelegate <NSObject>

- (void)tabPostManagerView:(TabPostManagerView *)view selectedButtonTitle:(NSString *)title;

@end


@interface TabPostManagerView : UIView
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) CGRect viewFrame;
@property (nonatomic, weak) id<TabPostManagerViewDelegate>delegate;

- (id)initWithButtonTitles:(NSArray *)titles delegate:(id<TabPostManagerViewDelegate>)delegate;

- (void)show;
@end