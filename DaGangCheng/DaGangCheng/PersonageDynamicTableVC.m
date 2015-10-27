//
//  PersonageDynamicTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PersonageDynamicTableVC.h"
#import "NetRequest.h"
#import "MyFeedsCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ApiUrl.h"
#import "CSHistory.h"
#import "Post.h"
#import "ReplyManagerView.h"
#import "Praise.h"
#import "ReportPost.h"
#import "ZBTUrlCacher.h"

#import "ZBPostJumpTool.h"

@interface PersonageDynamicTableVC ()<ReplyManagerViewDelegate>

@property (atomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) int selectedRow;

@property (nonatomic, strong) ReportPost *report;
@end

@implementation PersonageDynamicTableVC


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
    
    //[self requestPost];
}

//上下拉刷新
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
            NSDictionary* data = list[i];
            
            [self.dataList addObject:data];
        }
    }
    
    return [self.dataList count];
}

-(void)requestPost:(MJRefreshBaseView *)refreshView
{
    NetRequest * request =[NetRequest new];
    
    NSUInteger begin = self.isPullDownRefreshing ? 0: [self.dataList count];
    NSDictionary * parmeters = @{@"uid": self.userId,
                                 @"begin":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                 @"plen":@"15",
                                 };
    
    [request urlStr:[ApiUrl userFeedsUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
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
            NSDictionary* data = list[i];

            [self.dataList addObject:data];
        }
        [self.tableView reloadData];
    }];
}

- (NSString *)urlCacherStr {
    NSString *Id = [NSString stringWithFormat:@"%@#uid:%@",[ApiUrl userFeedsUrlStr],self.userId];
    return Id;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dataItem =self.dataList[indexPath.row];
    
    MyFeedsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"myFeedsCell"];
    if (!cell) {
        cell = [[MyFeedsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"myFeedsCell"];
    }
    cell.name.text =  dataItem[@"user_name"];
    cell.msgLabel.text  = dataItem[@"title"];
    cell.timeLabel.text = [TimeUtil getFriendlySimpleTime:((NSNumber*)dataItem[@"save_time"])];
    long imageID = [(NSNumber *)dataItem[@"tx_id"] integerValue];
    [cell.head sd_setBackgroundImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:100]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm"]];
    
    BOOL is24Inner = [TimeUtil is24Inner: ((NSNumber*)dataItem[@"save_time"])];
    UIColor* color = is24Inner ? [UIColor redColor]:[UIColor darkGrayColor];
    [cell.timeLabel setTextColor:color];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* dataItem =self.dataList[indexPath.row];
    NSString *postId = [CSPortalParser getPostIdFromCSStr:dataItem[@"cs"]];
    
    [ZBPostJumpTool intoPage:postId withIndex:indexPath.row delegate:nil vc:self urlStr:@""];
}

@end