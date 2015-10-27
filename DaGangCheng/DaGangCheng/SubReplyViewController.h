//
//  SubReplyViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-19.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommHead.h"
#import "HuaxoUtil.h"
#import "LoginViewController.h"
#import "SubReplyBoxView.h"

@protocol SubReplyDelegate <NSObject>
@optional
- (void)subReplySuccess:(NSString*)subId content:(NSString*)content;
- (void)subReplySuccessWithIndex:(NSInteger)index content:(NSString *)content;
@end

@interface SubReplyViewController : UIViewController

@property (nonatomic, assign) long replyId;

@property (nonatomic, strong) SubReplyBoxView *boxView;
@property (nonatomic, strong) UITextView *contentTV;

@property (nonatomic, assign) NSInteger index;        // 属于第几个评论

@property (nonatomic, weak)id<SubReplyDelegate> delegate;

@end
