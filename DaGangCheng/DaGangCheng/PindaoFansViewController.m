//
//  PindaoFansViewController.m
//  DaGangCheng
//
//  Created by huaxo on 14-4-16.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "PindaoFansViewController.h"
#import "PersonageSlideVC.h"

#import "ProhibitTalkView.h"

#import "CustomWindow.h"


#import "ZbtUserPm.h"

#import "HudUtil.h"


#import "MJExtension.h"


@interface PindaoFansViewController ()
{
    //ApiUrl * url;
    MJRefreshHeaderView *_header;
    MJRefreshFooterView *_footer;
    
    NSIndexPath *_deleteIndexPath;
    
     NSIndexPath *_prohibitIndexPath;
}
@end

@implementation PindaoFansViewController
@synthesize fansList,mList;
@synthesize kind_id,pm;
@synthesize progressView,timer;

UIButton *selectBtn;

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
    [self requestFans:nil];
    
    //创建长按手势监听
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(myHandleTableviewCellLongPressed:)];
    
    //代理
    longPress.delegate = self;
    longPress.minimumPressDuration = 1.0;
    //将长按手势添加到需要实现长按操作的视图里
    [_fansTableView addGestureRecognizer:longPress];
    
    
}

//长按事件的手势监听实现方法
- (void) myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
        
        CGPoint ponit=[gestureRecognizer locationInView:self.tableView];
        NSLog(@" CGPoint ponit=%f %f",ponit.x,ponit.y);
        NSIndexPath* path=[self.tableView indexPathForRowAtPoint:ponit];
        NSLog(@"row:%ld",(long)path.row);
        //       currRow=path.row;
        
        if (path.section == 0 && path.row != 0)
        {
            //_theData = path.section ==0 ? mList[path.row]:fansList[path.row];
            _theData = mList[path.row];
            
            _deleteIndexPath = path;
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"删除该管理员？") message:@"" delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"确定"), nil];
            
            [alertView show];
            
        }else if(path.section==1){
            
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
//                        if ([tempZbtUserPm.kind_ids[0][@"kind_id"]  intValue]==0) {
                            flag=true;
//                        }
                    }
                    
                }
                if (flag) {
                    _prohibitIndexPath=path;
                    NSDictionary* data =fansList[_prohibitIndexPath.row];
                    [self showDialog:data[@"name"]];
                }
            }];
        }

    }
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSLog(@"UIGestureRecognizerStateChanged");
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
    }
}




-(void)showDialog:(NSString *)userName{
    
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
    showLable.text=userName;
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



-(int)getMinuteBySelectTag:(int)mtag{
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
    
    int timeMin=[self getMinuteBySelectTag:selectBtn.tag];
    
    NSDictionary* data =fansList[_prohibitIndexPath.row];
    NSString *appKind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    NetRequest * request =[NetRequest new];
    NSDictionary * parmeters = @{@"uid": [HuaxoUtil getUdidStr],
                                 @"app_uid":data[@"uid"],
                                 @"app_kind":appKind,
                                 @"user_name":data[@"name"],
                                 @"kind_id":kind_id,
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




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex == 1)
    {
        
        NetRequest * request = [NetRequest new];
        
        NSDictionary * parmeters = @{
                                     @"uid":_theData[@"uid"],
                                     @"kind_id":self.kind_id,
                                     };
        
        
        
        
 //       __weak UITableView *tableView = self.tableView;
        
        
        [request urlStr:[ApiUrl delChannelManagerUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict)
         {
             NSLog(@"del");
             
             [mList removeObject:_theData];
             [self.tableView reloadData];
             
//             dispatch_async(dispatch_get_main_queue(), ^{
//                 
//                 NSArray *array = [NSArray arrayWithObject:_deleteIndexPath];
//                 [tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
//             });

         }
        ];
        
    }
    else
    {
        NSLog(@"点击了Cancel");
    }
}

#pragma mark - -- 上下拉刷新
- (void)addFooter
{
    __unsafe_unretained PindaoFansViewController *vc = self;
    MJRefreshFooterView *footer = [MJRefreshFooterView footer];
    footer.scrollView = self.tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        //[vc neRequestData:anyUrlStr];
        NSLog(@"我想知道有没有");
        // 模拟延迟加载数据，因此2秒后才调用）
        // 这里的refreshView其实就是footer
        
        [vc requestFans:refreshView];
        
        NSLog(@"%@----开始进入刷新状态", refreshView.class);
    };
    _footer = footer;
}

- (void)addHeader
{
    //[dataArray removeAllObjects];
    __unsafe_unretained PindaoFansViewController *vc = self;
    MJRefreshHeaderView *header = [MJRefreshHeaderView header];
    header.scrollView = self.tableView;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *refreshView) {
        // 进入刷新状态就会回调这个Block
        [vc requestFans:refreshView];

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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    if(section==0)
        return [mList count];
    else if(section == 1)
        return [fansList count];
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 51;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 41;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PindaoFansSectionCell * sectionView = [self.tableView dequeueReusableCellWithIdentifier:@"PindaoFansSectionCell"];
    if (section == 0)
    {
        sectionView.titleLabel.text = GDLocalizedString(@"管理员");
        [sectionView.moreBtn addTarget:self action:@selector(addManagerAction:) forControlEvents:UIControlEventTouchUpInside];
        [sectionView.iconView setImage:[UIImage imageNamed:@"dgc_pindao_small_icon_manager.png"]];
        
        if(!(pm>=0 && pm<=1))
        {
            [sectionView.moreBtn setTitle:@"" forState:UIControlStateNormal];
        }
    }
    else if (section == 1)
    {
        sectionView.titleLabel.text = GDLocalizedString(@"粉丝");
        [sectionView.moreBtn setTitle:@"" forState:UIControlStateNormal];
        [sectionView.iconView setImage:[UIImage imageNamed:@"dgc_pindao_small_icon_fans.png"]];
    }
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PindaoFansCell";
    PindaoFansCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSInteger i = indexPath.row;
    if(indexPath.section== 1)
    {
        cell.nameLabel.text = fansList[i][@"name"];
        cell.tipsLabel.text = [HuaxoUtil getFriendlyDistance:(NSNumber*) fansList[i][@"distance"]];
        cell.infoLabel.text = [NSString stringWithFormat:@"%@: %@", GDLocalizedString(@"最近在线"),[TimeUtil getFriendlyTime:(NSNumber*)fansList[i][@"save_time"]]];
        long imageID = [(NSNumber *)[fansList[i] valueForKey:@"tx_id"] integerValue];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:100]] placeholderImage:[UIImage imageNamed:@"nm.png"]];
        cell.imgView.layer.cornerRadius = 5;
        cell.imgView.layer.masksToBounds= YES;
    }else{
        cell.nameLabel.text = mList[i][@"name"];
        int mflag = [(NSNumber*)mList[i][@"pm"] intValue];
        
        
        if(i<fansList.count){
            if (fansList[i][@"creator"]  && [fansList[i][@"creator"] intValue]) {
                mflag = 1;
            }
        }
        
        NSString* tips = [NSString stringWithFormat:@"(%@)",mflag==1||mflag==0? GDLocalizedString(@"创建人"): GDLocalizedString(@"管理员")];
        cell.tipsLabel.text = tips;
        cell.infoLabel.text =  [NSString stringWithFormat:@"%@: %@", GDLocalizedString(@"时间"),[TimeUtil getFriendlyTime:(NSNumber*)mList[i][@"jia_time"]]];
        long imageID = [(NSNumber *)[mList[i] valueForKey:@"tx_id"] integerValue];
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:100]] placeholderImage:[UIImage imageNamed:@"nm.png"]];
        cell.imgView.layer.cornerRadius = 5;
        cell.imgView.layer.masksToBounds= YES;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath:%ld ",(long)indexPath.row);
    
    NSDictionary* data = indexPath.section ==0 ? mList[indexPath.row]:fansList[indexPath.row];
/*
    NetRequest * request = [NetRequest new];
    
    NSDictionary * parmeters = @{
                                 @"uid":data[@"uid"],
                                 @"kind_id":self.kind_id,
                                 };
    
    [request urlStr:[ApiUrl delChannelManagerUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict)
     {
         NSLog(@"del");
         
     }
     ];
    
    [self.tableView reloadData];
     */
    
    
    
    NSString *uid =  [NSString stringWithFormat:@"%@",data[@"uid"]];
    PersonageSlideVC *sc = [[PersonageSlideVC alloc] initWithUserId:uid];
    sc.title = GDLocalizedString(@"个人主页");
    sc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sc animated:YES];
    
    
}

-(IBAction)addManagerAction:(id)sender
{
    UIStoryboard * board =[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //2.进攻,下一球
    SearchUserViewController * next =(SearchUserViewController *)[board instantiateViewControllerWithIdentifier:@"SearchUserViewController"];
    
    next.title = GDLocalizedString(@"搜索用户");
    
    //3.假动作,急停,跳投
    next.kind_id2 = self.kind_id;
    [self.navigationController pushViewController:next animated:YES];
    
}
-(void) requestFans:(MJRefreshBaseView *)refreshView
{
    NetRequest * request = [NetRequest new];
    ////ApiUrl * url = [ApiUrl new];
    
    [self dialogShow];
    
    NSDictionary * parmeters = @{
                                 @"id":self.kind_id,
                                 @"gps_lng":@"",
                                 @"gps_lat":@"",
                                 @"addr":@"",
                                 @"begin":[NSString stringWithFormat:@"%ld",(unsigned long)fansList.count],
                                 @"plen":@"10",
                                 };
    [request urlStr:[ApiUrl fansUrlStr] parameters:parmeters passBlock:^(NSDictionary *customDict) {
        //NSLog(@"粉丝数据%@",customDict);
        
        [self dialogDismiss];
        
   //     NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
        
        if(![(NSNumber*)customDict[@"ret"] intValue])
        {
            NSLog(@"get fans failed,msg:%@",customDict[@"msg"]);
            if (customDict[@"not_have"] && [customDict[@"not_have"] intValue] == 1) {
                [refreshView noHaveMoreData];
                return ;
            }
            [refreshView loadingDataFail];
            return ;
        }
        [refreshView endRefreshing];
        if([fansList count] == 0){
            self.mList    =   [customDict[@"mlist"] mutableCopy];
            pm = [(NSNumber*)customDict[@"pm"] intValue];
        }
        
        fansList = !fansList || [fansList count]<=0 ? [[NSMutableArray alloc]init]:fansList;
        
        NSArray* list = customDict[@"list"];
        
        for(int i=0;i<[list count];i++){
            [fansList addObject:list[i]];
        }
        
        [self.tableView reloadData];
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
    progressView.trackTintColor = [UIColor clearColor];
    progressView.alpha = 0.6;
    progressView.progress = 0;
    progressView.hidden = NO;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(updateProgressTime) userInfo:nil repeats:YES];
}

-(void)updateProgressTime
{
    if(progressView.progress>0.9)
        progressView.progress += 0.001;
    else
        progressView.progress += 0.001;
}

-(void)endProgressTime
{
    progressView.progress += 0.1;
    if(progressView.progress>=1.f)
    {
        if(timer && timer.isValid)
            [timer invalidate];
        
        progressView.hidden = YES;
    }
}
//取消对话框显示
- (void) dialogDismiss{
    if(timer && timer.isValid)
        [timer invalidate];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(endProgressTime) userInfo:nil repeats:YES];
}

- (void)dealloc {
    [_footer free];
    [_header free];
}

@end
