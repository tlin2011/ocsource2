//
//  UpdateNameTableViewController.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/7.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "UpdateNameTableViewController.h"

#import "UpdatePwdTableViewCell.h"

@interface UpdateNameTableViewController ()

@end

@implementation UpdateNameTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UpdatePwdTableViewCell class] forCellReuseIdentifier:@"UpdatePwdTabelViewCell"];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UpdatePwdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpdatePwdTabelViewCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell initUpdatePwdCell:[UIImage imageNamed:@"change_name_ico.png"] placeholder:self.userName];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(void)clickSave{
   
    NSUInteger section = 0;
    NSUInteger row = 0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    UpdatePwdTableViewCell *oldPass = (UpdatePwdTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    UITextField *userNameField=(UITextField *)[oldPass viewWithTag:112];
    
//    if (userNameField.text && ![userNameField.text isEqualToString:@""]) {
//        [HuaxoUtil showMsg:GDLocalizedString(@"") title:@""];
//    }else{
//        
//    }
    
    [self updateUserName:userNameField.text];
    
    
}



-(void)updateUserName:(NSString *)userName{
    
    
    
    SQLDataBase * sql =[[SQLDataBase alloc] init];
    NSDictionary * userDic =[sql query];
    
    
    //参数
    NSString *appKind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    
    NSString *UIDStr = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"phone_uid"]];
    
    NSString * phoneStr = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"phone"]];
    
    NSDictionary *parameters = @{@"phone": phoneStr,
                                 @"app_kind": appKind,
                                 @"phone_uid": UIDStr,
                                 @"name":userName
                                 };
    

    NetRequest * request =[[NetRequest alloc]init];
    [request urlStr:[ApiUrl changeUserInfo] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        if([customDict[@"ret"] intValue])
        {
          
            
             [sql updateValue:userName key:@"user_name"];
            
              self.userName=userName;
            
            [self.navigationController popViewControllerAnimated:YES];
            
             [self.mtableView reloadData];
            
        } else{
            NSString* msg= customDict[@"msg"];
            [HuaxoUtil showMsg:msg title:@""];
        }
    }];
}


- (void)back:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:self];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
