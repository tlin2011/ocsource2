//
//  FriendReqsViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-15.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendReqCell.h"
#import "CommHead.h"

@interface FriendReqsViewController : UITableViewController<UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataList;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) NSTimer* timer;

@end
