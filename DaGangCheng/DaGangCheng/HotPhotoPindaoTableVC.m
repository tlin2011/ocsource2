//
//  HotPhotoPindaoTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-24.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "HotPhotoPindaoTableVC.h"
#import "HotPhotoPindaoTableCell.h"
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
#import "ZBTUrlCacher.h"

#import "ZBPostJumpTool.h"

@interface HotPhotoPindaoTableVC ()<ReplyManagerViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) int beginCount;
@end

@implementation HotPhotoPindaoTableVC


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
    
    self.beginCount = 0;
    
    [self addHeader];
    [self addFooter];
    self.tableView.backgroundColor = UIColorFromRGB(0xefefef);
    [self.tableView registerClass:[HotPhotoPindaoTableCell class] forCellReuseIdentifier:@"HotPhotoPindaoTableCell"];
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
        NSArray *list = dic[@"list"];
        for(int i=0;i<[list count];i++){
            NSMutableDictionary* data = [list[i] mutableCopy];
            NSDictionary* log = [CSHistory getPostLog:data[@"post_id"] title:@""];
            BOOL hasLog = [CSHistory hasCSLog:log];
            data[@"clicked"] = [NSNumber numberWithBool:hasLog];
            Post *post = [Post getPostByJson:data andRemoveSmallImageWithWidth:60];
            if (![post.imageList isKindOfClass:[NSNull class]] && [post.imageList count] >= 1) {
                [self.dataList addObject:post];
            }
        }
    }
    
    return [self.dataList count];

}

-(void)requestPost:(MJRefreshBaseView *)refreshView
{
    NetRequest * request =[NetRequest new];
    
    self.beginCount = self.isPullDownRefreshing ? 0: self.beginCount;
    NSDictionary * parmeters = @{@"app_kind": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"],
                                 @"day":@"30",
                                 @"flag":@"",
                                 @"gps_lng": @"",
                                 @"gps_lat": @"",
                                 @"begin":[NSString stringWithFormat:@"%d",self.beginCount],
                                 @"plen":@"10",
                                 @"need_flag":@"true",
                                 @"need_img":@"yes",
                                 @"need_imgs":@"yes",
                                 @"need_whs":@"yes"
                                 };
    
    [request urlStr:[ApiUrl photoTopicsUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict) {
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
        
        self.beginCount += 10;  //plen
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
            NSDictionary* log = [CSHistory getPostLog:data[@"post_id"] title:@""];
            BOOL hasLog = [CSHistory hasCSLog:log];
            data[@"clicked"] = [NSNumber numberWithBool:hasLog];
            Post *post = [Post getPostByJson:data andRemoveSmallImageWithWidth:60];
            if (![post.imageList isKindOfClass:[NSNull class]] && [post.imageList count] >= 1) {
                [self.dataList addObject:post];
            }
        }

        [self.tableView reloadData];
        
    }];
}

- (NSString *)urlCacherStr {
    NSString *Id = [NSString stringWithFormat:@"%@#app_kind:%@",[ApiUrl photoTopicsUrlStr],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"]];
    return Id;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 198;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HotPhotoPindaoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotPhotoPindaoTableCell"];
    Post *post = [self.dataList objectAtIndex:indexPath.row];
    cell.dataSource = post;
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Post *post = self.dataList[indexPath.row];
    [ZBPostJumpTool intoPage:post.postId withIndex:indexPath.row delegate:nil vc:self urlStr:post.postUrl];
}

- (void)clickedManagerBtn:(UIButton *)sender {
    //NSInteger row = [sender tag];
    
    //sheet.tag = POST_REPLY_LAYER_ALERT;
    //NSDictionary *dic = self.dataList[row];
    
    NSArray *arr = @[GDLocalizedString(@"收藏"), GDLocalizedString(@"举报")];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    CGPoint origin = [sender.superview convertPoint:sender.center fromView:[app window]];
    origin = CGPointMake(origin.x+10, -origin.y + sender.superview.frame.size.height*2-53);
    NSLog(@"origin %@",NSStringFromCGPoint(origin));
    
    ReplyManagerView *managerView = [[ReplyManagerView alloc] initWithButtonTitles:arr delegate:self origin:origin];
    [managerView show];
}

- (void)replyManagerView:(ReplyManagerView *)view selectedButtonTitle:(NSString *)title  {
    if ([title isEqualToString:GDLocalizedString(@"收藏")]) {
        NSLog(@"title:%@",title);

    } else if ([title isEqualToString:GDLocalizedString(@"举报")]) {
        NSLog(@"title:%@",title);

    }
    
}

@end