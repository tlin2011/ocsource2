//
//  selectLocationTVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-7-24.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "selectLocationTVC.h"
#import "MJRefreshFooterView.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPSessionManager.h"
#import "MMLocationManager.h"
#import "MBProgressHUD.h"
#import "NetRequest.h"
#import "ZYLocationManager.h"
#import "ZBLocation.h"
#import "UITableView+separator.h"

@interface SelectLocationTVC ()<MBProgressHUDDelegate> {

}
@property (strong, nonatomic) NSMutableArray *locationArr;
@property (copy, nonatomic) NSString *latitude;
@property (copy, nonatomic) NSString *longitude;
@property (strong, nonatomic) CLLocationManager *locationManager;//定义Manager
@property (nonatomic) int page; //请求页数

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) ZYLocationManager *locManager;
@end

@interface SelectLocationTVC ()
@property MJRefreshFooterView *footer;
@end

@implementation SelectLocationTVC

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
    self.title = GDLocalizedString(@"选择位置");
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    
    self.hud.delegate = self;
    self.hud.labelText = GDLocalizedString(@"加载中...");
    
    [self.hud show:YES];
    
    [self addFooter];
    
    //table没数据时,去掉线
    [self.tableView bottomSeparatorHidden];
    
    self.locManager = [[ZYLocationManager alloc] init];
    [self.locManager getLocationCoordinate:^(CLLocationCoordinate2D coor) {
        [ZBAppSetting standardSetting].latitude = coor.latitude;
        [ZBAppSetting standardSetting].longitude = coor.longitude;
    } detailAddress:^(ZBLocation *loca) {
        [ZBAppSetting standardSetting].loca = loca;
        [self requestLocation];
    }];
    
    //[self getAddrbySystem];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}



- (void) getCity:(NSStringBlock)cityBlock error:(LocationErrorBlock) errorBlock {

}

- (void)progressHUD:(MBProgressHUD *)hud showTextOnly:(NSString *)message {
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:5];
}

- (void)requestLocation{
    //请求位置信息
    self.page++;
    //@"http://apis.juhe.cn/baidu/getLocate"
    //NSDictionary *parameters =@{@"key":@"8a530f5afa5c3c256a36607b866bfe5d",@"dtype":@"json",@"lng":self.longitude,@"lat":self.latitude,@"r":@"500",@"page":[NSString stringWithFormat:@"%d",self.page],@"cid":@"",@"pnums":@"20"};
    
    NSString *lng = [[ZBAppSetting standardSetting] longitudeStr];
    NSString *lat = [[ZBAppSetting standardSetting] latitudeStr];
    NSString *addr = [ZBAppSetting standardSetting].loca.district;
    
    NSString *baiduMap_key = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"baiduMap_key"];
    
    NSDictionary *parameters =@{@"ak":baiduMap_key,
                                @"output":@"json",
                                @"query":addr,
                                @"r":@"500",
                                @"page_size":@"20",
                                @"page_num":[NSString stringWithFormat:@"%d",self.page],
                                @"scope":@"2",
                                @"location":[NSString stringWithFormat:@"%@,%@",lat,lng],
                                @"filter":@"sort_name:distance"
                                };
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://api.map.baidu.com/place/v2/search" parameters:parameters  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        
        if ([responseObject[@"message"] isEqualToString:@"ok"] && responseObject[@"results"]) {
            if (self.locationArr.count<1) {
                self.locationArr = [responseObject[@"results"] mutableCopy];
            }else {
                [self.locationArr addObjectsFromArray:responseObject[@"results"]];
            }
            
            [self.hud hide:YES];
            [self.tableView reloadData];
        } else {
            [self progressHUD:self.hud showTextOnly:GDLocalizedString(@"请求超时...")];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *failStr = error.userInfo[@"NSLocalizedDescription"];
        [self progressHUD:self.hud showTextOnly:failStr];
    }];
}

- (NSString *)removeNumber:(NSString *)str {
    [str rangeOfString:str options:NSCaseInsensitiveSearch];
    for (int i=0; i<str.length; i++) {
        NSRange r = NSMakeRange(i, 1);
        NSString *a = [str substringWithRange:r];
        for (int j = 0; j<10; j++) {
            NSString *b = [NSString stringWithFormat:@"%d",j];
            if ([a isEqualToString:b]) {
                return [str substringToIndex:i];
            }
            
        }

    }
    return str;
}

#pragma mark - -- 上下拉刷新
- (void)addFooter
{
    __weak SelectLocationTVC *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //[vc neRequestData:anyUrlStr];
        NSLog(@"我想知道有没有");
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        
        [vc requestLocation];
        
        
        [vc performSelector:@selector(doneWithView:) withObject:refreshView afterDelay:1.0];
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locationArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    cell.imageView.image = [[UIImage imageNamed:@"定位_发帖.png"] imageWithMobanThemeColor];
    if (indexPath.row == 0) {
        cell.textLabel.text = GDLocalizedString(@"不显示位置");
        cell.textLabel.textColor = [UIColor blueColor];
        cell.detailTextLabel.text = @" ";
        if (self.selectedLocation) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else {
        NSDictionary *data = self.locationArr[indexPath.row-1];
        cell.textLabel.text = data[@"name"];
        cell.detailTextLabel.text = data[@"address"];
        if ([self.selectedLocation isEqualToString:cell.textLabel.text]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.selectedLocation = nil;
    }else {
        self.selectedLocation = self.locationArr[indexPath.row-1][@"name"];
    }
    if ([self.delegate respondsToSelector:@selector(SelectLocationTVC:selectedLocation:)]) {
        [self.delegate SelectLocationTVC:self selectedLocation:self.selectedLocation];
    }
    if ([self.delegate respondsToSelector:@selector(SelectLocationTVC:selectedLocation:latitude:longitude:)]) {
        [self.delegate SelectLocationTVC:self selectedLocation:self.selectedLocation latitude:self.latitude longitude:self.longitude];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.locationArr removeAllObjects];
}

- (void)dealloc {
    [_footer free];
    
}
@end
