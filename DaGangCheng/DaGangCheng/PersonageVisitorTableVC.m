//
//  PersonageVisitorTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PersonageVisitorTableVC.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "NetRequest.h"
#import "RecentlyVisitTableCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ApiUrl.h"
#import "ZBAppSetting.h"
#import "CSHistory.h"
#import "Post.h"
#import "ReplyManagerView.h"
#import "Praise.h"
#import "ReportPost.h"
#import "PersonageSlideVC.h"
#import "ZBTUrlCacher.h"


@interface PersonageVisitorTableVC ()

@property (atomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) int selectedRow;

@property (nonatomic, strong) ReportPost *report;

@end

@implementation PersonageVisitorTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addHeader];
    [self addFooter];
    
    self.pindaoId = self.pindaoId? self.pindaoId:@"";
    
    //[self requestPost];
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

//上下拉刷新
- (void)beginRefreshing:(MJRefreshBaseView *)refreshView {
    [self requestPost:refreshView];
}

-(void)requestPost:(MJRefreshBaseView *)refreshView
{
    NetRequest * request =[NetRequest new];
    
    ZBAppSetting *appsetting = [ZBAppSetting standardSetting];
    NSString *lng = appsetting.longitudeStr;
    NSString *lat = appsetting.latitudeStr;
    
    NSUInteger begin = self.isPullDownRefreshing ? 0: [self.dataList count];
    NSDictionary * parmeters = @{@"to_uid": self.userId,
                                 @"gps_lng": lng,
                                 @"gps_lat": lat,
                                 @"begin":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                 @"plen":@"15",
                                 };
    
    [request urlStr:[ApiUrl userInfoVisitorUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
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
    NSString *Id = [NSString stringWithFormat:@"%@#to_uid:%@",[ApiUrl userInfoVisitorUrlStr],self.userId];
    return Id;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecentlyVisitTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentlyVisitTableCell"];
    if (!cell) {
        cell = [[RecentlyVisitTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecentlyVisitTableCell"];
    }
    
    NSDictionary* dataItem =self.dataList[indexPath.row];
    
    NSLog(@"cellForRowAtIndexPath  row:%ld data:%@",(long)indexPath.row,dataItem);
    
    cell.name.text =  dataItem[@"name"];
    cell.msgLabel.text  = dataItem[@"title"];
    cell.timeLabel.text = [TimeUtil getFriendlySimpleTime:((NSNumber*)dataItem[@"save_time"])];
    long imageID = [(NSNumber*)dataItem[@"tx_id"] integerValue];
    [cell.head sd_setBackgroundImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:100]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm"]];
    
    BOOL is24Inner = [TimeUtil is24Inner: ((NSNumber*)dataItem[@"save_time"])];
    UIColor* color = is24Inner ? [UIColor redColor]:[UIColor darkGrayColor];
    [cell.timeLabel setTextColor:color];
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataList[indexPath.row];
    NSString *uid =[NSString stringWithFormat:@"%ld",(long)[dic[@"uid"] integerValue]];
    NSString *name = dic[@"name"];
    
    PersonageSlideVC *sc = [[PersonageSlideVC alloc] initWithUserId:uid];
    sc.title = name;
    sc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sc animated:YES];
}

@end

