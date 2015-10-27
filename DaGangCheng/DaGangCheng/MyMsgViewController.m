//
//  MyMsgViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-14.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "MyMsgViewController.h"
#import "PersonageSlideVC.h"
#import "ZBPostJumpTool.h"
#import "NewLoginContoller.h"

#define ZBChatContentWidth (DeviceWidth - 35 - 105)

@interface MyMsgViewController ()
{
    //ApiUrl * url;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    BOOL isLoading;
    NSMutableDictionary* msgHeightDic;
    int nowCnt;
    
    //fred
    BOOL isRestart;
}
@end

@implementation MyMsgViewController

- (void)viewDidLoad
{
    [super viewDidLoad];    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    msgHeightDic = [[NSMutableDictionary alloc] initWithCapacity:20];
    // Custom initialization
    SQLDataBase * sql = [SQLDataBase new];
    self.ibg_udid = [HuaxoUtil getUdidStr];
    self.my_name = [sql queryWithCondition:@"user_name"];
    self.my_txid = [[sql queryWithCondition:@"img_id"] integerValue];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];

    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    
    [self.tableView registerClass:[MyMsgLeftCell class] forCellReuseIdentifier:@"MyMsgLeftCell"];
    [self.tableView registerClass:[MyMsgRightCell class] forCellReuseIdentifier:@"MyMsgRightCell"];

    
    //[self addFooter];
    [self addHeader];
    [self showMsgBoxView];
    
    //新消息通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestMessage:) name:[NotifyCenter userNotifyKey] object:nil];
    
    if (![HuaxoUtil isLogined]) {
//        [LoginViewController tologinWithVC:self];
         [NewLoginContoller tologinWithVC:self];
        return;
    }
}

- (void)requestMessage:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;
    
    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"umsg_new"] integerValue]>0) {
        isRestart = YES;
        [self requestMsg];
    }
    
}

-(void)showMsgBoxView
{
    if (!self.boxView) {
        CGRect frame = self.view.frame;
        self.boxView = self.boxView = [[MsgBoxView alloc] initWithFrame:CGRectMake(0, frame.size.height-44, frame.size.width, 44)];
    }
    self.boxView.postId = @"000001";
    self.boxView.delegate = self;
    self.boxView.msgDelegate = self;
    self.boxView.toUid = self.to_uid;
    self.boxView.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [self.view addSubview:self.boxView];
    [self.view bringSubviewToFront:self.boxView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - -- 上下拉刷新
- (void)addFooter
{
    __unsafe_unretained MyMsgViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //[vc neRequestData:anyUrlStr];
        NSLog(@"我想知道有没有");
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        
        [vc requestMsg];
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    
    _footer = footer;
}

- (void)addHeader
{
    //[dataArray removeAllObjects];
    __unsafe_unretained MyMsgViewController *vc = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        //self.dataList = nil;
        [vc requestMsg];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

-(void)sendMsgSuccess:(NSNumber*)msgid msg:(NSString*)msg
{
    NSLog(@"into subReplySuccess!");
    SQLDataBase * sql = [[SQLDataBase alloc]init];
    if([self.dataList count]<=0)
    {
        self.dataList = nil;
        [self requestMsg];
    }
    else{
        NSDictionary* dic = @{@"uid":self.ibg_udid,@"msg":msg,@"msg_id":msgid,@"tx_id":[sql queryWithCondition:@"img_id"],@"time":[NSNumber numberWithLong:[TimeUtil getCurrentTimestamp]]};

        [self addJsonToDataList:dic];

        [self.tableView reloadData];
        [self gotoRow:([self.dataList count]-1) section:0 bottom:YES animated:NO];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //const NSArray* cellIds = @[@"leftMsgCell",@"rightMsgCell"];
    
    ZBChat* chat = self.dataList[indexPath.row];

    BOOL isMyMsg = (chat.uid == [self.ibg_udid integerValue]);
    
    if(isMyMsg){
        MyMsgLeftCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyMsgLeftCell"forIndexPath:indexPath];
        
        cell.chat = chat;
        [cell updateUI];
        
        //去掉cell点击效果
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else{
        MyMsgRightCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyMsgRightCell" forIndexPath:indexPath];
        
        cell.chat = chat;
        [cell updateUI];
        
        //去掉cell点击效果
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
}

//控制高度.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZBChat *chat = self.dataList[indexPath.row];
    return [MyMsgLeftCell heightFromChat:chat]; //leftCell 和 rightCell 计算高度是一样的。
}

-(void) requestMsg
{
    if(isLoading)
        return;
    isLoading = YES;

    NetRequest * request =[NetRequest new];
    NSUInteger begin =  isRestart? 0:[self.dataList count];
    
    NSDictionary * parameters = @{@"uid":self.ibg_udid,
                                  @"to_uid":self.to_uid,
                                  @"begin":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                  @"plen":@"10"};
    __block MyMsgViewController * blockself = self;
    [request urlStr:[ApiUrl getMsgsUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        isLoading = NO;
        //NSLog(@"user-msg-list:%@",customDict);
        if (!customDict[@"ret"]  ) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            return ;
        }
        if (isRestart == YES) {
            self.dataList = nil;
            isRestart = NO;
        }
        self.dataList = !self.dataList || [self.dataList count]<=0 ? [[NSMutableArray alloc]init]:self.dataList;
        
        NSArray* list = customDict[@"list"];
        //
        [self insertListToDataList:list];
        
        [blockself.tableView reloadData];
        if([self.dataList count]<=10 && ![(NSNumber*)customDict[@"not_have"] intValue] ){
            
            [self performSelector:@selector(gotoBottom) withObject:self afterDelay:1];
        }
        
        [_header endRefreshing];
    }];
}

- (void)insertListToDataList:(NSArray *)inArr {
    
    for (int i=0; i<[inArr count]; i++) {
        NSDictionary *json = inArr[i];
        if ([json isKindOfClass:[NSDictionary class]]) {
            
            ZBChat *chat = [ZBChat chatFromJson:json];
            
            //预处理数据
            NSArray *regularMatchArray = [ZBCoreTextRegularMatch arrayFromString:chat.msg];
            
            regularMatchArray = [ZBCoreTextGetSize regularMatchArrayHadHeightFromRegularMatchArray:regularMatchArray imageWHs:[ZBCoreTextGetSize coreTextImageHWsFromServerImageWHs:chat.imageWHs] font:[UIFont systemFontOfSize:17] lineSpace:6 width:ZBChatContentWidth];
            chat.regularMatchArray = regularMatchArray;
            
            CGRect chatRect = CGRectZero;
            chatRect.size.width = ZBChatContentWidth;
            chatRect.size.height = [ZBCoreTextView heightFromRegularMatchArray:chat.regularMatchArray];
            chat.rect = chatRect;
            
            [self.dataList insertObject:chat atIndex:0];
        }
    }
}

- (void)addJsonToDataList:(NSDictionary *)json {
    

    if ([json isKindOfClass:[NSDictionary class]]) {
        
        ZBChat *chat = [ZBChat chatFromJson:json];
        
        //预处理数据
        NSArray *regularMatchArray = [ZBCoreTextRegularMatch arrayFromString:chat.msg];
        
        regularMatchArray = [ZBCoreTextGetSize regularMatchArrayHadHeightFromRegularMatchArray:regularMatchArray imageWHs:[ZBCoreTextGetSize coreTextImageHWsFromServerImageWHs:chat.imageWHs] font:[UIFont systemFontOfSize:17] lineSpace:6 width:ZBChatContentWidth];
        chat.regularMatchArray = regularMatchArray;
        
        CGRect chatRect = CGRectZero;
        chatRect.size.width = ZBChatContentWidth;
        chatRect.size.height = [ZBCoreTextView heightFromRegularMatchArray:chat.regularMatchArray];
        chat.rect = chatRect;
        
        if (!self.dataList) {
            self.dataList = [[NSMutableArray alloc] init];
        }
        [self.dataList addObject:chat];
    }

}

-(void)gotoRow:(NSInteger)row section:(NSInteger)section bottom:(BOOL)bottom animated:(BOOL) flag
{
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:section];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:bottom?UITableViewScrollPositionBottom:UITableViewScrollPositionTop animated:flag];
}
-(void)gotoBottom
{
    if([self.dataList count]<=0) return ;
    [self gotoRow:self.dataList.count-1 section:0 bottom:YES animated:NO];
}

-(void)intoUserPage:(NSString*) uid
{
    PersonageSlideVC *sc = [[PersonageSlideVC alloc] initWithUserId:uid];
    sc.title = GDLocalizedString(@"个人主页");
    sc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sc animated:YES];
}

//滑动收起键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.boxView.inputTV resignFirstResponder];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_footer free];
    [_header free];
}

- (void)back:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
