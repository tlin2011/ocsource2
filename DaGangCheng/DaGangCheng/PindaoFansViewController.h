//
//  PindaoFansViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-16.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommHead.h"
#import "PindaoFansCell.h"
#import "PindaoFansSectionCell.h"
#import "SearchUserViewController.h"

#import "ProhibitTalkView.h"

@class CustomWindow;

@interface PindaoFansViewController : UITableViewController<UIGestureRecognizerDelegate, UIAlertViewDelegate>{
        CustomWindow *customWindow;
}


@property NSString* kind_id;
@property NSMutableArray* mList,*fansList;
@property int pm;

@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property NSTimer* timer;

@property (retain, nonatomic) IBOutlet UITableView *fansTableView;

@property NSDictionary* theData;

@end
