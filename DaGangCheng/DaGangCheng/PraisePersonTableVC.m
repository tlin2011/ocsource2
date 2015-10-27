//
//  PraisePersonTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-19.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PraisePersonTableVC.h"
#import "RecentlyVisitTableCell.h"
#import "PersonageSlideVC.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "NetRequest.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ApiUrl.h"
#import "CSHistory.h"
#import "Post.h"
#import "ReplyManagerView.h"
#import "Praise.h"
#import "ReportPost.h"
#import "UITableView+separator.h"


@interface PraisePersonTableVC ()<ReplyManagerViewDelegate>
{
    //ApiUrl * url;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
}
@property (atomic, strong) NSMutableArray *dataList;

@property (nonatomic, assign) BOOL isPullDownRefreshing;
@end

@implementation PraisePersonTableVC


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self addHeader];
    [self addFooter];
    
    self.postId = self.postId? self.postId:@"";
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 70, 0, 0);
    //table没数据时,去掉线
    [self.tableView bottomSeparatorHidden];
    
    //[self requestPost];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.dataList.count;
    //return [self.dataList count];
}

#pragma mark - -- 上下拉刷新
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        [self requestPost:refreshView];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    
    _footer = footer;
}

- (void)addHeader
{
    __weak PraisePersonTableVC *vc = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        
        self.isPullDownRefreshing = YES;
        [vc requestPost:refreshView];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        //[vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    
    //未用到
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.tableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

-(void)requestPost:(MJRefreshBaseView *)refreshView
{
    NetRequest * request =[NetRequest new];
    
    NSUInteger begin = self.isPullDownRefreshing ? 0: [self.dataList count];
    NSDictionary * parmeters = @{@"support_id": self.postId,
                                 @"praise_kind": @"1",
                                 @"index":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                 @"size":@"15"
                                 };
    
    [request urlStr:[ApiUrl praiseUserListUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
        if (![customDict[@"ret"] integerValue]) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            if (customDict[@"not_have"] && [customDict[@"not_have"] intValue] == 1) {
                [refreshView noHaveMoreData];
                return ;
            }
            [refreshView loadingDataFail];
            return ;
        }
        [refreshView endRefreshing];
        if (self.isPullDownRefreshing) [self.dataList removeAllObjects];
        self.isPullDownRefreshing = NO;
        self.dataList = !self.dataList || [self.dataList count]<=0 ? [[NSMutableArray alloc]init]:self.dataList;
        
        NSArray* list = customDict[@"list"];
        
        for(int i=0;i<[list count];i++){
            NSDictionary* data = list[i];
            
            [self.dataList addObject:data];
        }

        [self.tableView reloadData];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecentlyVisitTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentlyVisitTableCell"];
    if (!cell) {
        cell = [[RecentlyVisitTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecentlyVisitTableCell"];
    }
    
    NSDictionary* dataItem =self.dataList[indexPath.row];
    
    cell.name.text =  dataItem[@"name"];
    cell.msgLabel.text  = dataItem[@"title"];
    cell.timeLabel.text = [TimeUtil getFriendlySimpleTime:@([dataItem[@"praise_time"] integerValue])];
    long imageID = [(NSNumber*)dataItem[@"img_id"] integerValue];
    [cell.head sd_setBackgroundImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:100]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm"]];
    
    BOOL is24Inner = [TimeUtil is24Inner: @([dataItem[@"praise_time"] integerValue])];
    UIColor* color = is24Inner ? [UIColor redColor]:[UIColor darkGrayColor];
    [cell.timeLabel setTextColor:color];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataList[indexPath.row];
    NSString *uid =[NSString stringWithFormat:@"%ld",(long)[dic[@"uid"] integerValue]];
    NSString *name = dic[@"name"];
    
    PersonageSlideVC *sc = [[PersonageSlideVC alloc] initWithUserId:uid];
    sc.title = name;
    sc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sc animated:YES];
}

- (void)dealloc {
    [_footer free];
    [_header free];
}

@end

