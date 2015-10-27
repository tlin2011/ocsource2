//
//  FriendViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "FriendViewController.h"
#import "PersonageSlideVC.h"
#import "UITableView+separator.h"


@interface FriendViewController ()
{
    NSMutableDictionary *msgDic;
    
}

@property (nonatomic, strong) NSMutableDictionary *reqsDic;
@property (nonatomic, strong) NSMutableDictionary *goodFriendDic;
@property (nonatomic, strong) NSMutableDictionary *netFriendDic;

@end

@implementation FriendViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.gfCnt = self.nfCnt = self.ufCnt = 0;
    }
    return self;
}

-(void) initData
{
    self.dataArray = [[NSMutableArray alloc] init];
    
    self.reqsDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"title":GDLocalizedString(@"好友请求"),@"img":@"dgc_friend_req.png",@"desc":GDLocalizedString(@"处理好友请求")}];
    [self.dataArray addObject:[[FriendDataItem alloc] initWithData:self.reqsDic dataFlag:FUNC_CELL]];
    
    self.goodFriendDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"title":GDLocalizedString(@"朋友")}];
    [self.dataArray addObject:[[FriendDataItem alloc] initWithData:self.goodFriendDic dataFlag:TAB_CELL showFlag:NO]];
    
    self.netFriendDic = [[NSMutableDictionary alloc] initWithDictionary:@{@"title":GDLocalizedString(@"网友")}];
    [self.dataArray addObject:[[FriendDataItem alloc] initWithData:self.netFriendDic dataFlag:TAB_CELL showFlag:NO]];
    
    [self.dataArray addObject:[[FriendDataItem alloc] initWithData:[[NSMutableDictionary alloc] initWithDictionary:@{@"title":GDLocalizedString(@"陌生人")}] dataFlag:TAB_CELL showFlag:NO]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    
    [self initData];
    
    [self dialogShow];
    [self dialogDismiss];
    
    [self.tableView reloadData];
    
    //self.navigationController.tabBarItem.badgeValue = @"new";
    
    [self.tableView bottomSeparatorHidden];
    [self addLisenter];
    [self addLoginStatusLisenter];
    
    [self processUserNews:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}

-(void) addLisenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processUserNews:) name:[NotifyCenter userNotifyKey] object:nil];
    
}
-(void)processUserNews:(NSNotification*) aNotification
{
    NSDictionary* newsDic = aNotification.userInfo;
    NSLog(@"into processUserNews:%@",newsDic);
    //请求
    if([(NSNumber*)newsDic[@"freq_cnt"] intValue]){
        self.reqsDic[@"news"] = newsDic[@"freq_cnt"];
    }
    //新消息
    if([(NSNumber*)newsDic[@"umsg_new"] intValue]){
        msgDic[@"news"] = newsDic[@"umsg_new"];
    }
    //新朋友\网友等
    if([(NSNumber*)newsDic[@"gf_new"] intValue]){
        self.goodFriendDic[@"news"] = newsDic[@"gf_new"];
    }
    if([(NSNumber*)newsDic[@"nf_new"] intValue]){
        self.netFriendDic[@"news"] = newsDic[@"nf_new"];
    }
    int fCnt = [(NSNumber*)newsDic[@"feed_cnt"] intValue]+[(NSNumber*)newsDic[@"freq_cnt"] intValue]+[(NSNumber*)newsDic[@"umsg_new"] intValue]+[(NSNumber*)newsDic[@"gf_new"] intValue]+[(NSNumber*)newsDic[@"nf_new"] intValue];
    
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:fCnt];
    //number为显示在ICON上的整数
    //UITabBar
    if(fCnt>0)
        [self.navigationController.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%d",fCnt]];
    else
        self.navigationController.tabBarItem.badgeValue = nil;
    [self.tableView reloadData];
}


-(void) addLoginStatusLisenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processUserLoginStatus:) name:[NotifyCenter userLoginStatusKey] object:nil];
}
-(void)processUserLoginStatus:(NSNotification*) aNotification
{
    [self initData];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    const NSArray* cellKinds = [NSArray arrayWithObjects:@"funcitem",@"friendTabItem",@"friendMsgItem",@"friendItemCell",nil];
    
    // Configure the cell...
    FriendDataItem* dataItem =self.dataArray[indexPath.row];
    BOOL hasNews =  [(NSNumber*)dataItem.data[@"news"] intValue];
    NSLog(@"hasNews:%d  data[news]:%@",hasNews,dataItem.data[@"news"]);
    
    //NSLog(@"row:%d kinds:%@ data:%@",indexPath.row,cellKinds[dataItem.flag],dataItem.data);
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellKinds[dataItem.flag]forIndexPath:indexPath];
    
    if(dataItem.flag == FUNC_CELL){//功能模块
        FriendFuncItemCell* item = (FriendFuncItemCell* )cell;
        item.tipsLabel.text = dataItem.data[@"title"];
        item.descText.text = dataItem.data[@"desc"];
        [item.imgView setImage:[UIImage imageNamed:dataItem.data[@"img"]]];
        item.newsTips.hidden = !hasNews;
        
        //return item;
    }else if(dataItem.flag == TAB_CELL){//TAB模块
        FriendTabCell* item = (FriendTabCell* )cell;
        item.label.text =  dataItem.data[@"title"];
        
        if(dataItem.showFlag){
            item.arrowImg.frame = CGRectMake(12, 17, 9, 11);
            [item.arrowImg setImage:[UIImage imageNamed:@"展开_通讯录.png"]];
        }else{
            item.arrowImg.frame = CGRectMake(11, 19, 11, 9);
            [item.arrowImg setImage:[UIImage imageNamed:@"收缩_通讯录.png"]];
        }
        item.newsTips.hidden = !hasNews;
        //return item;
    }else if(dataItem.flag == MSG_CELL){//消息模块
        FriendMsgCell* item = (FriendMsgCell* )cell;
        item.titleLabel.text =  dataItem.data[@"name"];
        item.msgLabel.text = dataItem.data[@"msg"];
        // NSLog(@"msg-time:%@ class:%@",dataItem.data[@"time"],((NSObject*)dataItem.data[@"time"]).class);
        item.timeLabel.text= [TimeUtil getFriendlySimpleTime:((NSNumber*)dataItem.data[@"time"])];
        BOOL is24Inner = [TimeUtil is24Inner: ((NSNumber*)dataItem.data[@"time"])];
        UIColor* color = is24Inner ? [UIColor redColor]:[UIColor darkGrayColor];
        [item.timeLabel setTextColor:color];
        
        long imgID = [(NSNumber*)dataItem.data[@"tx_id"] integerValue];
        [item.imgView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imgID w:100]] placeholderImage:[UIImage imageNamed:@"nm"]];
        item.imgView.layer.masksToBounds = YES;
        item.imgView.layer.cornerRadius  = 5;
        
        if([(NSNumber*)dataItem.data[@"msg_new"] intValue]){
            NSString* name  =dataItem.data[@"name"];
            NSString* str =[NSString stringWithFormat:@"%@(new)",name];
            NSMutableAttributedString *colorStr =  [[NSMutableAttributedString alloc] initWithString:str];
            //0 0.478431 1 1
            [colorStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] range:NSMakeRange(name.length,5)];
            item.titleLabel.text = str;
            item.titleLabel.attributedText=colorStr;
        }
        //return item;
    }
    else if(dataItem.flag == FRIEND_CELL){//朋友模块
        FriendItemCell* item = (FriendItemCell* )cell;
        item.titleLabel.text =  dataItem.data[@"name"];
        item.descLabel.text  =   [NSString stringWithFormat:@"%@UID:%d",GDLocalizedString(@"用户"),[(NSNumber*)dataItem.data[@"uid"] intValue]];
        long imgID = [(NSNumber*)dataItem.data[@"tx_id"] integerValue];
        [item.imgView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imgID w:100]] placeholderImage:[UIImage imageNamed:@"nm"]];
        //[item.imgView setImage:[UIImage imageNamed:dataItem.data[@"img"]]];

        if(![dataItem.data[@"nf_new"] isKindOfClass:[NSNull class]] || ![dataItem.data[@"gf_new"] isKindOfClass:[NSNull class]])
        {
            NSString* name  =dataItem.data[@"name"];
            NSString* str =[NSString stringWithFormat:@"%@(new)",name];
            NSMutableAttributedString *colorStr =  [[NSMutableAttributedString alloc] initWithString:str];
            //0 0.478431 1 1
            [colorStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] range:NSMakeRange(name.length,5)];
            item.titleLabel.text = str;
            item.titleLabel.attributedText=colorStr;
        }
    }
    
    CGFloat height = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
    CGRect tmpRect = cell.frame;
    cell.frame = CGRectMake(0, 0, tmpRect.size.width, height);
    cell.hidden = !height;
    NSLog(@"cell-row:%ld height:%f",(long)indexPath.row, height);
    return cell;
}

//控制高度.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendDataItem* dataItem =self.dataArray[indexPath.row];
    CGFloat height = 0;
    if(dataItem.showFlag || dataItem.flag ==TAB_CELL){//TAB_CELL必定显示
        switch (dataItem.flag) {
            case FUNC_CELL://0
                height= 53;
                break;
            case TAB_CELL://1
                height= 45;
                break;
            case MSG_CELL://2
                height= 48;
                break;
            case FRIEND_CELL: //3
                height= 70;
                break;
            default:
                height= 0;
                break;
        }
    }else
    {
        height= 0;
    }
    //UIView* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    //cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, height);
    NSLog(@"getCellHeight:%f count:%ld showFlag:%d  dataItem.flag:%d",height,(unsigned long)[self.dataArray count],dataItem.showFlag,dataItem.flag);
    return height;
}

#define plen 50
-(void)request:(int) kind begin:(int)pos
{
    
    if((kind==0 && pos<self.gfCnt) || (kind==1 && pos<self.nfCnt) ||
       (kind==2 && pos<self.ufCnt) || (kind==3 && pos<self.msgCnt))
        return ;
    
    NSLog(@"into request:%d pos:%d,gfCnt:%d,nfCnt:%d,ufCnt:%d",kind,pos,self.gfCnt,self.nfCnt,self.ufCnt);
    //ApiUrl * url =[ApiUrl new];
    NetRequest * request =[NetRequest new];
    
    NSDictionary * parameters = @{@"uid":
                                      [HuaxoUtil getUdidStr],
                                  @"begin": [NSNumber numberWithInt:pos],
                                  @"len": @plen,
                                  @"plen":@plen
                                  };
    
    [request urlStr:[ApiUrl friendListUrlStr:kind] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        if([(NSNumber*)[customDict objectForKey:@"ret"] intValue]){
            NSArray* list = [customDict objectForKey:@"list"];
            
            if(kind ==0)
                self.gfCnt += [list count];
            else if(kind==1)
                self.nfCnt += [list count];
            else if(kind==2) self.ufCnt+= [list count];
            else if(kind==3) self.msgCnt+= [list count];
            //处理得到的结果.
            [self processResult:kind begin:pos list:list];
        }else{
            NSLog(@"空");
        }
    }];
}
-(void)processResult:(int)kind begin:(int)pos list:(NSArray*) array
{
    NSString* kindStr = kind==0 ? GDLocalizedString(@"朋友"):(kind==1 ? GDLocalizedString(@"网友") :(kind==2?GDLocalizedString(@"陌生人"):GDLocalizedString(@"最近联系")));
    for(int i=0;i<[self.dataArray count];i++)
    {
        FriendDataItem* item = self.dataArray[i];
        if(item.flag == TAB_CELL && [(NSString*)item.data[@"title"] compare:kindStr] == NSOrderedSame){
            BOOL showFlag  = item.showFlag;
            for(int j=0;j<[array count];j++){
                FriendDataItem* item = [[FriendDataItem alloc] initWithData:array[j] dataFlag:(kind!=3?FRIEND_CELL:MSG_CELL)  showFlag:showFlag];
                [self.dataArray insertObject:item atIndex:i+1+j];
            }
            break;
        }
    }
    
    [self.tableView reloadData];
}

-(int)getFriendUrlKind:(NSString*)title
{
    if([title compare:GDLocalizedString(@"最近联系")]== NSOrderedSame)
        return 3;
    int kind = [title compare:GDLocalizedString(@"朋友")]==NSOrderedSame?0:( [title compare:GDLocalizedString(@"网友")]==NSOrderedSame?1:2);
    return kind;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendDataItem* data =(FriendDataItem*)(self.dataArray[indexPath.row]);
    int kind  =data.flag;
    NSString* title = data.data[@"title"];
    switch (kind) {
        case TAB_CELL:
            data.showFlag  = !data.showFlag;
            BOOL showFlag = data.showFlag;
            NSUInteger len = [self.dataArray count];
            for(NSUInteger i=indexPath.row+1;i<len ;i++)
            {
                FriendDataItem* data =(FriendDataItem*)(self.dataArray[i]);
                if(data.flag == TAB_CELL){
                    break;
                }else{
                    data.showFlag = showFlag;//是否显示.
                }
            }
            if(showFlag){
                //NSString* title = data.data[@"title"];
                int kind = [self getFriendUrlKind:title];
                if(kind<0) break;//处理失败
                //if(!getDataAll[kind])
                [self request:kind begin:0];
                //else
                //   getDataAll[kind] = YES;
                //[self request:1 begin:0];
                //[self request:2 begin:0];
            }
            if(showFlag)
            {
                data.data[@"news"] =  [NSNumber numberWithBool:NO];
            }
            break;
        case FUNC_CELL:
            if( [title compare:GDLocalizedString(@"好友请求")]==NSOrderedSame)
            {
                [self intoFriendReq];
            }
            data.data[@"news"] = [NSNumber numberWithBool:NO];
            break;
        case MSG_CELL:
            [self intoMsgUser:[NSString stringWithFormat:@"%@", data.data[@"uid"] ] userName:data.data[@"name"]];
            break;
        case FRIEND_CELL:
            [self intoUserPage:data.data[@"uid"]];
            break;
        default:
            break;
    }
    [self.tableView reloadData];
    [self.tableView setNeedsDisplay];
}
-(void)intoUserPage:(NSNumber*) uid
{
    PersonageSlideVC *sc = [[PersonageSlideVC alloc] initWithUserId:[NSString stringWithFormat:@"%@",uid]];
    sc.title = GDLocalizedString(@"个人主页");
    sc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sc animated:YES];
}

-(void)intoMsgUser:(NSString*)toUid userName:(NSString*) name{

    MyMsgViewController * next =[[MyMsgViewController alloc] init];
    next.title = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"私信"),name];
    next.to_name= name;
    next.to_uid = toUid;
    
    [self.navigationController pushViewController:next animated:YES];
}

-(void)intoFriendReq
{
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //2.进攻,下一球
    FriendReqsViewController * next =[board instantiateViewControllerWithIdentifier:@"FriendReqsViewController"];
    next.title = GDLocalizedString(@"好友请求");
    
    [self.navigationController pushViewController:next animated:YES];
}

//显示加载中对话框
- (void)dialogShow {
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.alpha = 0.6;
    self.progressView.progress = 0;
    self.progressView.hidden = NO;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgressTime1) userInfo:nil repeats:YES];
}


-(void)updateProgressTime1
{
    if(self.progressView.progress>0.9)
        self.progressView.progress += 0.001;
    else
        self.progressView.progress += 0.001;
}

-(void)endProgressTime1
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
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(endProgressTime1) userInfo:nil repeats:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"FriendViewController delloc");
}

@end
