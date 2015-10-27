//
//  MyCardPkgTableViewController.m
//  DaGangCheng
//  我的卡包
//  Created by huaxo2 on 15/8/21.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//



#import "MyCardPkgTableViewController.h"
#import "MyCardPkgTableViewCell.h"
#import "MyIntegralViewController.h"

#import "MyIntegralDetailTableViewController.h"

#import "ApiUrl.h"

#import "HudUtil.h"

#import "CFAccount.h"

#import "MJExtension.h"

#import "ZBTNetRequest.h"

static CFAccount *selectAccount;

@interface MyCardPkgTableViewController (){
    ZBTNetRequest *zbtRequest;
}

@end

@implementation MyCardPkgTableViewController


- (void)viewWillAppear:(BOOL)animated  {
    if (!zbtRequest) {
        [self initZBTRequest];
    }
    [self initTableViewData];
}



- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initZBTRequest];
//    [self initTableViewData];
    [self.tableView registerClass:[MyCardPkgTableViewCell class] forCellReuseIdentifier:@"MyCardPkgTableViewCell"];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
}


-(void)initZBTRequest{
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    SQLDataBase * sql =[[SQLDataBase alloc] init];
    NSString* s_id = [sql queryWithCondition:@"session_id"];
    s_id = s_id?s_id:@"";
    
    NSDictionary * prepareDict =@{
                        @"s_id": s_id,
                        @"app_kind":app_kind,
                        @"s_udid":[HuaxoUtil getUdidStr]
                    };
    zbtRequest=[[ZBTNetRequest alloc] initWithBaseUrl:[ApiUrl getCFBaseUrl] prepareDict:prepareDict];
}

-(void)initTableViewData{
    NSDictionary * dict =@{};
    [zbtRequest postJSONWithUrlStr:[ApiUrl getCFAccountList] parameters:dict success:^(id responseObject) {
        NSDictionary* dict = responseObject;
        
        if (dict[@"ret"]) {
            NSDictionary *list=dict[@"list"];
            _accountList= [CFAccount objectArrayWithKeyValuesArray:list];
            [self.tableView reloadData];

        }else{
            [HuaxoUtil showMsg:@"" title:dict[@"msg"]];
        }
        
         } fail:^(NSError *error) {
          NSLog(@"%@", error);
         }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _accountList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyCardPkgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCardPkgTableViewCell"];
    
    CFAccount *account=_accountList[indexPath.row];
    
    NSString *imageName=nil;
    NSString *iconImageName=nil;
    
    NSString *content=nil;
    
    if ([account.currency_type intValue]==1) {
        imageName=@"我的积分-640-背景@2x.png";
        iconImageName=@"我的积分@2x.png";
        content=[NSString stringWithFormat:@"%@%@",account.sum,account.currency_name];
    }else if([account.currency_type intValue]==2){
        imageName=@"账户余额-640-背景@2x.png";
        iconImageName=@"账户余额@2x.png";
        content=[NSString stringWithFormat:@"¥%@",account.sum];
    }else{
        imageName=@"账户余额-640-背景@2x.png";
        iconImageName=@"账户余额@2x.png";
    }

    
    [cell initMyCardPkgTableViewCellWithBGImage:imageName IconImage:iconImageName title:account.currency_name content:content];
    
//    
//    if(indexPath.row==0){
//        [cell initMyCardPkgTableViewCellWithBGImage:@"账户余额-640-背景@2x.png" IconImage: @"账户余额@2x.png" title:@"账户余额" content:@"¥90.00"];
//    }else if (indexPath.row==1){
//        [cell initMyCardPkgTableViewCellWithBGImage:@"我的积分-640-背景@2x.png" IconImage:@"我的积分@2x.png" title:@"我的积分" content:@"81积分"];
//    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return 172;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 12;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 600, 12)];
    view.backgroundColor=[UIColor clearColor];
    return view;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CFAccount *account=_accountList[indexPath.row];
    
  
    if ([account.currency_type intValue]==1) {
        MyIntegralViewController  *mivc=[[MyIntegralViewController alloc] initWithCurrencyId:account.currency_id accountId:account.account_id  currencyType:account.currency_type currencyName:account.currency_name];
        mivc.title=[NSString stringWithFormat:@"我的%@",account.currency_name];
        mivc.hidesBottomBarWhenPushed=NO;
        selectAccount=account;
        [self.navigationController pushViewController:mivc animated:YES];
    }else{
        [HudUtil showTextDialog:@"即将推出，敬请期待！" view:tableView showSecond:2];
    }

}

+(CFAccount *)getCFAccountObject{
    return selectAccount;
}

@end
