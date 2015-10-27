//
//  UpdatePhoneTableViewController.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/7.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "UpdatePhoneTableViewController.h"
#import "UpdatePwdTableViewCell.h"

#import "UpdateValidTableViewCell.h"


@interface UpdatePhoneTableViewController (){
    BOOL isOpenValidateCode;
}

@end

@implementation UpdatePhoneTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UpdatePwdTableViewCell class] forCellReuseIdentifier:@"UpdatePwdTabelViewCell"];
    
    [self.tableView registerClass:[UpdateValidTableViewCell class] forCellReuseIdentifier:@"UpdateValidTableViewCell"];
    
    ZBAppSetting* appsetting = [ZBAppSetting standardSetting];
    
   isOpenValidateCode=appsetting.isOpenValidateCode;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row==0) {
        UpdatePwdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpdatePwdTabelViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell initUpdatePwdCell:[UIImage imageNamed:@"change_phone_ico.png"] placeholder:self.phone];
        return cell;

    }else{
        UpdateValidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpdateValidTableViewCell"];
        cell.delegate=self;
        if (!isOpenValidateCode) {
             cell.hidden=YES;
        }
        return cell;
    }
}


-(void)clickSave{
    NSUInteger section = 0;
    
    NSUInteger row = 0;
    
    
    NSUInteger row2=1;
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    
     NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:row2 inSection:section];
    
    UpdatePwdTableViewCell *phoneCell = (UpdatePwdTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
     UpdatePwdTableViewCell *codeCell= (UpdatePwdTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath2];
    

    UITextField *phoneField=(UITextField *)[phoneCell viewWithTag:112];
    UITextField *validField=(UITextField *)[codeCell viewWithTag:111];
    
    [self updatePhone:phoneField.text validaCode:validField.text];
    
}


-(void)updatePhone:(NSString *)phone validaCode:(NSString *)code{
    
    SQLDataBase * sql =[[SQLDataBase alloc] init];
    NSDictionary * userDic =[sql query];
    
    
    //参数
    NSString *appKind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    
    NSString *UIDStr = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"phone_uid"]];
    
    NSString * userName = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"user_name"]];
    
    NSDictionary *parameters = @{@"phone": phone,
                                 @"app_kind": appKind,
                                 @"phone_uid": UIDStr,
                                 @"code":code,
                                 @"name":userName
                                 };
    
    NetRequest * request =[[NetRequest alloc]init];
    [request urlStr:[ApiUrl changeUserInfo] parameters:parameters passBlock:^(NSDictionary *customDict) {
        
        if([customDict[@"ret"] intValue])
        {
            
            [sql updateValue:phone key:@"phone"];
            
            self.phone=phone;
            
//            [HuaxoUtil showMsg:@"手机号码修改成功" title:@""];
            [self.navigationController popViewControllerAnimated:YES];
            
            
            [self.mtableView reloadData];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:nil];
        } else{
            NSString* msg= customDict[@"msg"];
            [HuaxoUtil showMsg:msg title:@""];
        }
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)getValidateCode{
    
    NSUInteger section = 0;
    NSUInteger row = 0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    UpdatePwdTableViewCell *oldPass = (UpdatePwdTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    UITextField *phoneField=(UITextField *)[oldPass viewWithTag:112];
    
    if (phoneField.text && [phoneField.text isEqualToString:@""]) {
          [HuaxoUtil showMsg:GDLocalizedString(@"请输入正确的手机号码") title:@""];
        return;
    }
    
    [self requestAuthCode:phoneField.text];
}


- (void)requestAuthCode:(NSString *)phone {
    
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    NSDictionary *parameters = @{@"phone":phone,
                                 @"app_kind":app_kind,
                                 @"type":@"code",
                                 };
    //执行
    NetRequest * getCodeRequest = [[NetRequest alloc]init];
    
    [getCodeRequest  urlStr:[ApiUrl sendClientSms] parameters:parameters passBlock:^(NSDictionary *customDict) {
        if([customDict[@"ret"] intValue])
        {
            [HuaxoUtil showMsg:GDLocalizedString(@"短信请求已发出请注意查收") title:@""];
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
