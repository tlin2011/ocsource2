//
//  SearchUserViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-28.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "SearchUserViewController.h"
#import "PindaoFansViewController.h"
#import "PersonageSlideVC.h"

@interface SearchUserViewController ()
{
    //ApiUrl * url;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}
@end

@implementation SearchUserViewController
@synthesize dataList;

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
    self.searchBar.delegate = self;
    
    self.title=GDLocalizedString(@"搜索用户");
    self.searchBar.placeholder=GDLocalizedString(@"搜索用户输入框");
    
    //[self requestUsers];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [dataList count];
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
    dataList = nil;
    [self requestUsers];
}
-(void)requestUsers
{
    //ApiUrl * url =[ApiUrl new];
    NetRequest * request =[NetRequest new];
    NSUInteger begin = [dataList count];
    NSDictionary * parameters = @{@"key": self.searchBar.text,
                                  @"begin":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                  @"plen":@"20"};
    
    [request urlStr:[ApiUrl searchUsersUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        NSLog(@"search-users-list:%@",customDict);
        if (!customDict[@"ret"]  ) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            return ;
        }
        dataList = !dataList || [dataList count]<=0 ? [[NSMutableArray alloc]init]:dataList;
        
        NSArray* list = customDict[@"list"];
        
        if( !dataList || [dataList count]<=0 )
            dataList = [list mutableCopy];
        else{
            for(int i=0;i<[list count];i++){
                [dataList addObject:list[i]];
            }
        }
        [self.tableView reloadData];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchUserCell" forIndexPath:indexPath];

    NSDictionary* dataItem = dataList[indexPath.row];
    cell.nameLabel.text =  dataItem[@"name"];
    cell.lastTimeLabel.text = [NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"最近在线"),[TimeUtil  getFriendlySimpleTime:((NSNumber*)dataItem[@"save_time"])]];
    
    long imageID = [(NSNumber*)dataItem[@"tx_id"] integerValue];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:100]] placeholderImage:[UIImage imageNamed:@"nm"]];
    cell.imgView.layer.masksToBounds = YES;
    cell.imgView.layer.cornerRadius  = 5;
    
    return cell;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        NSLog(@"点击了OK");
        
        NetRequest * request = [NetRequest new];
        
        NSDictionary * parmeters = @{
                                     @"uid":_data2[@"uid"],
                                     @"kind_id":self.kind_id2,
                                     };
        
        [request urlStr:[ApiUrl setChannelManagerUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict)
         {
             
         }
         ];
        //     [self intoUserPage:data[@"uid"]];
        
        [self intoFan:self.kind_id2];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath:%ld ",(long)indexPath.row);
    NSDictionary* data = dataList[indexPath.row];
    _data2 = data;
    
    if (self.kind_id2 != nil)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"确定添加为管理员吗？") message:@"" delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"确定"), nil];
        
        [alertView show];
    }
    else
    {
        [self intoUserPage:data[@"uid"]];
    }
}

-(void)intoFan:(NSString*) kid
{
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //2.进攻,下一球
    PindaoFansViewController * next =[board instantiateViewControllerWithIdentifier:@"PindaoFansViewController"];
    
    //3.假动作,急停,跳投
    next.kind_id = [NSString stringWithFormat:@"%@",kid];
    
    
    
    [self.navigationController pushViewController:next animated:YES];
}

-(void)intoUserPage:(NSNumber*) uid
{
    NSString *userId = [NSString stringWithFormat:@"%@",uid];
    PersonageSlideVC *sc = [[PersonageSlideVC alloc] initWithUserId:userId];
    sc.title = @"个人主页";
    sc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sc animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_footer free];
    [_header free];
}

@end
