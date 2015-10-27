//
//  MyIntegralDetailTableViewController.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/25.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyIntegralDetailTableViewController.h"

#import "MyIntegralDetailTableViewCell.h"

#import "ZBTNetRequest.h"

#import "MJExtension.h"

#import "CFAccountDetail.h"


//int page=20;

@interface MyIntegralDetailTableViewController (){
    NSMutableArray  *detailDict;
    
    
    NSMutableDictionary *catchDict;
}

@end

@implementation MyIntegralDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    detailDict =[NSMutableArray array];
    
    catchDict =[NSMutableDictionary dictionary];
    
    [self addHeader];
    [self addFooter];
    
    
   self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    
    
    [self.tableView registerClass:[MyIntegralDetailTableViewCell class] forCellReuseIdentifier:@"MyIntegralDetailTableViewCell"];
    
    self.tableView.showsVerticalScrollIndicator=NO;
    
}



- (void)beginRefreshing:(MJRefreshBaseView *)refreshView {
    int index=0;
    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) {
        index=((int)detailDict.count/20)*20;
    }
    [self initData:refreshView:index];
}



-(void)initData:(MJRefreshBaseView *)refresh :(int)index{
    
    NSDictionary *dict =@{
                          @"index":@(index),
                          @"size":@(20)
    };
    
    [ZBTNetRequest postJSONWithBaseUrl:[ApiUrl getCFBaseUrl] urlStr:[ApiUrl getCFAccountDetail] parameters:dict success:^(id responseObject) {
            NSDictionary *result =responseObject;
            if (result[@"ret"]) {
                NSDictionary *dict2=result[@"list"];
                if (dict2 && dict2.count) {
                    
                    NSArray *newDataArray = [CFAccountDetail objectArrayWithKeyValuesArray:dict2];
                    
                    NSMutableArray *tempArray= [NSMutableArray array];
                    
                    
                    for (int i=0; i<newDataArray.count; i++) {
                        CFAccountDetail *catchDetail=newDataArray[i];
                        
                        id obj =[catchDict objectForKey:catchDetail.create_time_i];
                        if (!obj) {
                            [catchDict setObject:catchDetail.create_time_i forKey:catchDetail.create_time_i];
                            [tempArray addObject:catchDetail];
                        }
                    }
                    
                    
                    if ([refresh isKindOfClass:[MJRefreshHeaderView class]]) {
                         [detailDict insertObjects:tempArray atIndexes:[[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, tempArray.count)]];
                    }else{
                         [detailDict addObjectsFromArray:tempArray];
                    }
                    
                    
                    
                    [self.tableView reloadData];
                    [refresh endRefreshing];
                }else{
                    [refresh noHaveMoreData];
                }
             
            }else{
                [HuaxoUtil showMsg:@"" title:dict[@"msg"]];
                  [refresh loadingDataFail];
            }
    } fail:^(NSError *error) {
        [refresh loadingDataFail];
    }];


    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return detailDict.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CFAccountDetail *detail=detailDict[indexPath.row];
    
    MyIntegralDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIntegralDetailTableViewCell"];

    
    UIColor *color;
    NSString *ind;
    
    if ([detail.order_from intValue]==1) {
        color=kHexRGBAlpha(0x232323,1);
        ind=@"-";
    }else{
        color=kHexRGBAlpha(0x3fc000,1);
        ind=@"+";
    }
    
    NSString *price=[NSString stringWithFormat:@"%@%@",ind,detail.integral];
    
    NSNumber *number=[NSNumber numberWithLongLong:[detail.create_time_i longLongValue]];
    
    NSString *time=[TimeUtil getFriendlySimpleTime:number];
    
    
    [cell initWithSource:detail.order_name title:@"" time:time price:price priceColor:color];
    
//    [cell initWithSource:@"积分商城" title:@"长隆代金卷" time:@"2015-08-06 23:15:15" price:@"-1500" priceColor:kHexRGBAlpha(0x3fc000,1)];
    
    return cell;
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
