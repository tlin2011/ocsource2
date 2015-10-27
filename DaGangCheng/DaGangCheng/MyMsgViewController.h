//
//  MyMsgViewController.h
//  DaGangCheng
//
//  Created by huaxo on 14-4-14.
//  Copyright (c) 2014年 huaxo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommHead.h"
#import "MyMsgLeftCell.h"
#import "MyMsgRightCell.h"
#import "MsgBoxView.h"

@interface MyMsgViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MsgBoxViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, copy) NSString *ibg_udid;
@property (nonatomic, copy) NSString *my_name;
@property (nonatomic, assign) long my_txid;
@property (nonatomic, copy) NSString *to_uid;
@property (nonatomic, copy) NSString *to_name;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) MsgBoxView *boxView;
- (void)back:(id)sender;
@end
