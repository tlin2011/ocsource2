//
//  ReplyManagerView.h
//  DaGangCheng
//
//  Created by huaxo on 14-10-16.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@class ReplyManagerView;

@protocol ReplyManagerViewDelegate <NSObject>

@optional
- (void)replyManagerView:(ReplyManagerView *)view selectedButtonTitle:(NSString *)title;

@end

@interface ReplyManagerView : UIView
@property (nonatomic, weak) id<ReplyManagerViewDelegate>delegate;

- (id)initWithButtonTitles:(NSArray *)titles delegate:(id<ReplyManagerViewDelegate>)delegate origin:(CGPoint)point;

- (void)show;
@end
