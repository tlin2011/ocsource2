//
//  UpdatePwdTableViewController.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/7.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "UpdatePwdTableViewController.h"

#import "UpdatePwdTableViewCell.h"

#import "LineView.h"

#import "MyMD5.h"

#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

@interface UpdatePwdTableViewController ()

@end

@implementation UpdatePwdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UpdatePwdTableViewCell class] forCellReuseIdentifier:@"UpdatePwdTabelViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UpdatePwdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpdatePwdTabelViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell initUpdatePwdCell:[UIImage imageNamed:@"change_passwrod_ico.png"] placeholder:GDLocalizedString(@"6位以上密码") issecurity:YES];
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    
    return YES;
}


-(void)clickSave{

    NSUInteger section = 0;
    NSUInteger section2 = 1;
    NSUInteger row = 0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:row inSection:section2];
    
    UpdatePwdTableViewCell *oldPass = (UpdatePwdTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    UpdatePwdTableViewCell *newPass =  (UpdatePwdTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath2];
    
    
    UITextField *textField=(UITextField *)[oldPass viewWithTag:112];
    UITextField *textField2=(UITextField *)[newPass viewWithTag:112];
    
    
    if (textField.text && [textField.text isEqualToString:@""]) {
          [HuaxoUtil showMsg:GDLocalizedString(@"请输入密码！") title:@""];
        return;
    }
    
    if (textField2.text && [textField2.text isEqualToString:@""]) {
        [HuaxoUtil showMsg:GDLocalizedString(@"请输入密码！") title:@""];
        return;
    }
    
    NSString *oldPwdMd5 = [MyMD5 md5: textField.text];
    
    NSString *newPwdMd5 = [MyMD5 md5: textField2.text];
    
    
    [self updatePassWold:newPwdMd5 oldPwd:oldPwdMd5];
    
}



-(void)updatePassWold:(NSString *)newPwd  oldPwd:(NSString *)oldPwd{
    
    SQLDataBase * sql =[[SQLDataBase alloc] init];
    NSDictionary * userDic =[sql query];

    NSString *UIDStr = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"phone_uid"]];

    
    NSDictionary *parameters = @{@"phone_uid": UIDStr,
                                 @"pwd": oldPwd,
                                 @"new_pwd": newPwd
                                 };
    
    NetRequest * request =[[NetRequest alloc]init];
    [request urlStr:[ApiUrl modifyPasswordUrlStr] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        if([customDict[@"ret"] intValue])
        {
            [HuaxoUtil showMsg:GDLocalizedString(@"密码修改成功") title:@""];
            [self.navigationController popViewControllerAnimated:YES];
            
            
            
        } else{
            NSString* msg= customDict[@"msg"];
            [HuaxoUtil showMsg:msg title:@""];
        }
    }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,30)];
    
    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(20,0, self.view.frame.size.width-50,30)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font=[UIFont systemFontOfSize:14.0];
    label.textColor=kHexRGBAlpha(0x333333,1);
    
    LineView *lv=[[LineView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(label.frame),0,1,43)];
    
    lv.backgroundColor=[UIColor clearColor];
    if (section==0) {
        label.text=GDLocalizedString(@"旧密码");
    }else{
        label.text=GDLocalizedString(@"新密码");
    }
    
    [headerView addSubview:label];
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}


- (void)back:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:self];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
