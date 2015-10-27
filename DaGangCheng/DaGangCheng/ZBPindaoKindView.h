//
//  ZYPindaoKindView.h
//  ZYExplore
//
//  Created by huaxo2 on 15/5/14.
//  Copyright (c) 2015年 opencom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "Pindao.h"
@class ZBPindaoKindView;

@protocol ZBPindaoKindViewDelegate <NSObject>

@optional
//- (void)pindaoKindView:(ZBPindaoKindView *)pindaoKindView class_id:(NSString *)class_id;
- (void)pindaoKindView:(ZBPindaoKindView *)pindaoKindView class_id:(NSString *)class_id index:(NSInteger)index;
- (void)pindaoKindView:(ZBPindaoKindView *)pindaoKindView didSelectedPindao:(Pindao *)pindao;
@end

@interface ZBPindaoKindView : UIView
{
    MJRefreshFooterView *_footer;
}

@property (strong, nonatomic) NSArray *pindaoKinds;           // 频道分类
@property (strong, nonatomic) NSMutableArray *pindaoLists;           // 频道分类下的频道列表
@property (copy, nonatomic) NSString *requestSign;            // 请求标识

@property (weak, nonatomic) id<ZBPindaoKindViewDelegate> delegate;  // 代理

- (void)reloadRightTable;
@end
