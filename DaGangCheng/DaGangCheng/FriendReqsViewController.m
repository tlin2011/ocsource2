//
//  FriendReqsViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-15.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "FriendReqsViewController.h"
#import "MyCardViewController.h"
#import "UIImageView+WebCache.h"

@interface FriendReqsViewController ()
{
    //ApiUrl * url;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}
@end

@implementation FriendReqsViewController

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
    [self requestReqs:YES];
}



#pragma mark - -- 上下拉刷新
- (void)addFooter
{
    __unsafe_unretained FriendReqsViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //[vc neRequestData:anyUrlStr];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        
        [vc requestReqs:YES];
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    
    _footer = footer;
}

- (void)addHeader
{
    //[dataArray removeAllObjects];
    __unsafe_unretained FriendReqsViewController *vc = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        self.dataList = nil;
        [vc requestReqs:NO];
        //[vc neRequestData:anyUrlStr];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FriendReqCell";
    FriendReqCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary* dataItem = self.dataList[indexPath.row];
    
    cell.nameLabel.text =  dataItem[@"user_name"];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@",[TimeUtil getFriendlyTime:((NSNumber*)dataItem[@"time"])]];
    long imgID = [(NSNumber*)dataItem[@"tx_id"] integerValue];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl  getImageUrlStrFromID:imgID w:100]] placeholderImage:[UIImage imageNamed:@"nm"]];
    cell.imgView.layer.cornerRadius = 5;
    cell.imgView.layer.masksToBounds= YES;
    int flag = [(NSNumber*)dataItem[@"flag"] intValue];
    NSString* msg =  [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"请求加您为"),(flag==1?GDLocalizedString(@"网友"):GDLocalizedString(@"朋友"))];
    
    cell.msgLabel.text = msg;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath:%ld ",(long)indexPath.row);
    NSDictionary* data = self.dataList[indexPath.row];
    int flag = [(NSNumber*)data[@"flag"] intValue];
    
    if(flag==2)
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"加为朋友") message:GDLocalizedString(@"加为朋友后,可以查看Ta的真实名片信息") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"接受请求"),GDLocalizedString(@"忽略请求"),nil];
        alertView.tag = indexPath.row+100;
        [alertView show];
    }else
    {
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"加为网友") message:GDLocalizedString(@"加为网友后,可以收听对方社区动态") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"接受请求"),GDLocalizedString(@"忽略请求"),nil];
        alertView.tag = indexPath.row+100;
        [alertView show];
    }
}

//alertView代理方法
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag ==2){
        if(buttonIndex == 1)
        {
            UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
            //2.进攻,下一球
            MyCardViewController * next =[board instantiateViewControllerWithIdentifier:@"MyCardViewController"];
            //3.假动作,急停,跳投
            next.title = GDLocalizedString(@"个人名片");
            [self.navigationController pushViewController:next animated:YES];
            [self.navigationController hidesBottomBarWhenPushed];
        }
        return ;
    }
    //加为朋友
    if (buttonIndex ==1)
    {
        [self makeFriend:YES row:alertView.tag-100];
    }
    //切换
    else if ( buttonIndex ==2)
    {
        [self makeFriend:NO row:alertView.tag-100];
    }
}


-(void) makeFriend:(BOOL)check row:(NSInteger)row
{
    //ApiUrl * url =[ ApiUrl new];
    NetRequest * request =[NetRequest new];
    
    NSDictionary* data = self.dataList[row];
    
    NSString* checkStr = check ? @"1":@"2";
    
    NSDictionary * parameters = @{@"uid":[HuaxoUtil getUdidStr],
                                  @"mf_id": data[@"mf_id"],
                                  @"check":checkStr};
    
    FriendReqsViewController* bself = self;
    [request urlStr:[ApiUrl dealMakeFriendReqUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict)
     {
         //NSLog(@"我要看的%@",customDict);
         if([((NSNumber*)customDict[@"not_have_card"]) intValue])
         {
             //double delayInSeconds = 1.0;

             UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"无法加他/她为朋友") message:GDLocalizedString(@"您需要设置个人名片信息,再尝试加对方为朋友") delegate:bself cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"设置名片"),nil];
             alertView.tag = 2;
             [alertView show];
             return ;
         }
         if(![(NSNumber*)customDict[@"ret"] intValue])
         {
             NSString* str = [NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"原因"),customDict[@"msg"]];
             UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"处理好友请求失败") message:str delegate:nil cancelButtonTitle:GDLocalizedString(@"确定") otherButtonTitles:nil];
             [alertView show];
             //NSLog(@"makefriend failed! msg:%@",customDict[@"msg"]);
             //return ;
         }
         else{
             UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"处理好友请求成功") message:@"" delegate:nil cancelButtonTitle:GDLocalizedString(@"确定") otherButtonTitles:nil];
             [alertView show];
         }
         [bself requestReqs:NO];
         [bself.tableView reloadData];
     }];
}


-(void)requestReqs:(BOOL) isFoot
{
    if(!isFoot) self.dataList = nil;
    
    //ApiUrl * url =[ApiUrl new];
    NetRequest * request =[NetRequest new];
    
    NSUInteger begin = [self.dataList  count];
    
    [self dialogShow];
    
    NSDictionary * parameters = @{@"uid":[HuaxoUtil getUdidStr],
                                  @"begin":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                  @"plen":@"20"
                                  };
    __block FriendReqsViewController * blockself = self;
    
    [request urlStr:[ApiUrl getFriendReqsUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        [self dialogDismiss];
        
        NSLog(@"reqs-list:%@",customDict);
        if (!customDict[@"ret"]  ) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            return ;
        }
        self.dataList = !self.dataList || [self.dataList count]<=0 ? [[NSMutableArray alloc]init]:self.dataList;
        
        NSArray* list = customDict[@"list"];
        for(int i=0;i<[list count];i++){
                [self.dataList addObject:list[i]];
        }
        [blockself.tableView reloadData];
    }];
}

//显示加载中对话框
- (void)dialogShow {
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.alpha = 0.6;
    self.progressView.progress = 0;
    self.progressView.hidden = NO;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgressTime) userInfo:nil repeats:YES];
}

-(void)updateProgressTime
{
    if(self.progressView.progress > 0.9)
        self.progressView.progress += 0.001;
    else
        self.progressView.progress += 0.001;
}

-(void)endProgressTime
{
    self.progressView.progress += 0.1;
    if(self.progressView.progress>=1.f)
    {
        if(self.timer && self.timer.isValid)
            [self.timer invalidate];
        
        self.progressView.hidden = YES;
    }
}
//取消对话框显示
- (void) dialogDismiss{
    if(self.timer && self.timer.isValid)
        [self.timer invalidate];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(endProgressTime) userInfo:nil repeats:YES];
}

- (void)dealloc {
    [_footer free];
    [_header free];
}

@end
