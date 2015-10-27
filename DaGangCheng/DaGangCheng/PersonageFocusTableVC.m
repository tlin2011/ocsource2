//
//  PersonageFocusTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-11-10.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PersonageFocusTableVC.h"
#import "ShequPindaoTableCell.h"
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
#import "ReportPost.h"
#import "Pindao.h"
#import "PindaoCacher.h"


@interface PersonageFocusTableVC ()<ReplyManagerViewDelegate>

@property (atomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) int selectedRow;

@property (nonatomic, strong) ReportPost *report;
@property (nonatomic, assign) BOOL isPullDownRefreshing;
@end

@implementation PersonageFocusTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addHeader];
    //[self addFooter];
    
    self.pindaoId = self.pindaoId? self.pindaoId:@"";
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = UIColorFromRGB(0xf3f5f6);
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
    // Return the number of rows in the section.
    return self.dataList.count;
    //return [self.dataList count];
}

- (void)beginRefreshing:(MJRefreshBaseView *)refreshView {
    [self requestPost:refreshView];
}

-(void)requestPost:(MJRefreshBaseView *)refreshView
{
    NetRequest * request =[NetRequest new];
    
    //NSUInteger begin = self.isPullDownRefreshing ? 0: [self.dataList count];
    NSDictionary * parmeters = @{@"uid": self.userId,
                                 };
    
    [request urlStr:[ApiUrl AttentionChannelUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        
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
        if (self.isPullDownRefreshing) [self.dataList removeAllObjects];
        self.isPullDownRefreshing = NO;
        self.dataList = !self.dataList || [self.dataList count]<=0 ? [[NSMutableArray alloc]init]:self.dataList;
        
        NSArray* list = customDict[@"list"];
        
        for(int i=0;i<[list count];i++){
            NSDictionary* data = list[i];
            Pindao *pindao = [Pindao getPindaoByJson:data];
            
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
    if (!cell) {
        cell = [[ShequPindaoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShequPindaoTableCell"];
    }
    Pindao *pindao = self.dataList[indexPath.row];
    
    cell.titleLabel.text = pindao.name;
    
    //ApiUrl * url = [ApiUrl new];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:[pindao.imageId integerValue] w:100]] placeholderImage:[UIImage imageNamed:@"频道默认图片.png"]];
    
    //粉丝 和 今日贴数
    
    cell.fansNum.text = pindao.userNum;
    CGSize fansStrSize = [cell.fansNum.text sizeWithFont:cell.fansNum.font forWidth:100 lineBreakMode:NSLineBreakByWordWrapping];
    cell.fansNum.frame = CGRectMake(103, 38, fansStrSize.width, 13);
    cell.topicIco.frame = CGRectMake(cell.fansNum.frame.origin.x + cell.fansNum.frame.size.width + 10, 38, 13, 12);
    cell.topicNum.frame = CGRectMake(cell.topicIco.frame.origin.x + cell.topicIco.frame.size.width + 5, 38, 80, 13);
    cell.topicNum.text = pindao.todayPostNum;
    
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

@end



