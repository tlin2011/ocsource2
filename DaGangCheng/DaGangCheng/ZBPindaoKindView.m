//
//  ZBPindaoKindView.m
//  ZYExplore
//
//  Created by huaxo2 on 15/5/14.
//  Copyright (c) 2015年 opencom. All rights reserved.
//

#import "ZBPindaoKindView.h"
#import "UIView+AdjustFrame.h"
#import "ZBPindaoKindCell.h"
#import "ZBPindaoListCell.h"
#import "UIImage+Color.h"

#define kLeftViewWidth 80
#define kLeftViewRowHeight 48
#define kRightRowHeight 86

@interface ZBPindaoKindView ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) UITableView *leftView;
@property (weak, nonatomic) UITableView *rightView;
@property (assign, nonatomic) NSInteger requestCount;
@property (assign, nonatomic) NSString *currentKindId;

@end

@implementation ZBPindaoKindView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        // 初始化频道分类
        self.pindaoKinds = [NSArray array];
        // 初始化频道列表
        self.pindaoLists = [[NSMutableArray alloc] init];
        
        // 左边列表
        UITableView *leftView = [self setupTableView];
        leftView.rowHeight = kLeftViewRowHeight;
        self.leftView = leftView;
        
        // 右边列表
        UITableView *rightView = [self setupTableView];
        rightView.rowHeight = kRightRowHeight;
        self.rightView = rightView;
        self.rightView.backgroundColor = UIColorFromRGB(0xf7f8f8);
        self.requestCount = 0;
        
        [self addFooter];
        
        [self.rightView setContentInset:UIEdgeInsetsMake(0, 0, 100, 0)];
    }
    return self;
}

#pragma mark - -- 上下拉刷新
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.rightView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        if ([self.delegate respondsToSelector:@selector(pindaoKindView:class_id:index:)]) {
            [self.delegate pindaoKindView:self class_id:self.currentKindId index:self.pindaoLists.count];
        }
        [refreshView performSelector:@selector(endRefreshing) withObject:nil afterDelay:1.5];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    
    _footer = footer;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.leftView.frame = CGRectMake(0, 0, kLeftViewWidth, self.height);
    self.rightView.frame = CGRectMake(kLeftViewWidth, 0, self.width - kLeftViewWidth, self.height);
//    self.rightView.contentInset = self.leftView.contentInset;
}

/**
 *  生成tableView
 */
- (UITableView *)setupTableView
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:tableView];
    return tableView;
}

#pragma mark - tableView数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.leftView]) {
        return self.pindaoKinds.count;
    } else if ([tableView isEqual:self.rightView])
    {
        return self.pindaoLists.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.leftView]) {
        ZBPindaoKindCell *cell = [ZBPindaoKindCell cellWithTableView:tableView];
        cell.pindaoKindName = [self.pindaoKinds[indexPath.row] kindName];
        return cell;
    } else if ([tableView isEqual:self.rightView]){
        ZBPindaoListCell *cell = [ZBPindaoListCell cellWithTableView:tableView];
        cell.pd = self.pindaoLists[indexPath.row];
        return cell;
    }
    return nil;
}

#pragma mark - tableView代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.leftView]) {
        
        self.requestSign = [self.pindaoKinds[indexPath.row] kindId];
        //[self.delegate pindaoKindView:self class_id:[self.pindaoKinds[indexPath.row] kindId]];
        self.currentKindId = [self.pindaoKinds[indexPath.row] kindId];
        
        if ([self.delegate respondsToSelector:@selector(pindaoKindView:class_id:index:)]) {
            [self.delegate pindaoKindView:self class_id:self.currentKindId index:0];
        }
            
    } else {
        Pindao *pd = self.pindaoLists[indexPath.row];
        
        if ([self.delegate respondsToSelector:@selector(pindaoKindView:didSelectedPindao:)]) {
            [self.delegate pindaoKindView:self didSelectedPindao:pd];
        }
    }
}

#pragma mark - 数据源赋值并刷新
- (void)setPindaoKinds:(NSArray *)pindaoKinds
{
    _pindaoKinds = pindaoKinds;
    
    if (!pindaoKinds.count) {
        return;
    }
    [self.leftView reloadData];
    
    if (self.requestCount == 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.leftView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.leftView didSelectRowAtIndexPath:indexPath];
        self.requestCount ++;
    }
}

- (void)reloadRightTable {
    [self.rightView reloadData];
}

- (void)dealloc {
    [_footer free];
}

@end