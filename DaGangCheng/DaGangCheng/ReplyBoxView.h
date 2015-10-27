//
//  replyBoxView.h
//  DaGangCheng
//
//  Created by huaxo on 14-11-11.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ReplyBoxView;
@protocol ReplyBoxViewDelegate <NSObject>
@optional
- (void)failedReplyWithReplyBoxView:(ReplyBoxView *)rbview msg:(NSString *)msg;
- (void)finishedReplyWithReplyBoxView:(ReplyBoxView *)rbview;

@end


@interface ReplyBoxView : UIView
@property (nonatomic, strong) UIButton *voiceBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) UITextView *inputTV;
@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, copy) NSString *postId;
@property (nonatomic, copy) NSString *replyId;
@property (nonatomic, weak) id<ReplyBoxViewDelegate>replyDelegate;

@property (nonatomic, weak) UIViewController *delegate;

- (void)updateView;
@end
