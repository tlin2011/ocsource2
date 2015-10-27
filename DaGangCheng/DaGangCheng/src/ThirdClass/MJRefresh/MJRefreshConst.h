//
//  MJRefreshConst.h
//  MJRefresh
//
//  Created by mj on 14-1-3.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#ifdef DEBUG
#define MJLog(...) NSLog(__VA_ARGS__)
#else
#define MJLog(...)
#endif

// 文字颜色
#define MJRefreshLabelTextColor [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0]

extern const CGFloat MJRefreshViewHeight;
extern const CGFloat MJRefreshAnimationDuration;

extern NSString *const MJRefreshBundleName;
#define kSrcName(file) [MJRefreshBundleName stringByAppendingPathComponent:file]

#define MJRefreshFooterPullToRefresh GDLocalizedString(@"上拉加载更多")
//extern NSString *const MJRefreshFooterPullToRefresh;
#define MJRefreshFooterReleaseToRefresh GDLocalizedString(@"释放更新")
//extern NSString *const MJRefreshFooterReleaseToRefresh;
#define MJRefreshFooterRefreshing GDLocalizedString(@"加载中...")
//extern NSString *const MJRefreshFooterRefreshing;

#define MJRefreshHeaderPullToRefresh GDLocalizedString(@"下拉刷新")
//extern NSString *const MJRefreshHeaderPullToRefresh;
#define MJRefreshHeaderReleaseToRefresh GDLocalizedString(@"释放更新")
//extern NSString *const MJRefreshHeaderReleaseToRefresh;
#define MJRefreshHeaderRefreshing GDLocalizedString(@"加载中...")
//extern NSString *const MJRefreshHeaderRefreshing;
extern NSString *const MJRefreshHeaderTimeKey;

extern NSString *const MJRefreshContentOffset;
extern NSString *const MJRefreshContentSize;