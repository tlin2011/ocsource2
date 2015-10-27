//
//  SearchTableViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-3.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UITableViewController<UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *oneSearchBar;
@end
