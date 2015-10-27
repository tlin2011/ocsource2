//
//  ShequPindaoTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-23.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "ShequPindaoTableVC.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "NetRequest.h"
#import "ShequPindaoTableCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ApiUrl.h"
#import "Pindao.h"
#import "PindaoIndexViewController.h"
#import "PindaoCacher.h"
#import "ZBAppSetting.h"
#import "HuaxoUtil.h"
#import "UITableView+separator.h"


@interface ShequPindaoTableVC ()
{
    //ApiUrl * url;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
}
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation ShequPindaoTableVC


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
    [super viewDidLoad];    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [self addFooter];
    
    //table没数据时,去掉线
    [self.tableView bottomSeparatorHidden];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf7f8f8);
    
    [self.tableView registerClass:[ShequPindaoTableCell class] forCellReuseIdentifier:@"ShequPindaoTableCell"];
    [self requestUsers];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.dataList count];
}

#pragma mark - -- 上下拉刷新
- (void)addFooter
{
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        
        [self requestUsers];
        [self performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    
    _footer = footer;
}

- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.tableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

-(void)requestUsers
{
    //ApiUrl * url =[ApiUrl new];
    NetRequest * request =[NetRequest new];
    ZBAppSetting *appsetting = [ZBAppSetting standardSetting];
    NSString *lng = appsetting.longitudeStr;
    NSString *lat = appsetting.latitudeStr;
    NSString *addr = appsetting.address;
    
    NSString *uid = [HuaxoUtil getUdidStr] ? [HuaxoUtil getUdidStr]: @"";
    
    
    NSUInteger begin = [self.dataList count];
    NSDictionary * parameters = @{@"app_kind": [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"],
                                  @"uid":uid,
                                  @"gps_lng":lng,
                                  @"gps_lat":lat,
                                  @"addr":addr,
                                  @"day":@"30",
                                  @"begin":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                  @"plen":@"20"};
    
    [request urlStr:[ApiUrl nowPindaoUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        NSLog(@"search-users-list:%@",customDict);
        if (!customDict[@"ret"]  ) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            return ;
        }
        self.dataList = !self.dataList || [self.dataList count]<=0 ? [[NSMutableArray alloc]init]:self.dataList;
        
        NSArray* list = customDict[@"list"];
        
        for (NSDictionary *json in list) {
            Pindao *pindao = [Pindao getPindaoByJson:json];
            [self.dataList addObject:pindao];
        }
        [self.tableView reloadData];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ShequPindaoTableCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShequPindaoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShequPindaoTableCell"];
    
    Pindao *pindao = self.dataList[indexPath.row];
    
    cell.titleLabel.text = pindao.name;
    
    //ApiUrl * url = [ApiUrl new];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:[pindao.imageId integerValue] w:100]] placeholderImage:[UIImage imageNamed:@"频道默认图片.png"]];
    
    //粉丝 和 今日贴数
    
    cell.fansNum.text = [ZBNumberUtil shortStringByString:pindao.userNum];
    CGSize fansStrSize = [cell.fansNum.text sizeWithFont:cell.fansNum.font forWidth:100 lineBreakMode:NSLineBreakByWordWrapping];
    cell.fansNum.frame = CGRectMake(103, 38, fansStrSize.width, 13);
    cell.topicIco.frame = CGRectMake(cell.fansNum.frame.origin.x + cell.fansNum.frame.size.width + 10, 38, 13, 12);
    cell.topicNum.frame = CGRectMake(cell.topicIco.frame.origin.x + cell.topicIco.frame.size.width + 5, 38, 80, 13);
    cell.topicNum.text = [ZBNumberUtil shortStringByString:pindao.todayPostNum];
    
    cell.content.text = pindao.desc;
    
    if ([PindaoCacher isFocused:HUASHUO_PD kindID:pindao.pindaoId]) {
        cell.concernBtn.selected = YES;
    } else {
        //按钮设置
        cell.concernBtn.selected = NO;
    }
    [cell.concernBtn addTarget:self action:@selector(focus:) forControlEvents:UIControlEventTouchUpInside];
    cell.concernBtn.tag = indexPath.row;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Pindao *pindao = self.dataList[indexPath.row];
    [self intoUserPage:pindao.pindaoId];
}

-(void)intoUserPage:(NSString *)kindId
{
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];

    PindaoIndexViewController * next = [board instantiateViewControllerWithIdentifier:@"PindaoIndexViewController"];

    next.kind_id = kindId;
    [self.navigationController pushViewController:next animated:YES];
}

- (void)focus:(UIButton *)sender {
    Pindao *pindao = self.dataList[sender.tag];
    NSString *kindId = pindao.pindaoId;
    BOOL ret = NO;
    if (sender.selected) {
        sender.selected = NO;
        ret = [PindaoCacher unfocusPindao:HUASHUO_PD kindId:kindId];
    }
    else
    {
        if(self.dataList==nil) return ;
        //按钮设置
        sender.selected = YES;
        
        ret = [PindaoCacher focusPindao:pindao.name kind:HUASHUO_PD kindID:[NSNumber numberWithFloat:[kindId floatValue]] imgID:[NSNumber numberWithInteger:[pindao.imageId integerValue]] desc:pindao.desc];
    }
    
    if(ret){
        [PindaoCacher forceSaveToNetwork];
    }
}


- (void)dealloc {
    [_footer free];
    [_header free];
}

@end
