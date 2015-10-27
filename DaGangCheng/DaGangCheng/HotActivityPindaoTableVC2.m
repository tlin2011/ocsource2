//
//  HotActivityPindaoTableVC2.m
//  DaGangCheng
//
//  Created by huaxo on 15-3-27.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "HotActivityPindaoTableVC2.h"
#import "HotActivityPindaoTableCell3.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "NetRequest.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ApiUrl.h"
#import "CSHistory.h"
#import "Post.h"
#import "ReplyManagerView.h"
#import "HotDotSlideView.h"
#import "Praise.h"
#import "ReportPost.h"
#import "ZBTUrlCacher.h"
#import "PostLockedSQL.h"
#import "ZBPraise.h"
#import "ZBCollection.h"

#import "ZBPostJumpTool.h"

@interface HotActivityPindaoTableVC2 ()<ReplyManagerViewDelegate, HotDotSlideViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, strong) ReportPost *report;


@end

@implementation HotActivityPindaoTableVC2


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
    
    self.pindaoId = @"819";

    [self.tableView registerClass:[HotActivityPindaoTableCell3 class] forCellReuseIdentifier:@"HotActivityPindaoTableCell3"];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:UIColorFromRGB(0xefefef)];
}

//上下拉刷新调用
- (void)beginRefreshing:(MJRefreshBaseView *)refreshView {
    [self requestPost:refreshView];
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
        NSArray *list = dic[@"plist"];
        for(int i=0;i<[list count];i++){
            NSMutableDictionary* data = [list[i] mutableCopy];
            
            Post *post = [Post getPostByJson:data];
            PostLockedSQL *pSql = [[PostLockedSQL alloc] init];
            if ([pSql isExistingByPostId:post.postId]) {
                post.isLocked = YES;
            }
            [self.dataList addObject:post];
        }
    }
    
    return self.dataList.count;
}

-(void)requestPost:(MJRefreshBaseView *)refreshView
{
    NetRequest * request =[NetRequest new];
    
    NSUInteger begin = self.isPullDownRefreshing ? 0: [self.dataList count];
    NSDictionary * parmeters = @{@"ibg_kind": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"],
                                 @"index":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                 @"size":@"15",
                                 @"need_img":@"yes",
                                 @"need_imgs":@"yes",
                                 @"need_whs":@"yes"
                                 };
    
    [request urlStr:[ApiUrl hotActivityUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
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
            if ([customDict[@"plist"] count]>0) {
                ZBTUrlCacher *urlCacher = [[ZBTUrlCacher  alloc] init];
                
                [urlCacher insertUrlStr:[self urlCacherStr] andJson:customDict];
                //[urlCacher queryAll];
            }
        }
        self.isPullDownRefreshing = NO;
        self.dataList = !self.dataList || [self.dataList count]<=0 ? [[NSMutableArray alloc]init]:self.dataList;
        
        NSArray* list = customDict[@"plist"];
        
        for(int i=0;i<[list count];i++){
            NSMutableDictionary* data = [list[i] mutableCopy];
            
            Post *post = [Post getPostByJson:data];
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
    NSString *Id = [NSString stringWithFormat:@"%@#ibg_kind:%@",[ApiUrl hotActivityUrlStr],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"]];
    return Id;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = self.dataList[indexPath.row];
    //return [HotActivityPindaoTableCell2 getCellHeightByPost:post];
    return [HotActivityPindaoTableCell3 getCellHeightByPost:post];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //HotActivityPindaoTableCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"HotActivityPindaoTableCell2"];
    //Post *post = [self.dataList objectAtIndex:indexPath.row];
    //cell.dataSource = post;
    //cell.managerBtn.tag = indexPath.row;
    //[cell.managerBtn addTarget:self action:@selector(clickedManagerBtn:) forControlEvents:UIControlEventTouchUpInside];
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    HotActivityPindaoTableCell3 *cell = [tableView dequeueReusableCellWithIdentifier:@"HotActivityPindaoTableCell3"];
    Post *post = [self.dataList objectAtIndex:indexPath.row];
    cell.post = post;
    [cell layoutSubviews];
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
    
    NSArray *arr = @[GDLocalizedString(@"赞"),GDLocalizedString(@"收藏"), GDLocalizedString(@"举报")];
    
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
        [ZBPraise praiseWithKindId:post.postId getPraiseUid:post.uid praisedUid:[HuaxoUtil getUdidStr] praiseKind:ZBPraiseKindPost completed:^(BOOL result, NSString *msg, NSError *error) {
            [Praise hudShowTextOnly:msg delegate:self];
        }];
    } else if ([title isEqualToString:GDLocalizedString(@"收藏")]) {
        [ZBCollection collectionWithKindId:post.postId getCollectionUid:post.uid collectionUid:[HuaxoUtil getUdidStr] collectionKind:ZBCollectionKindPost completed:^(BOOL result, NSString *msg, NSError *error) {
            [Praise hudShowTextOnly:msg delegate:self];
        }];
    } else if ([title isEqualToString:GDLocalizedString(@"举报")]) {
        ReportPost *report = [[ReportPost alloc] initWithWithPostId:post.postId postUid:post.uid actKind:@"1" delegate:self];
        [report startReport];
        self.report = report;
    }
    
}

@end