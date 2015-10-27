//
//  PostZanAndReplyView.h
//  DaGangCheng
//
//  Created by huaxo on 14-10-14.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostZanAndReplyView;

@protocol PostZanAndReplyViewDelegate <NSObject>

@optional
- (void)postZanAndReplyView:(PostZanAndReplyView *)view selectedTitle:(NSString *)title;

@end

@interface PostZanAndReplyView : UIView
@property (nonatomic, strong) UIButton *zanBtn;
@property (nonatomic, strong) UIButton *replyBtn;

@property (nonatomic, assign) NSInteger zanNum;
@property (nonatomic, assign) NSInteger replyNum;
@property (nonatomic, weak) id<PostZanAndReplyViewDelegate>delegate;
@end
