//
//  MyCollectionTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-8.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "MyCollectionTableVC.h"
#import "MyCollectionTableCell.h"
#import "NetRequest.h"
#import "HuaxoUtil.h"
#import "TimeUtil.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "Post.h"
#import "PersonageSlideVC.h"
#import "UITableView+separator.h"

#import "ZBPostJumpTool.h"

@interface MyCollectionTableVC ()
{
    //ApiUrl * url;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
}
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) BOOL isPullDownRefreshing;
@end

@implementation MyCollectionTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 73, 0, 0);
    
    [self addHeader];
    [self addFooter];
    
    //table没数据时,去掉线
    [self.tableView bottomSeparatorHidden];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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
    __weak MyCollectionTableVC *vc = self;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[MyCollectionTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSDictionary *dic = self.dataList[indexPath.row];
    cell.name.text =  dic[@"owner_name"];
    cell.msgLabel.text = dic[@"subject"];
    // NSLog(@"msg-time:%@ class:%@",dataItem.data[@"time"],((NSObject*)dataItem.data[@"time"]).class);
    cell.timeLabel.text= [TimeUtil getFriendlySimpleTime:((NSNumber*)dic[@"create_time"])];
    BOOL is24Inner = [TimeUtil is24Inner: (dic[@"create_time"])];
    UIColor* color = is24Inner ? [UIColor redColor]:[UIColor darkGrayColor];
    [cell.timeLabel setTextColor:color];
    
    long imageID = [(NSNumber *)dic[@"img_id"] integerValue];
    [cell.head sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:100]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm"]];
    cell.head.tag = [dic[@"uid"] integerValue];
    [cell.head addTarget:self action:@selector(txClicked:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataList[indexPath.row];
    NSString *pindaoId = [NSString stringWithFormat:@"%@",dic[@"post_id"]];
    [ZBPostJumpTool intoPage:pindaoId withIndex:indexPath.row delegate:nil vc:self urlStr:dic[@"url"]];
}

-(void)txClicked:(UIView*)sender
{
    NSString* uid = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    PersonageSlideVC *sc = [[PersonageSlideVC alloc] initWithUserId:uid];
    sc.title = GDLocalizedString(@"个人主页");
    sc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sc animated:YES];
}


-(void)requestPost:(MJRefreshBaseView *)refreshView
{
    //ApiUrl * url =[ApiUrl new];
    NetRequest * request =[NetRequest new];
    
    NSUInteger begin = self.isPullDownRefreshing ? 0: [self.dataList count];
    
    NSDictionary * parameters = @{@"uid":
                                      [HuaxoUtil getUdidStr],
                                  @"op": @"0",
                                  @"act_kind": @"1",
                                  @"index":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                  @"size":@"20"
                                  };
    
    [request urlStr:[ApiUrl myCollectionUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        NSLog(@"posts-list:%@",customDict);
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
            NSDictionary *json = list[i];
            [self.dataList addObject:json];
        }
        [self.tableView reloadData];
    }];

}


@end
