//
//  NewGiftChargeTableViewController.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/9/28.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "NewGiftChargeTableViewController.h"

#import "MyChargeTableViewCell.h"

#import "MyChargeInputTableViewCell.h"
#import "CFAccountInfo.h"

#import "MyGoodsTableViewCell.h"


#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]



@interface NewGiftChargeTableViewController (){
    NSString *validateCode;
}


@end

@implementation NewGiftChargeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.diyTitle && ![self.diyTitle isEqualToString:@""]){
        self.title=self.diyTitle;
    }else{
         self.title=[NSString stringWithFormat:@"%@换礼",_accountInfo.currency_name];
    }
    
    
    [self.tableView registerClass:[MyChargeTableViewCell class] forCellReuseIdentifier:@"MyChargeTableViewCell"];
    
    [self.tableView registerClass:[MyChargeInputTableViewCell class] forCellReuseIdentifier:@"MyChargeInputTableViewCell"];
    
       [self.tableView registerClass:[MyGoodsTableViewCell class] forCellReuseIdentifier:@"MyGoodsTableViewCell"];
    
    
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
//        MyChargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyChargeTableViewCell"];
//        
//        if (self.diyName && ![self.diyName isEqualToString:@""]) {
//            
//        }
//        
//        [cell initWithTitle:@"兑换奖品" value:@"asdf" color:kHexRGBAlpha(0x232323,1) titleWidth:80.0];
        
        
        MyGoodsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyGoodsTableViewCell"];
        
        NSString *titleName=@"";
        
        if (self.diyName && ![self.diyName isEqualToString:@""]) {
            titleName=self.diyName;
        }else{
            titleName=@"兑换商品";
        }
        
        [cell initWithTitle:titleName data:self.list];
        
        return cell;
    }else if (indexPath.section==0 && indexPath.row==1){
        MyChargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyChargeTableViewCell"];
        
        int width=80.0;
        
        if (_accountInfo.currency_name.length==3) {
            width=95.0;
        }else if (_accountInfo.currency_name.length==4){
            width=120.0;
        }
        
        NSString *moneyName=@"";
        
        if (self.diyMoney && ![self.diyMoney isEqualToString:@""]) {
            moneyName=self.diyMoney;
        }else{
            moneyName=[NSString stringWithFormat:@"所需%@",_accountInfo.currency_name];
        }
        
        NSString *moneyValue=[NSString stringWithFormat:@"%@%@",self.integral,_accountInfo.currency_name];
        
        [cell initWithTitle:moneyName value:moneyValue color:kHexRGBAlpha(0xff482f,1) titleWidth:80];
        
        return cell;
    }else if (indexPath.section==1 && indexPath.row==0){
        
        MyChargeInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyChargeInputTableViewCell"];
        
        
        UITextField *pwdField=(UITextField *)[cell viewWithTag:121];
        pwdField.secureTextEntry=YES;
        
        
        NSString *passwordName=@"";
        
        if (self.diyPassword && ![self.diyPassword isEqualToString:@""]) {
            passwordName=self.diyPassword;
        }else{
            passwordName=@"兑换密码";
        }
        
        [cell initWithTitle:passwordName placeholder:@"应用登录密码" color:kHexRGBAlpha(0x232323,1) isNum:NO titleWidth:80.0];
        
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
        
        [cell initWithTitle:@"验证码" placeholder:@"验证码" color:kHexRGBAlpha(0x232323,1) isNum:NO titleWidth:80.0];
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
    if(indexPath.section==0 && indexPath.row==0){
        return self.list.count*48;
    }
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
        
        UILabel *valueLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstLabel.frame),0,150, 32)];
        
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
        
        
        NSString *sureTextTitle=@"";
        
        if (self.diySureText && ![self.diySureText isEqualToString:@""]) {
            sureTextTitle=self.diySureText;
        }else{
            sureTextTitle=@"马上兑换";
        }
        
        [btn setTitle:sureTextTitle forState:UIControlStateNormal];
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
    
    
//    if (![self.appKind isEqualToString:app_kind] || ![self.uid isEqualToString:uidStr]) {
//        [HuaxoUtil showMsg:@"" title:@"应用标识或用户标识不对等"];
//        return;
//    }
//    
    
    MyChargeInputTableViewCell *pwdCell = (MyChargeInputTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UITextField *pwdfield=(UITextField *)[pwdCell viewWithTag:121];
    
    
    NSDictionary *pwdParem=@{ @"user":uidStr,
                              @"pwd":pwdfield.text
                              };
    
    
    [ZBTNetRequest  postJSONWithBaseUrl:[ApiUrl v1BaseWithAction:[ApiUrl getCFVerificationPwd]] urlStr:@"" parameters:pwdParem success:^(id responseObject) {
        NSDictionary *dict2 =responseObject;
        if ([dict2[@"ret"] intValue]>0) {
            
            NSDictionary *parameter=@{
                                      @"app_kind":self.appKind,
                                      @"c_uid":self.uid,
                                      @"app_id":self.appId,
                                      @"ocToken":self.token,
                                      @"currency_id":self.currencyId,
                                      @"currency_type":self.currencyType,
                                      @"integral":self.integral,
                                      @"money":self.money,
                                      @"order_state":@1,
                                      @"flag":@1,
                                      @"callback_url":self.callbackUrl,
                                      @"param":self.param,
                                      @"title":self.title,
                                      @"detailsUrl":self.detailsUrl?self.detailsUrl:@"",
                                      @"order_name":self.orderName,
                                      @"info":self.info?self.info:@"",
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


@end
