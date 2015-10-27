//
//  MyChargeOrderTableViewController.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/25.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyGiftTableViewController.h"

#import "MyChargeTableViewCell.h"

#import "MyChargeInputTableViewCell.h"
#import "CFAccountInfo.h"


#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

@interface MyGiftTableViewController (){
    NSString *validateCode;
}

@end

@implementation MyGiftTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=[NSString stringWithFormat:@"%@换礼",_accountInfo.currency_name];
    
    [self.tableView registerClass:[MyChargeTableViewCell class] forCellReuseIdentifier:@"MyChargeTableViewCell"];
    
    [self.tableView registerClass:[MyChargeInputTableViewCell class] forCellReuseIdentifier:@"MyChargeInputTableViewCell"];
    
    
    self.tableView.backgroundColor=kHexRGBAlpha(0xf4f4f4,1);


        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0 && indexPath.row==0) {
        MyChargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyChargeTableViewCell"];
        [cell initWithTitle:@"兑换奖品" value:self.goodsName color:kHexRGBAlpha(0x232323,1) titleWidth:80.0];
        return cell;
    }else if (indexPath.section==0 && indexPath.row==1){
         MyChargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyChargeTableViewCell"];
        
        int width=80.0;
        
        if (_accountInfo.currency_name.length==3) {
            width=95.0;
        }else if (_accountInfo.currency_name.length==4){
            width=120.0;
        }
        
        [cell initWithTitle:[NSString stringWithFormat:@"所需%@",_accountInfo.currency_name] value:self.integral color:kHexRGBAlpha(0xff482f,1) titleWidth:width];
          return cell;
    }else if (indexPath.section==1 && indexPath.row==0){
        
        MyChargeInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyChargeInputTableViewCell"];
        
        
        UITextField *pwdField=(UITextField *)[cell viewWithTag:121];
        pwdField.secureTextEntry=YES;
        
        [cell initWithTitle:@"兑换密码" placeholder:@"应用登录密码" color:kHexRGBAlpha(0x232323,1) isNum:NO titleWidth:80.0];
    
        return cell;
        
    }else if (indexPath.section==1 && indexPath.row==1){
        MyChargeInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyChargeInputTableViewCell"];
        
        
        UIButton *myBtn=[[UIButton alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-82, 8, 70, 32)];
        
        [myBtn setBackgroundColor:[UIColor blackColor]];
        [myBtn setTitle:[self getRandomCode] forState:UIControlStateNormal];
        [myBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [myBtn.layer setMasksToBounds:YES];
        [myBtn.layer setCornerRadius:5.0];
        
        [myBtn addTarget:self action:@selector(changeValidateCode:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:myBtn];
        
        [cell initWithTitle:GDLocalizedString(@"验证码") placeholder:GDLocalizedString(@"验证码") color:kHexRGBAlpha(0x232323,1) isNum:NO titleWidth:80.0];
        return cell;
    }
    
    return nil;
}


-(void)changeValidateCode:(UIButton *)sender{
    [sender setTitle:[self getRandomCode] forState:UIControlStateNormal];
}


-(NSString *)getRandomCode{
    
   NSArray *myArray=[[NSArray alloc] initWithObjects:@"2", @"3", @"4", @"5", @"6", @"7",
             @"8", @"9", @"A", @"B", @"C", @"D", @"E",@"F",@"G", @"H", @"I", @"J",
             @"K", @"L", @"M", @"N", @"O", @"P", @"Q",@"R",@"S", @"T", @"U", @"V",
             @"W", @"X", @"Y", @"Z", nil];
    
    NSMutableArray *tempArray=[NSMutableArray array];
    for (int i=0; i<4; i++) {
        int value = arc4random()%myArray.count;
        NSString *first=myArray[value];
        [tempArray addObject:first];
    }
    validateCode=[tempArray componentsJoinedByString:@""];
    return validateCode;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 64;
    }
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 32;
    }
    return 1;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,64)];
        UILabel *firstLabel=[[UILabel alloc] initWithFrame:CGRectMake(12,0,60, 32)];
        firstLabel.text=[NSString stringWithFormat:@"当前总数:"];
        firstLabel.font=[UIFont systemFontOfSize:12.0];
        [view addSubview:firstLabel];
        
        UILabel *valueLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstLabel.frame),0,80, 32)];
//        valueLabel.text=@"1500分";
         valueLabel.text=[NSString stringWithFormat:@"%@%@",self.userPoint,_accountInfo.currency_name];
        
        valueLabel.font=[UIFont systemFontOfSize:12.0];
        [view addSubview:valueLabel];
        return view;
    }else{
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,1,1)];
        return view;
    }
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==1) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,64)];
        UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(12, 16, self.view.frame.size.width-24, 48)];
        btn.backgroundColor=kHexRGBAlpha(0x3fc000,1);
        [btn setTitle:@"马上兑换" forState:UIControlStateNormal];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:5.0];
        [btn addTarget:self action:@selector(exchangeGift) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        return view;
    }else{
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,1,1)];
        return view;
    }
    
}

//兑换礼品 业务逻辑
-(void)exchangeGift{
    
    MyChargeInputTableViewCell *valueCell = (MyChargeInputTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    UITextField *field=(UITextField *)[valueCell viewWithTag:121];
    
    if (![[field.text uppercaseString] isEqualToString:validateCode]) {
        [HuaxoUtil showMsg:@"" title:@"验证码错误"];
        return;
    }
    
    
    
    NSString *app_kind = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"app_kind"];
    
    NSString *uidStr =[HuaxoUtil getUdidStr];
    
    
    if (![self.appKind isEqualToString:app_kind] || ![self.uid isEqualToString:uidStr]) {
        [HuaxoUtil showMsg:@"" title:@"应用标识或用户标识不对等"];
        return;
    }
    
    
    MyChargeInputTableViewCell *pwdCell = (MyChargeInputTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UITextField *pwdfield=(UITextField *)[pwdCell viewWithTag:121];
    

    NSDictionary *pwdParem=@{ @"user":uidStr,
                              @"pwd":pwdfield.text
                              };
    

    [ZBTNetRequest  postJSONWithBaseUrl:[ApiUrl v1BaseWithAction:[ApiUrl getCFVerificationPwd]] urlStr:@"" parameters:pwdParem success:^(id responseObject) {
        NSDictionary *dict2 =responseObject;
        if ([dict2[@"ret"] intValue]>0) {
            
            NSDictionary *parameter=@{@"c_uid":self.uid,
                                      @"oc_uid":self.uid,
                                      @"order_name":self.goodsName,
                                      @"ocToken":self.token,
                                      @"currency_id":self.currencyId,
                                      @"currency_type":self.currencyType,
                                      @"integral":self.integral,
                                      @"order_state":@1,
                                      @"app_id":self.appId,
                                      @"flag":@1,
                                      @"goods_id":self.goodsId,
                                      @"goods_num":self.goodsNum,
                                      @"callback_url":self.callbackUrl
                                      };
            
            [ZBTNetRequest  postJSONWithBaseUrl:[ApiUrl getCFBaseUrl] urlStr:[ApiUrl getPointExchange] parameters:parameter success:^(id responseObject) {
                NSDictionary *dict2 =responseObject;
                if ([dict2[@"ret"] intValue]>0) {
                    [HuaxoUtil showMsg:@"" title:dict2[@"msg"]];
                    [self back:nil];
                }else{
                    [HuaxoUtil showMsg:@"" title:dict2[@"msg"]];
                }
            } fail:^(NSError *error) {
                
            }];
            
        }else{
            [HuaxoUtil showMsg:@"" title:dict2[@"msg"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];

    
}


- (void)back:(id)sender {
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
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

@end
