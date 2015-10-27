//
//  HotNewInteractionTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-19.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "HotNewInteractionTableVC.h"
#import "NetRequest.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ApiUrl.h"
#import "CSHistory.h"
#import "Post.h"
#import "ReplyManagerView.h"
#import "PostViewController.h"
#import "Praise.h"
#import "ReportPost.h"
#import "ZBTUrlCacher.h"

#import "PindaoHomeNewsCell.h"
#import "ZBTiebaPostCell.h"
#import "ZBAppSetting.h"
#import "ZBPraise.h"
#import "ZBCollection.h"

#import "ZBPostJumpTool.h"

@interface HotNewInteractionTableVC ()<ReplyManagerViewDelegate, PostViewControllerDelegate>

@property (atomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger selectedRow;

@property (nonatomic, strong) ReportPost *report;
@end

@implementation HotNewInteractionTableVC


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
    
    //[self requestPost];
    
    //cell注册
    if ([[ZBAppSetting standardSetting] naviCellStyle]==1) {
        [self.tableView registerClass:[ZBTiebaPostCell class] forCellReuseIdentifier:@"ZBTiebaPostCell"];
    } else {
        [self.tableView registerClass:[PindaoHomeNewsCell class] forCellReuseIdentifier:@"PindaoHomeNewsCell"];
    }
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = UIColorFromRGB(0xefefef);
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

//上下拉刷新调用
- (void)beginRefreshing:(MJRefreshBaseView *)refreshView {
    [self requestPost:refreshView];
}

-(void)requestPost:(MJRefreshBaseView *)refreshView
{
    NetRequest * request =[NetRequest new];
    
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    
    
    NSUInteger begin = self.isPullDownRefreshing ? 0: [self.dataList count];
    NSDictionary * parmeters = @{@"app_kind": app_kind,
                                 @"day":@"30",
                                 @"gps_lng": @"",
                                 @"gps_lat": @"",
                                 @"begin":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                 @"plen":@"15",
                                 @"need_flag":@"true",
                                 @"need_img":@"true",
                                 @"need_imgs":@"yes",
                                 @"need_whs":@"yes"
                                 };
    
    [request urlStr:[ApiUrl neInteractionUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict) {
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
    NSString *Id = [NSString stringWithFormat:@"%@#app_kind:%@",[ApiUrl neInteractionUrlStr],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"]];
    return Id;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = self.dataList[indexPath.row];
    
    if ([[ZBAppSetting standardSetting] naviCellStyle] == 1) {
        return [ZBTiebaPostCell getCellHeightByPost:post];
    }
    return [PindaoHomeNewsCell getCellHeightByPost:post];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Post *post = [self.dataList objectAtIndex:indexPath.row];
    
    if ([[ZBAppSetting standardSetting] naviCellStyle] == 1) {
        ZBTiebaPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZBTiebaPostCell"];
        cell.post = post;
        [cell layoutSubviews];
        return cell;
    }
    
    PindaoHomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PindaoHomeNewsCell"];
    cell.post = post;
    [cell layoutSubviews];
    cell.managerBtn.tag = indexPath.row;
    [cell.managerBtn addTarget:self action:@selector(clickedManagerBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Post *post = self.dataList[indexPath.row];
    [ZBPostJumpTool intoPage:post.postId withIndex:indexPath.row delegate:self vc:self urlStr:post.postUrl];
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

#pragma mark - 实现PostViewController的代理方法
- (void)postViewController:(PostViewController *)postViewController withIndex:(NSInteger)index post:(Post *)changedPost
{
    ZBLog(@"%ld", index);
    Post *post = self.dataList[index];
    post.readNum = changedPost.readNum;
    post.zan = changedPost.zan;
    post.replyNum = changedPost.replyNum;
    
    // 刷新数据
    [self.tableView reloadData];
}

- (void)postViewController:(PostViewController *)postViewController deleteWithIndex:(NSInteger)index
{
    if (index >= self.dataList.count) return;
    
    [self.dataList removeObjectAtIndex:index];
    [self.tableView reloadData];
}

@end