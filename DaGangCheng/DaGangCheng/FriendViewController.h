//
//  FriendViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendDataItem.h"
#import "FriendFuncItemCell.h"
#import "FriendTabCell.h"
#import "FriendMsgCell.h"
#import "FriendItemCell.h"
#import "NetRequest.h"
#import "ApiUrl.h"
#import "SQLDataBase.h"
#import "UIImageView+WebCache.h"
#import "ApiUrl.h"
#import "NearbyUsersViewController.h"
#import "TimeUtil.h"
#import "MyMsgViewController.h"
#import "FriendReqsViewController.h"
#import "NotifyCenter.h"
#import "JYSlideSegmentController.h"
#import "ZBTMyFeedTableVC.h"

@interface FriendViewController : UITableViewController
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (assign, nonatomic) int gfCnt;
@property (assign, nonatomic) int nfCnt;
@property (assign, nonatomic) int ufCnt;
@property (assign, nonatomic) int msgCnt;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic)NSTimer* timer;

@end
