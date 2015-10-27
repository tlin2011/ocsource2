//
//  RecentlyVisitTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-29.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "RecentlyVisitTableVC.h"
#import "RecentlyVisitTableCell.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "NetRequest.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "ApiUrl.h"
#import "Pindao.h"
#import "PindaoCacher.h"
#import "HuaxoUtil.h"
#import "PersonageSlideVC.h"
#import "ZBAppSetting.h"
#import "UITableView+separator.h"

#import "HudUtil.h"

#import "ZbtUserPm.h"

#import "MJExtension.h"

#import "CustomWindow.h"


@interface RecentlyVisitTableVC ()
{
    //ApiUrl * url;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    CustomWindow *customWindow;
    
}
@property (nonatomic, strong) NSMutableArray *dataList;
@end

@implementation RecentlyVisitTableVC


UIButton *selectBtn;

NSIndexPath *_prohibitIndexPath;


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
    
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 73, 0, 0);
    //table没数据时,去掉线
    [self.tableView bottomSeparatorHidden];
    
    [self.tableView registerClass:[RecentlyVisitTableCell class] forCellReuseIdentifier:@"RecentlyVisitTableCell"];
    
    [self requestUsers];
    
    //创建长按手势监听
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleTableviewCellLongPressed:)];
    
    longPress.delegate = self;
    longPress.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPress];
}



//长按事件的手势监听实现方法
- (void) handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        CGPoint ponit=[gestureRecognizer locationInView:self.tableView];

        NSIndexPath* path=[self.tableView indexPathForRowAtPoint:ponit];

        _prohibitIndexPath=path;
        
        NSDictionary* data =self.dataList[_prohibitIndexPath.row];
        
        
        NetRequest * request =[NetRequest new];
        
        NSDictionary * parmeters = @{@"uid": [HuaxoUtil getUdidStr]};
        
        [request urlStr:[ApiUrl getUserPm] parameters:parmeters passBlock:^(NSDictionary *customDict) {
            
            BOOL flag=false;
            if ([customDict[@"ret"] integerValue]) {
                
                
                NSDictionary *dict2 =customDict;
                
                ZbtUserPm   *tempZbtUserPm = [ZbtUserPm objectWithKeyValues:dict2];
                
                if ([tempZbtUserPm.pm intValue]==1) {
                    flag=true;
                }
                if ([tempZbtUserPm.pm intValue]==2) {
//                    if ([tempZbtUserPm.kind_ids[0][@"kind_id"]  intValue]==0) {
                        flag=true;
//                    }
                }
                
            }
            if (flag) {
                [self showDialog:data[@"name"]];
            }
        }];
//        [self showDialog:data[@"name"]];
    }

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
    
    //NSString *uid = [HuaxoUtil getUdidStr] ? [HuaxoUtil getUdidStr]: @"";
    
    NSUInteger begin = [self.dataList count];
    NSDictionary * parameters = @{@"post_id": self.post_id ? self.post_id : @"",
                                  @"id": self.pindao_id ? self.pindao_id : @"",
                                  @"gps_lng":lng,
                                  @"gps_lat":lat,
                                  @"addr":addr,
                                  @"begin":[NSString stringWithFormat:@"%ld",(unsigned long)begin],
                                  @"plen":@"15"};
    
    [request urlStr: (self.post_id? [ApiUrl recentlyVisitPostUrlStr]:[ApiUrl recentlyVisitPindaoUrlStr]) parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        if (!customDict[@"ret"]  ) {
            NSLog(@"load failed,msg:%@",customDict[@"msg"]);
            return ;
        }
        self.dataList = !self.dataList || [self.dataList count]<=0 ? [[NSMutableArray alloc]init]:self.dataList;
        
        NSArray* list = customDict[@"list"];
        
        for (NSDictionary *json in list) {
            [self.dataList addObject:json];
        }
        [self.tableView reloadData];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecentlyVisitTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecentlyVisitTableCell"];
    
    NSDictionary* dataItem =self.dataList[indexPath.row];
    
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
    [self intoUserPage:[NSString stringWithFormat:@"%@",dic[@"uid"]]];
}

-(void)intoUserPage:(NSString *)kindId
{
    PersonageSlideVC *sc = [[PersonageSlideVC alloc] initWithUserId:kindId];
    sc.title = GDLocalizedString(@"个人主页");
    sc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sc animated:YES];
}


- (void)dealloc {
    [_footer free];
    [_header free];
}







-(void)showDialog:(NSString *)name{
    
    [self.view setAlpha:0.5];
    CGFloat viewWidth=260;
    CGFloat viewHeight=250;
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake( (DeviceWidth-viewWidth)/2, (DeviceHeight-viewHeight)/2,viewWidth,viewHeight)];
    view.layer.masksToBounds=YES;
    [view.layer setCornerRadius:5.0];
    
    
    
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 48)];
    headerView.backgroundColor=UIColorWithMobanTheme;
    
    UILabel *titleLable=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 210, 48)];
    titleLable.text=@"禁言";
    titleLable.font=[UIFont systemFontOfSize:18];
    titleLable.textColor=[UIColor whiteColor];
    titleLable.adjustsFontSizeToFitWidth = YES;
    [headerView addSubview:titleLable];
    
    
    UIButton  *closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLable.frame), 8, 32,32)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"close_.png"] forState:UIControlStateHighlighted];
    [closeBtn addTarget:self action:@selector(closeDialog) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:closeBtn];
    
    
    [view addSubview:headerView];
    
    UIView *contentView=[[UIView alloc] initWithFrame:CGRectMake(0,48, viewWidth,viewHeight-48)];
    contentView.backgroundColor=[UIColor whiteColor];
    
    UILabel *userLable=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 70, 36)];
    userLable.text=@"用       户";
    userLable.font=[UIFont systemFontOfSize:14];
    userLable.textColor=UIColorFromRGB(0x32373e);
    [contentView addSubview:userLable];
    
    UILabel *showLable=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userLable.frame)+5, 0, 100, 36)];
    showLable.text=name;
    showLable.font=[UIFont systemFontOfSize:14];
    showLable.textColor=UIColorFromRGB(0x32373e);
    showLable.adjustsFontSizeToFitWidth = YES;
    [contentView addSubview:showLable];
    
    
    
    UILabel *lineLable=[[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(showLable.frame),viewWidth-20, 1)];
    lineLable.backgroundColor=UIColorFromRGB(0xdcdddd);
    [contentView addSubview:lineLable];
    
    
    
    UILabel *timeLable=[[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineLable.frame), 70, 48)];
    timeLable.text=@"禁言时间";
    timeLable.font=[UIFont systemFontOfSize:14];
    timeLable.textColor=UIColorFromRGB(0x32373e);
    [contentView addSubview:timeLable];
    
    
    NSArray *timeArray=[NSArray arrayWithObjects:@"1天",@"3天",@"1个星期",@"1个月",@"永久", nil];
    int linenum =(int)(timeArray.count%2==0?timeArray.count/2:(timeArray.count/2)+1);
    UIView *timeView=[[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(userLable.frame)+5, CGRectGetMaxY(lineLable.frame)+5,viewWidth-110, linenum*35)];
    
    for (int i=0; i<timeArray.count; i++) {
        
        int row=i/2;
        int lie=i%2;
        
        CGFloat x=80*lie;
        CGFloat y=35*row+5;
        
        UIButton *oneDayBtn=[[UIButton alloc] initWithFrame:CGRectMake(x,y, 70, 28)];
        
        [oneDayBtn.layer setMasksToBounds:YES];
        [oneDayBtn setTitleColor:UIColorFromRGB(0x32373e) forState:UIControlStateNormal];
        [oneDayBtn.layer setBorderWidth:1.0];
        [oneDayBtn.layer setBorderColor:[UIColorFromRGB(0xdcdddd) CGColor]];
        [oneDayBtn.layer setCornerRadius:12.0];
        [oneDayBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [oneDayBtn setTitle:timeArray[i] forState:UIControlStateNormal];
        [oneDayBtn addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
        oneDayBtn.tag=100+i;
        if (i==0) {
            [self selectTime:oneDayBtn];
        }
        [timeView addSubview:oneDayBtn];
        
    }
    
    [contentView addSubview:timeView];
    
    
    
    UILabel *line2Lable=[[UILabel alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(timeView.frame)+5,viewWidth-20, 1)];
    line2Lable.backgroundColor=UIColorFromRGB(0xdcdddd);
    [contentView addSubview:line2Lable];
    
    
    
    UIButton *okBtn=[[UIButton alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(line2Lable.frame)+5, viewWidth-20, 36)];
    [okBtn.layer setMasksToBounds:YES];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn.layer setCornerRadius:5.0];
    [okBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(clickOk) forControlEvents:UIControlEventTouchUpInside];
    [okBtn setBackgroundColor:UIColorWithMobanTheme];
    [contentView addSubview:okBtn];
    [view addSubview:contentView];
    
    customWindow = [[CustomWindow alloc]initWithView:view];
    
    [customWindow show];
}



-(void)selectTime:(UIButton *)btn{
    if (selectBtn) {
        [selectBtn.layer setBorderColor:[UIColorFromRGB(0xdcdddd) CGColor]];
    }
    [btn.layer setBorderColor:[UIColorWithMobanTheme CGColor]];
    selectBtn=btn;
}



-(int)getMinuteBySelectTag{
    
    
    int result;
    switch (selectBtn.tag) {
        case 100:
            result=24*60;
            break;
        case 101:
            result=3*24*60;
            break;
        case 102:
            result=7*24*60;
            break;
        case 103:
            result=30*24*60;
            break;
        case 104:
            result=3000*24*60;
            break;
    }
    return result;
}

//禁言请求
-(void)clickOk{
    
    int timeMin=[self getMinuteBySelectTag];
    
    NSDictionary* data =self.dataList[_prohibitIndexPath.row];
    
    NSString *appKind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    NetRequest * request =[NetRequest new];
    NSDictionary * parmeters = @{@"uid": [HuaxoUtil getUdidStr],
                                 @"app_uid":data[@"uid"],
                                 @"app_kind":appKind,
                                 @"user_name":data[@"name"],
                                 @"kind_id":self.pindao_id,
                                 @"disable_time":@(timeMin),
                                 @"msg":@""
                                 };
    
    [request urlStr:[ApiUrl getProhibitTalk] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        if ([customDict[@"ret"] integerValue]) {
            [HudUtil showTextDialog:customDict[@"msg"] view:self.view showSecond:1];
            [self closeDialog];
        }else{
            [HuaxoUtil showMsg:@"" title:customDict[@"msg"]];
        }
    }];
    
}


-(void)closeDialog{
    [self.view setAlpha:1.0];
    [customWindow close];
    customWindow.hidden = true;
}


@end
