//
//  PostViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-18.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommHead.h"
#import "PostVisitorsCell.h"
#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <RennSDK/RennSDK.h>
#import "YXApi.h"
#import "ZBReply.h"
#import "ZBPost.h"


@class PostViewController, Post;

@protocol PostViewControllerDelegate <NSObject>

@optional
- (void)postViewController:(PostViewController *)postViewController withIndex:(NSInteger)index post:(Post *)changedPost;
- (void)postViewController:(PostViewController *)postViewController deleteWithIndex:(NSInteger)index;

@end

enum POST_ALERTVIEW_KIND {
    DEL_POST_ALERT = 1,
    DEL_REPLY_ALERT= 2,
    DEL_SUB_REPLY_ALERT=3,
    EDIT_POST  = 4,
    EDIT_REPLY = 5,
    REPLY_TO_ALERT = 6,
    SUB_REPLY_ALERT= 7,
    SHARE_POST_ALERT = 10,
    POST_OP_ALERT = 11,
    POST_REPLY_LAYER_ALERT = 12,
    };

@interface PostViewController : UIViewController<UIAlertViewDelegate,ISSContent>

@property (strong, nonatomic) UITableView *tableView;

@property (atomic, strong)NSMutableArray* replyList;
@property (nonatomic, strong)NSMutableArray* praiseList;

@property (nonatomic, copy) NSString *postID;


@property (nonatomic, copy) NSString *kindId;

#pragma mark - modified by Nick.2015-04-16(根据帖子详情页面的改变动态修改帖子列表对应的帖子)
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id<PostViewControllerDelegate> delegate;

- (void)back:(id)sender;

@end
