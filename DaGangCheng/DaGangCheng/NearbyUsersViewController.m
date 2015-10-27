//
//  NearbyUsersViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-12.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "NearbyUsersViewController.h"
#import "UIButton+WebCache.h"
#import "PersonageSlideVC.h"
#import "ZYLocationManager.h"
#import "UITableView+separator.h"

@interface NearbyUsersViewController ()
{
    //ApiUrl * url;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
}
@end

@implementation NearbyUsersViewController

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
    //[self addHeader];
    [self addFooter];
    
    [self zuobiao];
    [self requestUsers];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 73, 0, 0);
    [self.tableView bottomSeparatorHidden];
    //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
//    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated
{
    [self zuobiao];
}
-(void)zuobiao
{
    [[ZYLocationManager sharedZYLocationManager] getLocationCoordinate:^(CLLocationCoordinate2D coor) {
        [ZBAppSetting standardSetting].latitude = coor.latitude;
        [ZBAppSetting standardSetting].longitude = coor.longitude;
    } address:^(NSString *address) {
        [ZBAppSetting standardSetting].address = address;
    }];
}


#pragma mark - -- 上下拉刷新
- (void)addFooter
{
    __unsafe_unretained NearbyUsersViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //[vc neRequestData:anyUrlStr];
        NSLog(@"我想知道有没有");
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        
        [vc requestUsers];
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    
    _footer = footer;
}

- (void)addHeader
{
    //[dataArray removeAllObjects];
    __unsafe_unretained NearbyUsersViewController *vc = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        self.dataList = nil;
        [vc requestUsers];
        //[vc neRequestData:anyUrlStr];
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是header
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:2.0];
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    header.endStateChangeBlock = ^(MJRefreshBaseView *refreshView) {
        // 刷新完毕就会回调这个Block
        NSLog(@"%@----刷新完毕", refreshView.class);
    };
    
    //未用到
    header.refreshStateChangeBlock = ^(MJRefreshBaseView *refreshView, MJRefreshState state) {
        // 控件的刷新状态切换了就会调用这个block
        switch (state) {
            case MJRefreshStateNormal:
                NSLog(@"%@----切换到：普通状态", refreshView.class);
                break;
                
            case MJRefreshStatePulling:
                NSLog(@"%@----切换到：松开即可刷新的状态", refreshView.class);
                break;
                
            case MJRefreshStateRefreshing:
                NSLog(@"%@----切换到：正在刷新状态", refreshView.class);
                break;
            default:
                break;
        }
    };
    [header beginRefreshing];
    _header = header;
}
- (void)doneWithView:(MJRefreshBaseView *)refreshView
{
    // 刷新表格
    [self.tableView reloadData];
    // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    [refreshView endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"nearbyUserCell";
    NearbyUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary* dataItem = self.dataList[indexPath.row];
    
    cell.name.text =  dataItem[@"name"];
    
    NSString *distanceStr = [NSString stringWithFormat:@"%@",[HuaxoUtil getFriendlyDistance:(NSNumber*)dataItem[@"distance"]]];
    CGSize size = [distanceStr sizeWithFont:cell.timeLabel.font forWidth:320 lineBreakMode:NSLineBreakByWordWrapping];
    cell.timeLabel.frame = CGRectMake(self.tableView.bounds.size.width - 8 - size.width, 16, size.width, 12);
    cell.timeLabel.text  = distanceStr;
    
    cell.addIco.frame = CGRectMake(cell.timeLabel.frame.origin.x - 4 - 9, cell.timeLabel.frame.origin.y, 9, 11);
    
    
    cell.msgLabel.text = [NSString stringWithFormat:@"%@:%@",GDLocalizedString(@"最近在线"),[TimeUtil getFriendlyTime:((NSNumber*)dataItem[@"update_time"])]];
    long imageID = [(NSNumber*)dataItem[@"tx_id"] integerValue];
    [cell.head sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:100]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm"]];
    cell.head.tag = [dataItem[@"uid"] integerValue];
    [cell.head addTarget:self action:@selector(txClicked:) forControlEvents:UIControlEventTouchUpInside];
    // Configure the cell...
    
    return cell;
}

-(void)txClicked:(UIView*)sender
{
    NSInteger uid = sender.tag;
    [self intoUserPage:uid];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath:%ld ",(long)indexPath.row);
    NSDictionary* data = self.dataList[indexPath.row];
    
    [self intoUserPage:[data[@"uid"] integerValue]];
}

-(void)intoUserPage:(NSInteger) uid
{
    NSString* userId = [NSString stringWithFormat:@"%ld",(long)uid];
    
    PersonageSlideVC *sc = [[PersonageSlideVC alloc] initWithUserId:userId];
    sc.title = GDLocalizedString(@"个人主页");
    sc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sc animated:YES];
}
-(void)requestUsers
{
    //ApiUrl * url =[ApiUrl new];
    NetRequest * request =[NetRequest new];

    NSUInteger begin = [self.dataList count];
    ZBAppSetting * appsetting = [ZBAppSetting standardSetting];
    
    [self dialogShow];
    
    NSDictionary * parameters = @{@"uid": [HuaxoUtil getUdidStr],
                                  @"begin":[NSString stringWithFormat:@"%ld",(long)begin],
                                  @"plen":@"20",
                                  @"gps_lng":appsetting.longitudeStr,
                                  @"gps_lat":appsetting.latitudeStr,
                                  @"loc_addr":appsetting.address
                                  };
    __weak __typeof(self) weakSelf = self;
    
    [request urlStr:[ApiUrl nearbyUsersUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        [weakSelf dialogDismiss];
        
        NSLog(@"nearby-users-list:%@",customDict);
        if (!customDict[@"ret"]  ) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            
            return ;
        }
        self.dataList = !self.dataList || [self.dataList count]<=0 ? [[NSMutableArray alloc]init]:self.dataList;
        
        NSArray* list = customDict[@"list"];
        
        if( !self.dataList || [self.dataList count]<=0 ){
            self.dataList = [list mutableCopy];
        } else{
            for(int i=0;i<[list count];i++){
                [self.dataList addObject:list[i]];
            }
        }
        [weakSelf.tableView reloadData];
    }];
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

//显示加载中对话框
- (void)dialogShow {
    self.progressView.trackTintColor = [UIColor clearColor];
    self.progressView.alpha = 0.6;
    self.progressView.progress = 0;
    self.progressView.hidden = NO;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgressTime) userInfo:nil repeats:YES];
}

-(void)updateProgressTime
{
    if(self.progressView.progress > 0.9)
        self.progressView.progress += 0.001;
    else
        self.progressView.progress += 0.001;
}

-(void)endProgressTime
{
    self.progressView.progress += 0.1;
    if(self.progressView.progress>=1.f)
    {
        if(self.timer && self.timer.isValid)
            [self.timer invalidate];
        
        self.progressView.hidden = YES;
    }
}
//取消对话框显示
- (void) dialogDismiss{
    if(self.timer && self.timer.isValid)
        [self.timer invalidate];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(endProgressTime) userInfo:nil repeats:YES];
}

- (void)dealloc {
    [_footer free];
    [_header free];
}

@end
