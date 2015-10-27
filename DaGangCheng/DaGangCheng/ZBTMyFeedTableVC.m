//
//  ZBTMyFeedTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-9-19.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ZBTMyFeedTableVC.h"

@interface ZBTMyFeedTableVC ()
{
    //ApiUrl * url;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}
@property (nonatomic, assign) BOOL isPullDownRefreshing;
@end

@implementation ZBTMyFeedTableVC

@synthesize dataArray;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
	// Do any additional setup after loading the view.
    
    // 3.1.下拉刷新
    [self addHeader];
    // 3.2.上拉加载更多
    [self addFooter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - -- 上下拉刷新
- (void)addFooter
{
    __block ZBTMyFeedTableVC *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //[vc neRequestData:anyUrlStr];
        NSLog(@"我想知道有没有");
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        
        [vc requestFeeds:YES refreshView:refreshView];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}

- (void)addHeader
{
    //[dataArray removeAllObjects];
    __block ZBTMyFeedTableVC *vc = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        
        self.isPullDownRefreshing = YES;
        
        [vc requestFeeds:YES refreshView:refreshView];

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    NSDictionary* dataItem =dataArray[indexPath.row];
    MyFeedsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"myFeedsCell" forIndexPath:indexPath];
    cell.name.text =  dataItem[@"user_name"];
    cell.msgLabel.text  = dataItem[@"title"];
    cell.timeLabel.text = [TimeUtil getFriendlySimpleTime:((NSNumber*)dataItem[@"save_time"])];
    long imageID = [(NSNumber*)dataItem[@"tx_id"] integerValue];
    [cell.head sd_setBackgroundImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:100]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm"]];

    BOOL is24Inner = [TimeUtil is24Inner: ((NSNumber*)dataItem[@"save_time"])];
    UIColor* color = is24Inner ? [UIColor redColor]:[UIColor darkGrayColor];
    [cell.timeLabel setTextColor:color];
    return cell;
}

//控制高度.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [dataArray count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* data = dataArray[indexPath.row];
    
    PostViewController * next =[[PostViewController alloc] init];
    next.postID =  [NSString stringWithFormat:@"%@",[CSPortalParser getPostIdFromCSStr:data[@"cs"]]];
    //[self.navigationController pu]
    [self.navigationController pushViewController:next animated:YES];
    
    [self.tableView reloadData];
}
-(void)requestFeeds:(BOOL) isFoot refreshView:(MJRefreshBaseView *)refreshView
{
    if ([self.anyFeedStr isEqualToString:@"me"] || [self.anyFeedStr isEqualToString:@"friend"] || [self.anyFeedStr isEqualToString:@"all"]) {
    }else {
        return;
    }
    
    NetRequest * request =[NetRequest new];
    BOOL logined = [HuaxoUtil isLogined];
    NSUInteger begin = !self.isPullDownRefreshing ? [dataArray count]:0;
    NSUInteger len = [dataArray count];
    long last = !self.isPullDownRefreshing && len>0 ?[((NSNumber*)dataArray[len-1][@"feed_id"]) integerValue ]:NSIntegerMax;
    long news = self.isPullDownRefreshing && len>0 ? [((NSNumber*)dataArray[0][@"feed_id"]) integerValue]:0;
    NSDictionary * parameters = @{@"uid": [HuaxoUtil getUdidStr],
                                  @"begin":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                  @"plen":@"20",
                                  @"logined":logined?@"yes":@"no",
                                  @"k":self.anyFeedStr,
                                  @"kind":isFoot?@"last":@"news",
                                  @"last":[NSString stringWithFormat:@"%ld",last],
                                  @"news":[NSString stringWithFormat:@"%ld",news]
                                  };
    int pos = 0;
    if ([self.anyFeedStr isEqualToString:@"me"]) {
        pos = 0;
    } else if ([self.anyFeedStr isEqualToString:@"friend"]) {
        pos = 1;
    } else if ([self.anyFeedStr isEqualToString:@"all"]) {
        pos = 2;
    }
    [request urlStr:[ApiUrl myFeedsUrlStr:pos] parameters:parameters passBlock:^(NSDictionary *customDict) {

        if (![customDict[@"ret"] integerValue]  ) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            if (customDict[@"not_have"] && [customDict[@"not_have"] intValue] == 1) {
                [refreshView noHaveMoreData];
                return ;
            }
            [refreshView loadingDataFail];
            return ;
        }
        [refreshView endRefreshing];
        if (self.isPullDownRefreshing) [dataArray removeAllObjects];
        self.isPullDownRefreshing = NO;
        
        if (!dataArray && dataArray.count<1) {
            dataArray = [[NSMutableArray alloc] init];
        }
        [dataArray addObjectsFromArray:customDict[@"list"]];
        
        [self.tableView reloadData];
    }];
}

- (void)dealloc {
    NSLog(@"MyFeedsTableVC dealloc");
    [_footer free];
    [_header free];
}

@end
