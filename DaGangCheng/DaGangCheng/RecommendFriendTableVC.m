//
//  RecommendFriendTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-23.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "RecommendFriendTableVC.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "NetRequest.h"
#import "RecommendFriendTableCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ApiUrl.h"
#import "HuaxoUtil.h"
#import "TimeUtil.h"
#import "PersonageSlideVC.h"
#import "YRJSONAdapter.h"

@interface RecommendFriendTableVC ()

@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation RecommendFriendTableVC


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
    
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 73, 0, 0);
    
    [self.tableView registerClass:[RecommendFriendTableCell class] forCellReuseIdentifier:@"RecommendFriendTableCell"];
    
    // 去除空白cell
//    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)beginRefreshing:(MJRefreshBaseView *)refreshView {
    [self requestUsers:refreshView];
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
        for (NSDictionary *json in list) {
            [self.dataList addObject:json];
        }
    }
    
    return [self.dataList count];
}

-(void)requestUsers:(MJRefreshBaseView *)refreshView
{
    //ApiUrl * url =[ApiUrl new];
    NetRequest * request =[NetRequest new];
    NSUInteger begin = self.isPullDownRefreshing ? 0: [self.dataList count];
    
    NSString *uid = [HuaxoUtil getUdidStr];
    
    NSDictionary * parameters = @{@"uid": uid,
                                  @"begin":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                  @"len":@"20"};
    
    [request urlStr:[ApiUrl recommendFriendUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
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
        
        for (NSDictionary *json in list) {
            [self.dataList addObject:json];
        }
        
        [self.tableView reloadData];
    }];
}

- (NSString *)urlCacherStr {
    NSString *Id = [NSString stringWithFormat:@"%@#uid:%@",[ApiUrl recommendFriendUrlStr],[HuaxoUtil getUdidStr]];
    return Id;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendFriendTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendFriendTableCell"];

    NSDictionary *json = self.dataList[indexPath.row];
    
    long imageID = [(NSNumber *)json[@"tx_id"] integerValue];
    [cell.head sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:100]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm.png"]];
    
    cell.name.text = json[@"name"];
    
    NSString *dynamic = json[@"dynamic"];
    if (!dynamic || [dynamic isKindOfClass:[NSNull class]]) {
    }else {
        NSData *jsonData = [dynamic dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        cell.msgLabel.text = dic?dic[@"title"]:@"";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *json = self.dataList[indexPath.row];
    [self intoUserPage:[NSString stringWithFormat:@"%@",json[@"uid"]]];
}

-(void)intoUserPage:(NSString *)uid
{
    PersonageSlideVC *sc = [[PersonageSlideVC alloc] initWithUserId:uid];
    sc.title = GDLocalizedString(@"个人主页");
    sc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sc animated:YES];
}

@end
