//
//  ZBTRefreshTableVC.h
//  DaGangCheng
//
//  Created by huaxo on 14-12-22.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
@interface ZBTRefreshTableVC : UITableViewController
{
    //ApiUrl * url;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
}
@property (nonatomic, assign) BOOL isPullDownRefreshing;
- (void)addHeader;
- (void)addFooter;

//上下拉刷新调用
- (void)beginRefreshing:(MJRefreshBaseView *)refreshView;
@end
