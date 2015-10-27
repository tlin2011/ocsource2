//
//  RecommendPindaoTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-23.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "RecommendPindaoTableVC.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "NetRequest.h"
#import "RecommendPindaoTableCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ApiUrl.h"
#import "ZBAppSetting.h"
#import "HuaxoUtil.h"
#import "Pindao.h"
#import "PindaoIndexViewController.h"


@interface RecommendPindaoTableVC ()

@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation RecommendPindaoTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addHeader];
    [self addFooter];
    
    NSString *title = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"推荐的"),[ZBAppSetting standardSetting].pindaoName];
    self.title = title;
    
    [self.tableView registerClass:[RecommendPindaoTableCell class] forCellReuseIdentifier:@"RecommendPindaoTableCell"];
    //[self requestUsers];
    
    // 去除空白cell
//    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)beginRefreshing:(MJRefreshBaseView *)refreshView {
    [self requestPindao:refreshView];
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
            Pindao *pindao = [Pindao getPindaoByJson:json];
            [self.dataList addObject:pindao];
        }
    }
    
    return [self.dataList count];
}



-(void)requestPindao:(MJRefreshBaseView *)refreshView
{
    //ApiUrl * url =[ApiUrl new];
    NetRequest * request =[NetRequest new];
    NSUInteger begin = self.isPullDownRefreshing ? 0: [self.dataList count];
    
    ZBAppSetting *appsetting = [ZBAppSetting standardSetting];
    NSString *lng = appsetting.longitudeStr;
    NSString *lat = appsetting.latitudeStr;
    //NSString *addr = single.addressAtr?single.addressAtr:@"";
    
    NSString *uid = [HuaxoUtil getUdidStr];
    
    NSDictionary * parameters = @{@"app_kind": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"],
                                  @"uid":uid,
                                  @"gps_lng":lng,
                                  @"gps_lat":lat,
                                  @"begin":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                  @"plen":@"15"};
    
    [request urlStr:[ApiUrl getNewReconmmendPindaoUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        if (![customDict[@"ret"] integerValue]) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            if (customDict[@"not_have"] && [customDict[@"not_have"] intValue] == 1) {

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
            }
            
        }
        self.isPullDownRefreshing = NO;
        self.dataList = !self.dataList || [self.dataList count]<=0 ? [[NSMutableArray alloc]init]:self.dataList;
        
        NSArray* list = customDict[@"list"];
        
        for (NSDictionary *json in list) {
            Pindao *pindao = [Pindao getPindaoByJson:json];
            [self.dataList addObject:pindao];
        }
        
        [self.tableView reloadData];
    }];
}

- (NSString *)urlCacherStr {
    NSString *Id = [NSString stringWithFormat:@"%@#app_kind:%@#uid:%@",[ApiUrl getNewReconmmendPindaoUrlStr],[[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"],[HuaxoUtil getUdidStr]];
    return Id;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendPindaoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendPindaoTableCell"];
    
    Pindao *pindao = self.dataList[indexPath.row];
    
    cell.titleLabel.text = pindao.name; //兼容默认推荐
    
    //ApiUrl * url = [ApiUrl new];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:[pindao.imageId integerValue] w:100]] placeholderImage:[UIImage imageNamed:@"频道默认图片.png"]];
    cell.content.text = pindao.desc;
    
    //粉丝 和 今日贴数

    cell.fansNum.text = pindao.userNum;
    CGSize fansStrSize = [cell.fansNum.text sizeWithFont:cell.fansNum.font forWidth:100 lineBreakMode:NSLineBreakByWordWrapping];
    cell.fansNum.frame = CGRectMake(103, 38, fansStrSize.width, 13);
    cell.topicIco.frame = CGRectMake(cell.fansNum.frame.origin.x + cell.fansNum.frame.size.width + 10, 38, 13, 12);
    cell.topicNum.frame = CGRectMake(cell.topicIco.frame.origin.x + cell.topicIco.frame.size.width + 5, 38, 80, 13);
    cell.topicNum.text = pindao.todayPostNum;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Pindao *pindao = self.dataList[indexPath.row];
    [self intoUserPage:pindao.pindaoId];
}

-(void)intoUserPage:(NSString *) kindId
{
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PindaoIndexViewController * next = [board instantiateViewControllerWithIdentifier:@"PindaoIndexViewController"];
    next.kind_id = kindId;

    next.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:next animated:YES];
}

@end
