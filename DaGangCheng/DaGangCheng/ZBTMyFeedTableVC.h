//
//  ZBTMyFeedTableVC.h
//  DaGangCheng
//
//  Created by huaxo on 14-9-19.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiUrl.h"
#import "NetRequest.h"
#import "MJRefresh.h"
#import "MyFeedsCell.h"
#import "SQLDataBase.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "TimeUtil.h"
#import "PostViewController.h"
#import "CSPortalParser.h"
#import "ZBTLoadingView.h"

@interface ZBTMyFeedTableVC : UITableViewController

@property (nonatomic,strong) NSMutableArray* dataArray;
@property (nonatomic, copy) NSString *anyFeedStr;
@end
