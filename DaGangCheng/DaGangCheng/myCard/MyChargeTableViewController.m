//
//  MyChargeTableViewController.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/24.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyChargeTableViewController.h"

#import "MyChargeTableViewCell.h"

#import "MyChargeInputTableViewCell.h"

#import "MyChargeOrderTableViewController.h"

#import "ZBTNetRequest.h"
#import "MJExtension.h"
#import "CFCurrency.h"

#import "CFOrder.h"




@interface MyChargeTableViewController ()<MyChargeInputTableViewCellDelegate>{
    
    CFCurrency *currency;
    CFOrder *order;
    
    UIButton *chargeBtn;
    //需要充值的积分
    int chargeNum;
    
}

@end

@implementation MyChargeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[MyChargeTableViewCell class] forCellReuseIdentifier:@"MyChargeTableViewCell"];
    
    [self.tableView registerClass:[MyChargeInputTableViewCell class] forCellReuseIdentifier:@"MyChargeInputTableViewCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    
    [self getCurrencyId];
    
    if (self.rate && [self.rate intValue]>0) {
        MyChargeTableViewCell *charge = (MyChargeTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UILabel *rateLabel=(UILabel *)[charge viewWithTag:101];
        
        rateLabel.text=[NSString stringWithFormat:@"1:%@",currency.rate];
        
        MyChargeInputTableViewCell *chargeInputCell = (MyChargeInputTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UITextField *chargeInputField=(UITextField *)[chargeInputCell viewWithTag:201];
        chargeInputField.placeholder=[NSString stringWithFormat:@"数值必须为%@的倍数",currency.rate];
        chargeInputCell.rate=[currency.rate integerValue];
    }else{
        [self getCurrencyId];
    }
}




- (void)getCurrencyId {
    
    
    NSDictionary *dict =@{
                          @"currency_id":self.currencyId
                    };
    
    [ZBTNetRequest  postJSONWithBaseUrl:[ApiUrl getCFBaseUrl] urlStr:[ApiUrl getCFCurrency] parameters:dict success:^(id responseObject) {
        NSDictionary *dict2 =responseObject;
        if (dict2[@"ret"]) {
            currency = [CFCurrency objectWithKeyValues:dict2];
            MyChargeTableViewCell *charge = (MyChargeTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            UILabel *rateLabel=(UILabel *)[charge viewWithTag:101];
            
            rateLabel.text=[NSString stringWithFormat:@"1:%@",currency.rate];
          
            MyChargeInputTableViewCell *chargeInputCell = (MyChargeInputTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            UITextField *chargeInputField=(UITextField *)[chargeInputCell viewWithTag:201];
            chargeInputField.placeholder=[NSString stringWithFormat:@"数值必须为%@的倍数",currency.rate];
            chargeInputCell.rate=[currency.rate integerValue];
        }else{
            [HuaxoUtil showMsg:@"" title:dict2[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];
}






#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        MyChargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyChargeTableViewCell"];
        if (indexPath.section==0) {
              [cell initWithTitle:@"当前汇率" value:@"" color:kHexRGBAlpha(0x232323,1) titleWidth:80.0];
        }else{
              [cell initWithTitle:@"所需支付" value:@"0元" color:kHexRGBAlpha(0xff482f,1) titleWidth:80.0];
        }
        return cell;
    }else{
        MyChargeInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyChargeInputTableViewCell"];
        cell.myChargeDelegate=self;
        
        CGFloat width=80.0;
        if (self.currencyName.length==3) {
            width=95;
        }else if (self.currencyName.length==4){
            width=120;
        }
        
        [cell initWithTitle:[NSString stringWithFormat:@"%@充值",self.currencyName] placeholder:@"" color:kHexRGBAlpha(0x232323,1) isNum:YES titleWidth:width];
        
        return cell;
    }
}



-(void)valueChange:(NSString *)value{
    
    int point=[value intValue];
   int rate=[currency.rate intValue];
    
    MyChargeTableViewCell *valueCell = (MyChargeTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    UILabel *rateLabel=(UILabel *)[valueCell viewWithTag:101];
    
    NSString *showMsg=nil;
    if (point%rate==0) {
        if (point/rate>5000) {
            chargeBtn.backgroundColor=kHexRGBAlpha(0xb5b5b6,1);
            chargeBtn.enabled=NO;
            showMsg=@"额度不能超过5000";
        }else if(point==0){
            chargeBtn.backgroundColor=kHexRGBAlpha(0xb5b5b6,1);
            chargeBtn.enabled=NO;
            showMsg=[NSString stringWithFormat:@"0元"];
        }else{
            chargeBtn.enabled=YES;
            [chargeBtn setBackgroundColor:kHexRGBAlpha(0x3FC000,1)];
            showMsg=[NSString stringWithFormat:@"%d元",point/rate];
            chargeNum=point;
        }
    }else{
        chargeBtn.backgroundColor=kHexRGBAlpha(0xb5b5b6,1);
        chargeBtn.enabled=NO;
        showMsg=[NSString stringWithFormat:@"数值必须为%@的倍数",currency.rate];
    }
    rateLabel.text=[NSString stringWithFormat:@"%@",showMsg];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 6;
    }
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}



-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section==1) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,64)];
        
        chargeBtn=[[UIButton alloc] initWithFrame:CGRectMake(12, 16, self.view.frame.size.width-24, 48)];
        
        chargeBtn.backgroundColor=kHexRGBAlpha(0xb5b5b6,1);
        chargeBtn.enabled=NO;
        
        [chargeBtn setTitle:@"马上充值" forState:UIControlStateNormal];
        
        [chargeBtn setTitle:@"马上充值" forState:UIControlStateDisabled];
        
        [chargeBtn.layer setMasksToBounds:YES];
        [chargeBtn.layer setCornerRadius:5.0];
        
        
        [chargeBtn addTarget:self action:@selector(clickCharge2) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:chargeBtn];
        
        return view;
    }else{
         UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,1,1)];
        return view;
    }
}


-(void)clickCharge2{
    
    int paymoney=chargeNum/[currency.rate intValue];
    
    NSDictionary *dict=@{
                        @"pay_money":@(paymoney),
                        @"currency_id":currency.currency_id,
                        @"currency_type":currency.currency_type,
                        @"integral":@(chargeNum),
                        @"rate":currency.rate
                    };
    
    [ZBTNetRequest postJSONWithBaseUrl:[ApiUrl getCFBaseUrl] urlStr:[ApiUrl getCFOrderRecharge] parameters:dict success:^(id responseObject) {
        NSDictionary *result =responseObject;
        if (result[@"ret"]) {
            order = [CFOrder objectWithKeyValues:result];
            MyChargeOrderTableViewController *mcotVc=[[MyChargeOrderTableViewController alloc] initWithStyle:UITableViewStyleGrouped];

            mcotVc.title=[NSString stringWithFormat:@"%@充值",self.currencyName];
            mcotVc.chargeOrder=order;
            mcotVc.currency=currency;
            mcotVc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:mcotVc animated:YES];
        }else{
            [HuaxoUtil showMsg:@"" title:dict[@"msg"]];
        }

    } fail:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}

- (void)back:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
        
}


@end
