//
//  MyMsgBoxTableViewController.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/26.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyMsgBoxTableViewController.h"

#import "ZBTNetRequest.h"
#import "UnReadMsg.h"
#import "MJExtension.h"

#import "MyCardPkgTableViewController.h"

#import "CFAccount.h"


int page=10;



@interface MyMsgBoxTableViewController (){
    NSMutableArray *unreadmsgArray;
    
    NSMutableDictionary *catchDict;
    
    NSIndexPath *deleteIndexPath;
    
    BOOL clicked;
}


@end

@implementation MyMsgBoxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addHeader];
    [self addFooter];
    
    clicked=true;
    unreadmsgArray=[NSMutableArray array];
    catchDict=[NSMutableDictionary dictionary];
    self.tableView.showsVerticalScrollIndicator=NO;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    
    
    UILongPressGestureRecognizer *gestureLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureLongPress:)];
    gestureLongPress.minimumPressDuration =1;
    gestureLongPress.delegate=self;
    [self.tableView addGestureRecognizer:gestureLongPress];

}




-(void)gestureLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    
    //防止重复
    if (clicked) {
        clicked=false;
        CGPoint tmpPointTouch = [gestureRecognizer locationInView:self.tableView];
        if (gestureRecognizer.state ==UIGestureRecognizerStateBegan) {
            deleteIndexPath= [self.tableView indexPathForRowAtPoint:tmpPointTouch];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:GDLocalizedString(@"提示") message:GDLocalizedString(@"您是否要删除该消息记录?") delegate:self cancelButtonTitle:GDLocalizedString(@"取消") otherButtonTitles:GDLocalizedString(@"确定"), nil];
        [alert show];
    }
    
}


- (void)beginRefreshing:(MJRefreshBaseView *)refreshView {
    int index=0;
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
         index=((int)unreadmsgArray.count/page)*page;
    }
   
    [self initData:refreshView index:index];
}



-(void)initData:(MJRefreshBaseView *)refresh index:(int)index{
    NSDictionary *dict=@{
                         @"index": @(index),
                         @"size":@(page)
                         };
    
    [ZBTNetRequest postJSONWithBaseUrl:[ApiUrl getCFBaseUrl] urlStr:[ApiUrl getCFUnreadMsg] parameters:dict success:^(id responseObject) {
        NSDictionary *result =responseObject;
        if (result[@"ret"]) {
            
            NSDictionary *listDict=result[@"list"];
            
            if (listDict  && listDict.count>0) {
                
                 NSArray *newDataArray= [UnReadMsg objectArrayWithKeyValuesArray:listDict];
                
                 NSMutableArray *tempArray= [NSMutableArray array];
                
                for (int i=0; i<newDataArray.count; i++) {
                    UnReadMsg *catchMsg=newDataArray[i];
                    id obj =[catchDict objectForKey:catchMsg.msg_id];
                    if (!obj) {
                        [catchDict setObject:catchMsg.msg_id forKey:catchMsg.msg_id];
                        [tempArray addObject:catchMsg];
                    }
                }
                
                if ([refresh isKindOfClass:[MJRefreshHeaderView class]]) {
                    [unreadmsgArray insertObjects:tempArray atIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0,tempArray.count)]];
                }else{
                    [unreadmsgArray addObjectsFromArray:tempArray];
                }
                
                
                [self.tableView reloadData];
                [refresh endRefreshing];
                
            }else{
                [refresh noHaveMoreData];
            }
           
        }else{
            [HuaxoUtil showMsg:@"" title:dict[@"msg"]];
        }
    } fail:^(NSError *error) {
        [refresh loadingDataFail];
        NSLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return unreadmsgArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UnReadMsg *unreadmsg=unreadmsgArray[indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgBoxCell"];
    if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"msgBoxCell"];
    }
    
    
    NSNumber *number=[NSNumber numberWithLongLong:[unreadmsg.create_time_i longLongValue]];
    
    cell.textLabel.text=[TimeUtil getFriendlySimpleTime:number];
    
    cell.textLabel.textColor=kHexRGBAlpha(0x9fa0a0,1);
    cell.textLabel.font=[UIFont systemFontOfSize:11];
    
    if([unreadmsg.url rangeOfString:@"points"].location !=NSNotFound)
    {
        cell.detailTextLabel.text=@"查看详情";
    }
    else
    {
       cell.detailTextLabel.text=@"联系管理员";
    }

    cell.detailTextLabel.textColor=kHexRGBAlpha(0x9fa0a0,1);
    cell.detailTextLabel.font=[UIFont systemFontOfSize:11];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 28;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 67;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    
   UnReadMsg *unreadmsg=unreadmsgArray[section];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width,67)];
    
    view.backgroundColor=[UIColor whiteColor];
    
    UILabel *titleLable=[[UILabel alloc] initWithFrame:CGRectMake(12, 8,tableView.frame.size.width,34)];
    
    titleLable.textColor=kHexRGBAlpha(0x232323,1);
    titleLable.text=unreadmsg.msg_title;
    titleLable.font=[UIFont systemFontOfSize:14];
    [view addSubview:titleLable];
    
    
    UILabel *detailLable=[[UILabel alloc] initWithFrame:CGRectMake(12,CGRectGetMaxY(titleLable.frame),tableView.frame.size.width,20)];
    
    detailLable.textColor=kHexRGBAlpha(0x727171,1);
    detailLable.font=[UIFont systemFontOfSize:12];
    detailLable.text=unreadmsg.msg_content;
    [view addSubview:detailLable];
    
    return view;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UnReadMsg *unreadmsg=unreadmsgArray[indexPath.section];
    
    
//    unreadmsg.url=@"http://cs.opencom.cn/app/xiaoqiao/points/15/1";
//    [ZBHtmlToApp toWebVCWithUrlStr:unreadmsg.url vc:self];
    
    
    NSString * urlStr=unreadmsg.url;
    
    
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    NSString *appName = app_kind;
    
    appName=[appName substringFromIndex:7];
    
    
    NSString *detailUrlStr = [NSString stringWithFormat:@"http://cs.opencom.cn/app/%@/points/",appName];
    NSString *managerUrlStr = [NSString stringWithFormat:@"http://cs.opencom.cn/app/%@/chat/",appName];
    
    
    
    if ([urlStr hasPrefix:detailUrlStr]) {
        
        NSArray *arr = [urlStr componentsSeparatedByString:@"/"];
        NSString *currencyId = arr[6];
        NSString *currencyType = arr[7];
        
        if ([currencyId length]>0 && [currencyType length]>0) {
            [ZBHtmlToApp toCFDetailVCWithCurrencyId:currencyId currencyType:currencyType vc:self];
            return;
        }
    } else if ([urlStr hasPrefix:managerUrlStr]) {
        
        NSArray *arr = [urlStr componentsSeparatedByString:@"/"];
        
        NSString *userId = arr[6];
        NSString *userName =arr[7];
        
        if ([userId length]>0 && [userName length]>0) {
            [ZBHtmlToApp toChatVCWithUid:userId name:userName vc:self];
            return;
        }
    } else if ([urlStr hasPrefix:@"http"]) {
        [ZBHtmlToApp toWebVCWithUrlStr:urlStr vc:self];
    }
    
    
    
    
//    UnReadMsg *unreadmsg=unreadmsgArray[indexPath.row];
//    

//    
//    if([unreadmsg.url rangeOfString:@"points"].location !=NSNotFound)
//    {
//            UnReadMsg *unreadmsg=unreadmsgArray[indexPath.section];
//            [ZBHtmlToApp toWebVCWithUrlStr:unreadmsg.url vc:self];
//    }
//    else
//    {
//        //处理联系管理员
//        MyMsgViewController * next =[[MyMsgViewController alloc] init];
//        next.title = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"私信"),@"lily"];
//        next.to_name= @"lily";
//        next.to_uid = [NSString stringWithFormat:@"%ld",(long)268996];
//        
//        next.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:next action:@selector(back:)];
//        [next.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -8, 0, 8)];
//        
//        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:next];
//        
//        //3.跳转,视图
//        next.hidesBottomBarWhenPushed = YES;
//        
//        [self presentViewController:navi animated:YES completion:nil];
//    }
    
    
}


-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}


#pragma mark - alertView的代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex == 0) {   // 不保存
            
        } else {                  // 保存
            UnReadMsg *unreadmsg=unreadmsgArray[deleteIndexPath.row];
            NSDictionary *dict=@{
                                 @"msg_id": unreadmsg.msg_id
                                 };
            
            [ZBTNetRequest postJSONWithBaseUrl:[ApiUrl getCFBaseUrl] urlStr:[ApiUrl getCFDeleteMessage] parameters:dict success:^(id responseObject) {
                NSDictionary *result =responseObject;
                if ([result[@"ret"] intValue]>0) {
//                    [HuaxoUtil showMsg:@"" title:@"删除成功"];
                    
                    
                    UnReadMsg *unreadmsg=unreadmsgArray[deleteIndexPath.row];
                    
                    [catchDict removeObjectForKey:unreadmsg.msg_id];
                    [unreadmsgArray removeObjectAtIndex:deleteIndexPath.row];
                    
                    [self.tableView reloadData];
                    
                }else{
                    [HuaxoUtil showMsg:@"" title:dict[@"msg"]];
                }
            } fail:^(NSError *error) {
                NSLog(@"%@",error);
            }];
        }
      clicked=true; //可以在接受手势
}

- (void)back:(id)sender {
    if (self.navigationController) {
        //        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

@end
