//
//  PostManagerView.h
//  DaGangCheng
//
//  Created by huaxo on 14-10-13.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class PostManagerView;

@protocol PostManagerViewDelegate <NSObject>

@optional
- (void)postManagerView:(PostManagerView *)view selectedButtonTitle:(NSString *)title;

@end


@interface PostManagerView : UIView
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, weak) id<PostManagerViewDelegate>delegate;

- (id)initWithButtonTitles:(NSArray *)titles delegate:(id<PostManagerViewDelegate>)delegate;

- (void)show;
@end
