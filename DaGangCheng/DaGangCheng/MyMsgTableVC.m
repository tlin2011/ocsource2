//
//  MyMsgTableVC.m
//  DaGangCheng
//
//  Created by huaxo on 14-10-22.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import "MyMsgTableVC.h"
#import "MyMsgTableCell.h"
#import "NetRequest.h"
#import "HuaxoUtil.h"
#import "TimeUtil.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MyMsgViewController.h"
#import "PersonageSlideVC.h"
#import "NotifyCenter.h"
#import "UITableView+separator.h"

@interface MyMsgTableVC ()
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation MyMsgTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 73, 0, 0);
    
    [self request:3 begin:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestMessage:) name:[NotifyCenter userNotifyKey] object:nil];
    
    [self.tableView bottomSeparatorHidden];
//    
//    // 去除空白cell
//    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerClass:[MyMsgTableCell class] forCellReuseIdentifier:@"MyMsgTableCell"];
}

- (void)requestMessage:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;

    if ([dic isKindOfClass:[NSDictionary class]] && [dic[@"umsg_new"] integerValue]>0) {
        [self request:3 begin:0];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyMsgTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyMsgTableCell"];
    NSDictionary *dic = self.list[indexPath.row];
    cell.name.text =  dic[@"name"];
    cell.msgLabel.text = dic[@"msg"];
    cell.timeLabel.text= [TimeUtil getFriendlySimpleTime:((NSNumber*)dic[@"time"])];
    BOOL is24Inner = [TimeUtil is24Inner: (dic[@"time"])];
    UIColor* color = is24Inner ? [UIColor redColor]:[UIColor darkGrayColor];
    [cell.timeLabel setTextColor:color];
    
    long imageID = [(NSNumber *)dic[@"tx_id"] integerValue];
    [cell.head sd_setImageWithURL:[NSURL URLWithString:[ApiUrl getImageUrlStrFromID:imageID w:100]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"nm"]];
    cell.head.tag = [dic[@"uid"] integerValue];
    [cell.head addTarget:self action:@selector(txClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if([(NSNumber*)dic[@"msg_new"] intValue]){
        NSString* name  =dic[@"name"];
        NSString* str =[NSString stringWithFormat:@"%@(new)",name];
        NSMutableAttributedString *colorStr =  [[NSMutableAttributedString alloc] initWithString:str];
        //0 0.478431 1 1
        [colorStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] range:NSMakeRange(name.length,5)];
        cell.name.text = str;
        cell.name.attributedText=colorStr;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.list[indexPath.row];

    MyMsgViewController * next =[[MyMsgViewController alloc] init];
    next.title = [NSString stringWithFormat:@"%@%@",GDLocalizedString(@"私信"),dic[@"name"]];
    next.to_name= dic[@"name"];
    next.to_uid = dic[@"uid"];
    
    [self.navigationController pushViewController:next animated:YES];
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    ZBLog(@"%s", __func__);
//    [self.list removeObjectAtIndex:indexPath.row];
//    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
//}

-(void)txClicked:(UIView*)sender
{
    NSString* uid = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    PersonageSlideVC *sc = [[PersonageSlideVC alloc] initWithUserId:uid];
    sc.title = GDLocalizedString(@"个人主页");
    sc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sc animated:YES];
}


#define plen 50
-(void)request:(int) kind begin:(int)pos
{
    //ApiUrl * url =[ApiUrl new];
    NetRequest * request =[NetRequest new];
    
    NSDictionary * parameters = @{@"uid":
                                      [HuaxoUtil getUdidStr],
                                  @"begin": [NSNumber numberWithInt:pos],
                                  @"len": @plen,
                                  @"plen":@plen
                                  };
    
    [request urlStr:[ApiUrl friendListUrlStr:kind] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        NSLog(@"req-kind:%d result:%@",kind,customDict);
        if([(NSNumber*)[customDict objectForKey:@"ret"] intValue]){
            NSArray* list = [customDict objectForKey:@"list"];
            NSLog(@"req-kind:%d list:%@",kind,list);
            
            self.list = [list mutableCopy];
            [self.tableView reloadData];
        } 
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end