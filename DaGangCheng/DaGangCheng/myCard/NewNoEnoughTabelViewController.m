//
//  NewNoEnoughTabelViewController.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/9/30.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "NewNoEnoughTabelViewController.h"
#import "MyChargeTableViewCell.h"
#import "MyChargeInputTableViewCell.h"
#import "MyChargeTableViewController.h"
#import "CFCurrency.h"
#import "MJExtension.h"
#import "CFAccountInfo.h"

#import "MyGoodsTableViewCell.h"

#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


@interface NewNoEnoughTabelViewController ()

@end

@implementation NewNoEnoughTabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    if(self.diyTitle && ![self.diyTitle isEqualToString:@""]){
        self.title=self.diyTitle;
    }else{
        self.title=[NSString stringWithFormat:@"%@换礼",_accountInfo.currency_name];
    }

    [self.tableView registerClass:[MyChargeTableViewCell class] forCellReuseIdentifier:@"MyChargeTableViewCell"];
    
        [self.tableView registerClass:[MyGoodsTableViewCell class] forCellReuseIdentifier:@"MyGoodsTableViewCell"];
    
    
    self.tableView.backgroundColor=kHexRGBAlpha(0xf4f4f4,1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyChargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyChargeTableViewCell"];
    if (indexPath.section==0 && indexPath.row==0) {
        
        
        MyGoodsTableViewCell * goodcell = [tableView dequeueReusableCellWithIdentifier:@"MyGoodsTableViewCell"];
        
        NSString *titleName=@"";
        
        if (self.diyName && ![self.diyName isEqualToString:@""]) {
            titleName=self.diyName;
        }else{
            titleName=@"兑换奖品";
        }
        
        [goodcell initWithTitle:titleName data:self.list];
        
        return goodcell;
//       [cell initWithTitle:@"兑换奖品" value:self.goodsName color:kHexRGBAlpha(0x232323,1) titleWidth:80.0];
    }else if (indexPath.section==0 && indexPath.row==1){
        CGFloat width=80.0;
        
        
        
        
        NSString *moneyName=@"";
        
        if (self.diyMoney && ![self.diyMoney isEqualToString:@""]) {
            moneyName=self.diyMoney;
        }else{
            moneyName=[NSString stringWithFormat:@"所需%@",_accountInfo.currency_name];
        }
        
        
        if (moneyName.length==5) {
            width=95.0;
        }else if (moneyName.length==6){
            width=120;
        }

        
        NSString *moneyValue=[NSString stringWithFormat:@"%@%@",self.integral,_accountInfo.currency_name];
        
        
//        [cell initWithTitle:[NSString stringWithFormat:@"所需%@",_accountInfo.currency_name] value:self.integral color:kHexRGBAlpha(0x232323,1) titleWidth:width];

         [cell initWithTitle:moneyName value:moneyValue color:kHexRGBAlpha(0x232323,1) titleWidth:width];
    }
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 126;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 130;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,64)];
    
    UIImageView *mimage=[[UIImageView alloc] initWithFrame:CGRectMake(75,36,24, 24)];
    mimage.image=[UIImage imageNamed:@"错误提示@2x.png"];
    [view addSubview:mimage];
    UILabel *firstLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(mimage.frame)+8,mimage.frame.origin.y,140,24)];
    
    firstLabel.text=[NSString stringWithFormat:@"抱歉 , 您%@不足",_accountInfo.currency_name];
    
    firstLabel.textColor=kHexRGBAlpha(0xff482f,1);
    firstLabel.font=[UIFont systemFontOfSize:14.0];
    [view addSubview:firstLabel];
    
    UILabel *valueLabel=[[UILabel alloc] initWithFrame:CGRectMake(mimage.frame.origin.x-15,CGRectGetMaxY(mimage.frame)+16,230, 32)];
    valueLabel.text=[NSString stringWithFormat:@"您可进行%@充值 , 而后兑换奖品。",_accountInfo.currency_name];
    //@"您可进行积分充值 , 而后兑换奖品。";
    valueLabel.font=[UIFont systemFontOfSize:12.0];
    [view addSubview:valueLabel];
    
    UILabel *thirdLabel=[[UILabel alloc] initWithFrame:CGRectMake(12,CGRectGetMaxY(valueLabel.frame),60, 25)];
    //        thirdLabel.text=[NSString stringWithFormat:@"当前总数:",_accountInfo.currency_name];
    thirdLabel.text=@"当前总数:";
    thirdLabel.font=[UIFont systemFontOfSize:12.0];
    [view addSubview:thirdLabel];
    
    UILabel *fourLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(thirdLabel.frame),thirdLabel.frame.origin.y,150, 25)];
    fourLabel.text=[NSString stringWithFormat:@"%@%@",_accountInfo.sum,_accountInfo.currency_name];
    fourLabel.textAlignment=UITextAlignmentLeft;
    fourLabel.font=[UIFont systemFontOfSize:12.0];
    [view addSubview:fourLabel];
    
    return view;
}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,126)];
    UIButton *btn=[[UIButton alloc] initWithFrame:CGRectMake(12, 16, self.view.frame.size.width-24, 48)];
    btn.backgroundColor=kHexRGBAlpha(0x3fc000,1);
    
    NSString *sureTextTitle=@"";
    
    if (self.diySureText && ![self.diySureText isEqualToString:@""]) {
        sureTextTitle=self.diySureText;
    }else{
        sureTextTitle=[NSString stringWithFormat:@"充值%@",_accountInfo.currency_name];
    }
    
    
//    [btn setTitle:[NSString stringWithFormat:@"充值%@",_accountInfo.currency_name] forState:UIControlStateNormal];
    
     [btn setTitle:sureTextTitle forState:UIControlStateNormal];
    
    [btn.layer setMasksToBounds:YES];
    [btn.layer setCornerRadius:5.0];
    [btn addTarget:self action:@selector(charge) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    
    CGRect noBtnFrame=CGRectMake(12, CGRectGetMaxY(btn.frame)+14, self.view.frame.size.width-24, 48);
    
    ZBAppSetting* appsetting = [ZBAppSetting standardSetting];
    
    if (!appsetting.isOpenPay) {
        [btn setHidden:YES];
        noBtnFrame=CGRectMake(12, 16, self.view.frame.size.width-24, 48);
    }
    
    UIButton *noBtn=[[UIButton alloc] initWithFrame:noBtnFrame];
    noBtn.backgroundColor=kHexRGBAlpha(0xb5b5b6,1);
    
    
    
    
    NSString *cancelTextTitle=@"";
    
    if (self.diyCancelText && ![self.diyCancelText isEqualToString:@""]) {
        cancelTextTitle=self.diyCancelText;
    }else{
        cancelTextTitle=@"暂不兑换";
    }
    
     [noBtn setTitle:cancelTextTitle forState:UIControlStateNormal];
    
//    [noBtn setTitle:@"暂不兑换" forState:UIControlStateNormal];
    [noBtn.layer setMasksToBounds:YES];
    [noBtn.layer setCornerRadius:5.0];
    [noBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:noBtn];
    
    
    
    return view;
}


// 充值积分
-(void)charge{
    
    NSDictionary *dict =@{
                          @"currency_id":self.currencyId
                          };
    
    [ZBTNetRequest  postJSONWithBaseUrl:[ApiUrl getCFBaseUrl] urlStr:[ApiUrl getCFCurrency] parameters:dict success:^(id responseObject) {
        NSDictionary *dict2 =responseObject;
        if ([dict2[@"ret"] intValue]>0) {
            CFCurrency   *tempCurrency = [CFCurrency objectWithKeyValues:dict2];
            MyChargeTableViewController *mctvc=[[MyChargeTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            mctvc.title=[NSString stringWithFormat:@"充值%@",_accountInfo.currency_name];
            mctvc.currencyId=self.currencyId;
            mctvc.currencyName=tempCurrency.currency_name;
            mctvc.rate=tempCurrency.rate;
            mctvc.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:mctvc animated:YES];
        }else{
            [HuaxoUtil showMsg:@"" title:dict2[@"msg"]];
        }
    } fail:^(NSError *error) {
        
    }];
    
}





//暂不充值
-(void)noCharge{
    
}


- (void)back:(id)sender {
    if (self.navigationController) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
