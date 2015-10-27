//
//  MyIntegralViewController.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/24.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyIntegralViewController.h"
#import "MyGiftTableViewController.h"
#import "MyChargeTableViewController.h"
#import "MyNoEnoughTableViewController.h"

#import "ZBTNetRequest.h"
#import "CFAccountInfo.h"

#import "MJExtension.h"

#import "MyIntegralDetailTableViewController.h"

#import "HudUtil.h"

#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


//AccountId 全局
static NSString *staticAccountId = nil;

@interface MyIntegralViewController (){
    CFAccountInfo *accountInfo;
}


@end

@implementation MyIntegralViewController





- (void)viewWillAppear:(BOOL)animated  {
       [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
//[NSString stringWithFormat:@"%@明细",self.currency_name]
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithTitle:@"明细" style:UIBarButtonItemStyleBordered target:self action:@selector(integralDetail)];
    self.navigationItem.rightBarButtonItem=item;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    
    [self initSubview];
    
    NSString *tempAccountStr=self.accountId;
    [MyIntegralViewController setAccountId:tempAccountStr];
    
}

-(void)integralDetail{
    MyIntegralDetailTableViewController *midtvc=[[MyIntegralDetailTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    midtvc.title=[NSString stringWithFormat:@"%@明细",self.currency_name];
//    midtvc.title=@"明细";
    midtvc.hidesBottomBarWhenPushed=NO;
    [self.navigationController pushViewController:midtvc animated:YES];
}



-(void)initData{
    NSDictionary *dict =@{
                 @"currency_id":self.currencyId,
                 @"currency_type":self.currency_type
    };
    
    [ZBTNetRequest postJSONWithBaseUrl:[ApiUrl getCFBaseUrl] urlStr:[ApiUrl getCFAccountInfo] parameters:dict success:^(id responseObject) {
        
        NSDictionary *dict2 =responseObject;
        
        if ([dict2[@"ret"] intValue]>0) {
            accountInfo = [CFAccountInfo objectWithKeyValues:dict2];
            self.integralLabel.text=[NSString stringWithFormat:@"%@%@",accountInfo.sum,accountInfo.currency_name];
        }else{
            [HuaxoUtil showMsg:@"" title:dict[@"msg"]];
        }
     
    } fail:^(NSError *error) {
        
    }];
    
}

-(instancetype)initWithCurrencyId:(NSString *)currencyId accountId:(NSString *)accountId currencyType:(NSString *)currencyType currencyName:(NSString *)currencyName{
    
//    [[MyCardPkgTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    self=[super init];
    if (self) {
        self.currencyId=currencyId;
        self.accountId=accountId;
        self.currency_type=currencyType;
        self.currency_name=currencyName;
        
    }
    return self;
}

-(void)initSubview{
    
    CGRect integralImageFrame=CGRectMake(self.view.frame.size.width/2-28,94,56,56);
    self.integralImage=[[UIImageView alloc] initWithFrame:integralImageFrame];
    self.integralImage.image=[UIImage imageNamed:@"我的积分-112.png"];
    [self.view addSubview:self.integralImage];
    
    NSLog(@"%@",NSStringFromCGRect(self.integralImage.frame));
    
    CGRect labelFrame=CGRectMake(0,CGRectGetMaxY(self.integralImage.frame)+40,self.view.frame.size.width,80);

    self.integralLabel=[[UILabel alloc] initWithFrame:labelFrame];
//    self.integralLabel.text=@"81积分";
    self.integralLabel.font=[UIFont systemFontOfSize:30];
    self.integralLabel.textAlignment=UITextAlignmentCenter;
    self.integralLabel.textColor=kHexRGBAlpha(0x232323,1);
    [self.view addSubview:self.integralLabel];
    
    
    CGRect chargeButtonFrame=CGRectMake(12,CGRectGetMaxY(self.integralLabel.frame)+48,self.view.frame.size.width-24,48);
    
    self.chargeButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.chargeButton.frame=chargeButtonFrame;
    
    
    [self.chargeButton setTitle:[NSString stringWithFormat:@"%@充值",self.currency_name] forState:UIControlStateNormal];
    [self.chargeButton setTitleColor:kHexRGBAlpha(0xffffff,1) forState:UIControlStateNormal];
    self.chargeButton.backgroundColor=kHexRGBAlpha(0x3fc000,1);
    self.chargeButton.font=[UIFont systemFontOfSize:18];
    [self.chargeButton.layer setMasksToBounds:YES];
    [self.chargeButton.layer setCornerRadius:5.0];
    [self.chargeButton addTarget:self action:@selector(clickCharge) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chargeButton];
    
    CGRect giftButtonFrame=CGRectMake(12,CGRectGetMaxY(self.chargeButton.frame)+14,self.view.frame.size.width-24,48);
  
    
    ZBAppSetting* appsetting = [ZBAppSetting standardSetting];
    
    if (!appsetting.isOpenPay) {
        [self.chargeButton setHidden:YES];
        giftButtonFrame=CGRectMake(12,CGRectGetMaxY(self.integralLabel.frame)+14,self.view.frame.size.width-24,48);
    }
    
    self.giftButton=[[UIButton alloc] init];
    self.giftButton.frame=giftButtonFrame;
    [self.giftButton setTitle:[NSString stringWithFormat:@"%@换礼",self.currency_name] forState:UIControlStateNormal];
    [self.giftButton setTitleColor:kHexRGBAlpha(0xffffff,1) forState:UIControlStateNormal];
    self.giftButton.backgroundColor=kHexRGBAlpha(0xffc051,1);
    self.giftButton.font=[UIFont systemFontOfSize:18];
    [self.giftButton.layer setMasksToBounds:YES];
    [self.giftButton.layer setCornerRadius:5.0];
    [self.giftButton addTarget:self action:@selector(clickExchangeGift) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.giftButton];
    
}


-(void)clickExchangeGift{

    if (accountInfo.ret_signIn) {
         [ZBHtmlToApp toWebVCWithUrlStr:accountInfo.cs vc:self];
        
    }else{
        [HudUtil showTextDialog:@"积分换礼即将推出 , 敬请期待" view:self.view showSecond:2];
    }

}


-(void)clickCharge{
    MyChargeTableViewController *mctvc=[[MyChargeTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    mctvc.title=[NSString stringWithFormat:@"%@充值",self.currency_name];
    mctvc.currencyId=self.currencyId;
    mctvc.currencyName=self.currency_name;
    mctvc.hidesBottomBarWhenPushed=YES;
   // mctvc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:mctvc action:@selector(back:)];
    
    [self.navigationController pushViewController:mctvc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


+ (void)setAccountId:(NSString *)accountId{
    staticAccountId=accountId;
}

+ (NSString *)getAccountId{
    return staticAccountId;
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
