//
//  SearchUserViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-28.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommHead.h"
#import "SearchUserCell.h"

@interface SearchUserViewController : UITableViewController<UISearchBarDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property NSMutableArray* dataList;

@property NSString* kind_id2;

@property NSDictionary* data2;

@end
