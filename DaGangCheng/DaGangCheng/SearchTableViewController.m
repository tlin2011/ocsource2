//
//  SearchTableViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-3.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "SearchTableViewController.h"

#import "ApiUrl.h"
#import "NetRequest.h"
#import "SearchCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "PindaoIndexViewController.h"
#import "ZBAppSetting.h"
#import "YRJSONAdapter.h"
#import "SQLDataBase.h"
#import "NotifyCenter.h"


NSString *const LYKTableViewCellIdentifier = @"Cell";

@interface SearchTableViewController ()
{
    NSString * keyString;
    
    NSMutableArray * kindArr;
    NSMutableArray * idArr;
    NSMutableArray * imgIDArr;
    NSMutableArray * descArr;
    
    NSMutableArray * channelArr;
    
    MJRefreshFooterView *_footer;
    
}
@end

@implementation SearchTableViewController

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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *oneSearchBarTitle = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"请搜索你关心的"),[ZBAppSetting standardSetting].pindaoName];
    self.oneSearchBar.placeholder = oneSearchBarTitle;
    self.oneSearchBar.delegate = self;

    // 1.注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:LYKTableViewCellIdentifier];
    // 3.2.上拉加载更多
    [self addFooter];
    
    keyString = @"";
}



#pragma mark - --上拉加载
- (void)addFooter
{
    __unsafe_unretained SearchTableViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {

        [self requestData];
        
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        
        //NSLog(@"%@----开始进入刷新状态", refreshView.class);
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






#pragma mark - --数据请求
-(void)requestData
{
    //ApiUrl * url = [ApiUrl new];
    NetRequest * request = [NetRequest new];
    NSDictionary * paramers = @{
                                @"key": keyString,
                                @"app_kind":[[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"],
                                @"begin":[NSString stringWithFormat:@"%ld",(unsigned long)kindArr.count],
                                @"plen":@"10",
                                };
    
    [request urlStr:[ApiUrl searchChannelUrlStr] parameters:paramers passBlock:^(NSDictionary *customDict) {
        NSLog(@"%@",customDict);
        
        if(!channelArr)
            channelArr = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[customDict[@"list"]count]; i++) {
            [kindArr addObject:customDict[@"list"][i][@"kind"]];
            [idArr addObject:customDict[@"list"][i][@"id"]];
            [imgIDArr addObject:customDict[@"list"][i][@"img_id"]];
            [descArr addObject:customDict[@"list"][i][@"desc"]];
            [channelArr addObject: customDict[@"list"][i] ];
            
        }
        [self.tableView reloadData];
        
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1.得到总故事版
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PindaoIndexViewController *next = [board instantiateViewControllerWithIdentifier:@"PindaoIndexViewController"];
    
    //2.传值
    next.kind_id = idArr[indexPath.row];
    
    //3.跳转,视图
    next.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:next animated:YES];
        next.hidesBottomBarWhenPushed = YES;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return kindArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SearchCell";
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    // Configure the cell...

    cell.titleLabel.text = kindArr[indexPath.row];
    cell.contentLabel.text = descArr[indexPath.row];
   // //ApiUrl * url= [ApiUrl new];
    long imageID = [(NSNumber *)imgIDArr[indexPath.row] integerValue];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:100]] placeholderImage:[UIImage imageNamed:@"频道默认图片.png"]];
   
    cell.headImageView.layer.cornerRadius = 5;
    cell.headImageView.layer.masksToBounds= YES;

    if ([PindaoCacher isFocused:HUASHUO_PD kindID:[NSString stringWithFormat:@"%@",idArr[indexPath.row]]]) {
        cell.concernBtn.selected = NO;
        
        NSString *concernBtnTitle = [ZBAppSetting standardSetting].focusName;
        [cell.concernBtn setTitle:concernBtnTitle forState:UIControlStateNormal];
    }
    else
    {
        //按钮设置
        cell.concernBtn.selected = YES;
        NSString *concernBtnTitle = [ZBAppSetting standardSetting].unfocusName;
        [cell.concernBtn setTitle:concernBtnTitle forState:UIControlStateNormal];
    }
    //关注按钮方法
    cell.concernBtn.tag = indexPath.row;
    [cell.concernBtn addTarget:self action:(@selector(conBtnAction:))forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}

#pragma mark - -- 关注按钮的点击方法
-(void)conBtnAction:(UIButton*)qcb
{
    NSDictionary *dataDic = channelArr[qcb.tag];
    //判断
    if ([PindaoCacher isFocused:HUASHUO_PD kindID:[NSString stringWithFormat:@"%@",dataDic[@"id"]]]) {
        qcb.selected = YES;
        NSString *qcbTitle = [ZBAppSetting standardSetting].unfocusName;
        [qcb setTitle:qcbTitle forState:UIControlStateNormal];
        
        [PindaoCacher unfocusPindao:HUASHUO_PD kindId:[NSString stringWithFormat:@"%@",dataDic[@"id"]]];
    }
    else
    {
        qcb.selected = NO;
        NSString *qcbTitle = [ZBAppSetting standardSetting].focusName;
        [qcb setTitle:qcbTitle forState:UIControlStateNormal];
        
        [PindaoCacher focusPindao:dataDic[@"kind"] kind:HUASHUO_PD kindID:dataDic[@"id"] imgID:dataDic[@"img_id"] desc:dataDic[@"desc"]];
    }
}





#pragma mark - -- 键盘取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
   [searchBar resignFirstResponder];
}


#pragma mark - -- 键盘搜索按钮
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self doSearch:searchBar];
}
-(void)doSearch:(UISearchBar *)searchBar{
    keyString = searchBar.text;
    kindArr =[NSMutableArray new];
    idArr  =[NSMutableArray new];
    imgIDArr =[NSMutableArray new];
    descArr =[NSMutableArray new];
    channelArr = [NSMutableArray new];

    [self.tableView reloadData];
    [self requestData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //ApiUrl *url = [ApiUrl new];
    [PindaoCacher forceSaveToNetwork];
}

- (void)dealloc {
    [_footer free];
}
@end
