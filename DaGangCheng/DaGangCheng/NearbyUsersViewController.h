//
//  NearbyUsersViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-12.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommHead.h"

@interface NearbyUsersViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *dataList;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) NSTimer *timer;

@end
