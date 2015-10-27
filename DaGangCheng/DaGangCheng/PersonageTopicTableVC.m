//
//  PersonageTopicTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PersonageTopicTableVC.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "NetRequest.h"
#import "PindaoHomeNewsCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ApiUrl.h"
#import "CSHistory.h"
#import "Post.h"
#import "ReplyManagerView.h"
#import "Praise.h"
#import "ReportPost.h"
#import "AddFriendView.h"
#import "ZBPraise.h"
#import "ZBCollection.h"

#import "ZBPostJumpTool.h"

@interface PersonageTopicTableVC ()<ReplyManagerViewDelegate>

@property (atomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger selectedRow;

@property (nonatomic, strong) ReportPost *report;

@end

@implementation PersonageTopicTableVC


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
    [super viewDidLoad];
    [self addHeader];
    [self addFooter];
    
    self.pindaoId = self.pindaoId? self.pindaoId:@"";

    //[self requestPost:nil];
    
    //添加加为好友试图
    CGRect friendFrame = CGRectMake(0, 0, DeviceWidth, 0);
    AddFriendView *friendView = [[AddFriendView alloc] initWithFrame:friendFrame andUserId:self.userId];
    friendView.userId = self.userId;
    friendView.delegate = self;
    [self.tableView setTableHeaderView:friendView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(!self.dataList) {
        self.dataList = [[NSMutableArray alloc] init];
        ZBTUrlCacher *urlCacher = [[ZBTUrlCacher alloc] init];
        NSDictionary *dic = [urlCacher queryByUrlStr:[self urlCacherStr]];
        NSArray *list = dic[@"list"];
        for(int i=0;i<[list count];i++){
            NSMutableDictionary* data = [list[i] mutableCopy];
            
            Post *post = [Post getPostByJson:data andRemoveSmallImageWithWidth:60];
            PostLockedSQL *pSql = [[PostLockedSQL alloc] init];
            if ([pSql isExistingByPostId:post.postId]) {
                post.isLocked = YES;
            }
            [self.dataList addObject:post];
        }
    }
    
    return [self.dataList count];
}

//上下拉调用
- (void)beginRefreshing:(MJRefreshBaseView *)refreshView {
    [self requestPost:refreshView];
}

-(void)requestPost:(MJRefreshBaseView *)refreshView
{
    NetRequest * request =[NetRequest new];
    
    NSUInteger begin = self.isPullDownRefreshing ? 0: [self.dataList count];
    NSDictionary * parmeters = @{@"uid": self.userId,
                                 @"begin":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                 @"plen":@"15",
                                 @"need_flag":@"true",
                                 @"need_img":@"true",
                                 @"need_imgs":@"yes",
                                 @"need_whs":@"yes"
                                 };
    
    [request urlStr:[ApiUrl userPostsUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
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
        if (self.isPullDownRefreshing) {
            [self.dataList removeAllObjects];
            
            if ([customDict[@"list"] count]>0) {
                ZBTUrlCacher *urlCacher = [[ZBTUrlCacher  alloc] init];
                
                [urlCacher insertUrlStr:[self urlCacherStr] andJson:customDict];
                //[urlCacher queryAll];
            }
            
        }
        self.isPullDownRefreshing = NO;
        self.dataList = !self.dataList || [self.dataList count]<=0 ? [[NSMutableArray alloc]init]:self.dataList;
        
        NSArray* list = customDict[@"list"];
        
        for(int i=0;i<[list count];i++){
            NSMutableDictionary* data = [list[i] mutableCopy];
            
            Post *post = [Post getPostByJson:data andRemoveSmallImageWithWidth:60];
            PostLockedSQL *pSql = [[PostLockedSQL alloc] init];
            if ([pSql isExistingByPostId:post.postId]) {
                post.isLocked = YES;
            }
            [self.dataList addObject:post];
        }
        [self.tableView reloadData];
    }];
}

- (NSString *)urlCacherStr {
    NSString *Id = [NSString stringWithFormat:@"%@#uid:%@",[ApiUrl userPostsUrlStr],self.userId];
    return Id;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = self.dataList[indexPath.row];
    return [PindaoHomeNewsCell getCellHeightByPost:post];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PindaoHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PindaoHomeNewsCell"];
    if (!cell) {
        cell = [[PindaoHomeNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PindaoHomeNewsCell"];
    }
    Post *post = [self.dataList objectAtIndex:indexPath.row];
    cell.dataSource = post;
    cell.managerBtn.tag = indexPath.row;
    [cell.managerBtn addTarget:self action:@selector(clickedManagerBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Post *post = self.dataList[indexPath.row];
    [ZBPostJumpTool intoPage:post.postId withIndex:indexPath.row delegate:nil vc:self urlStr:post.postUrl];
}

- (void)clickedManagerBtn:(UIButton *)sender {
    NSInteger row = [sender tag];
    self.selectedRow = row;
    //sheet.tag = POST_REPLY_LAYER_ALERT;
    //NSDictionary *dic = self.dataList[row];
    
    NSArray *arr = @[GDLocalizedString(@"赞"), GDLocalizedString(@"收藏"), GDLocalizedString(@"举报")];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    CGPoint origin = [sender.superview convertPoint:sender.center fromView:[app window]];
    origin = CGPointMake(origin.x+10, -origin.y + sender.superview.frame.size.height*2-53);
    NSLog(@"origin %@",NSStringFromCGPoint(origin));
    
    ReplyManagerView *managerView = [[ReplyManagerView alloc] initWithButtonTitles:arr delegate:self origin:origin];
    [managerView show];
}

- (void)replyManagerView:(ReplyManagerView *)view selectedButtonTitle:(NSString *)title  {
    Post *post = self.dataList[self.selectedRow];
    if ([title isEqualToString:GDLocalizedString(@"赞")]) {
        NSLog(@"title:%@",title);
        
        [ZBPraise praiseWithKindId:post.postId getPraiseUid:post.uid praisedUid:[HuaxoUtil getUdidStr] praiseKind:ZBPraiseKindPost completed:^(BOOL result, NSString *msg, NSError *error) {
            [Praise hudShowTextOnly:msg delegate:self];
        }];
    } else if ([title isEqualToString:GDLocalizedString(@"收藏")]) {
        NSLog(@"title:%@",title);
        
        [ZBCollection collectionWithKindId:post.postId getCollectionUid:post.uid collectionUid:[HuaxoUtil getUdidStr] collectionKind:ZBCollectionKindPost completed:^(BOOL result, NSString *msg, NSError *error) {
            [Praise hudShowTextOnly:msg delegate:self];
        }];
    } else if ([title isEqualToString:GDLocalizedString(@"举报")]) {
        NSLog(@"title:%@",title);
        ReportPost *report = [[ReportPost alloc] initWithWithPostId:post.postId postUid:post.uid actKind:@"1" delegate:self];
        [report startReport];
        self.report = report;
    }
    
}

@end