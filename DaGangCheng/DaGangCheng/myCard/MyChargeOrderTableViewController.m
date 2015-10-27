//
//  MyChargeOrderTableViewController.m
//  DaGangCheng
//
//  Created by huaxo2 on 15/8/25.
//  Copyright (c) 2015年 huaxo. All rights reserved.
//

#import "MyChargeOrderTableViewController.h"

#import "MyChargeTableViewCell.h"

#import "MyAlipayTableViewCell.h"

#import "DataSigner.h"
#import "Order.h"

#import "CFCurrency.h"
#import <AlipaySDK/AlipaySDK.h>

#define kHexRGBAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


@interface MyChargeOrderTableViewController (){
    //确认支付按钮
    UIButton *btn;
}

@end

@implementation MyChargeOrderTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[MyChargeTableViewCell class] forCellReuseIdentifier:@"MyChargeTableViewCell"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
    
    
    UINib *nib = [UINib nibWithNibName:@"MyAlipayTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"MyAlipayTableViewCell"];

    self.tableView.backgroundColor=kHexRGBAlpha(0xf4f4f4,1);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0) {
        return 2;
        
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyChargeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyChargeTableViewCell"];
    
    
    
    NSString *money=[NSString stringWithFormat:@"%@元",self.chargeOrder.pay_money];
    
    
    if (indexPath.section==0 && indexPath.row==0) {
//        [cell initWithTitle:@"订单名称" value:self.chargeOrder.order_name color:kHexRGBAlpha(0x232323,1)];
        
        [cell initWithTitle:@"订单名称" value:self.chargeOrder.order_name color:kHexRGBAlpha(0x232323,1) titleWidth:80.0];
    }else if (indexPath.section==0 && indexPath.row==1){
        [cell initWithTitle:@"订单总价" value:money color:kHexRGBAlpha(0x232323,1) titleWidth:80.0];
    }
    else if (indexPath.section==1 && indexPath.row==0){
         [cell initWithTitle:@"账户余额" value:@"暂无" color:kHexRGBAlpha(0x232323,1) titleWidth:80.0];
    }
    else if (indexPath.section==2 && indexPath.row==0){
         [cell initWithTitle:@"还需支付" value:money color:kHexRGBAlpha(0xff482f,1) titleWidth:80.0];
        
    }else if (indexPath.section==3){
        
        MyAlipayTableViewCell *alicell = [tableView dequeueReusableCellWithIdentifier:@"MyAlipayTableViewCell"];
        alicell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        alicell.alipayCellDelegate=self;

        return alicell;

    }
    
    return cell;
}



-(void)clickSelectBtn:(BOOL)flag{
    if (flag) {
        btn.enabled=NO;
        btn.backgroundColor=kHexRGBAlpha(0xb5b5b6,1);
    }else{
        btn.enabled=YES;
        btn.backgroundColor=kHexRGBAlpha(0x3FC000,1);
    }
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==3) {
        return 60;
    }
    
    return 48;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==3) {
        return 64;
    }
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        return 32;
//    }
    return 1;
}



//暂时隐藏 section==0的头
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,64)];
//        UILabel *firstLabel=[[UILabel alloc] initWithFrame:CGRectMake(12,0,90, 32)];
//        firstLabel.text=@"当前积分总数 :";
//        firstLabel.font=[UIFont systemFontOfSize:12.0];
//        [view addSubview:firstLabel];
//        
//        UILabel *valueLabel=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(firstLabel.frame),0,80, 32)];
//        valueLabel.text=@"1500分";
//        valueLabel.font=[UIFont systemFontOfSize:12.0];
//        [view addSubview:valueLabel];
//        return view;
//    }else{
//        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,1,1)];
//        return view;
//    }
//}


-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==3) {
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,self.view.frame.size.width,64)];
        btn=[[UIButton alloc] initWithFrame:CGRectMake(12, 16, self.view.frame.size.width-24, 48)];
        btn.backgroundColor=kHexRGBAlpha(0x3fc000,1);
        [btn setTitle:@"确认支付" forState:UIControlStateNormal];
        
        [btn setTitle:@"确认支付" forState:UIControlStateDisabled];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:5.0];
        [btn addTarget:self action:@selector(clickCharge) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
        return view;
    }else{
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,1,1)];
        return view;
    }
    
}


//处理支付宝 或者 银联支付
-(void)clickCharge{    
    
    NSString *partner = @"2088811446500339";
    NSString *seller = @"pay@opencom.cn";
    NSString *privateKey = @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBAKClXb21C3YzSb+BThoGm/simeVlFxr6D8lSRAbNRU8vWFwvCiJw1xJdpX3u1xHt8j2Cz619kv2b9sVkrXZmpK4aNrZh7GfHenP3JXv4SsAf8GqJ9pAsN7DcpDM/Bu6v4xc02YwZiAt/afAomTPty5dl/+yseP6kKAO4sH/G83hTAgMBAAECgYAk5zgMj11trsR/QKX/ZotIep9dygYvxUgBGGvWICuO0DJ9IrUySjet2WNd9ZLkZIPkS3uHwDQXHE/o8oLCkzu7Ac1/AbFjoWq9wyFgmu3qAG2KKOs808KiFcRSgL78xSrRyWqadwBaaeG1nLc69CNi0MJxz8grYd5A7UZWBo9J0QJBAM4O1Wn7fsrw1MP+5tDXKJxQXAjT8aIEasAVX5Qfg9YBhi81XVCFdINHW0K/MNjq3Xg40tRC+BzEqtlbkvMmresCQQDHlOE0D8R26U1X3FRLX3FieX900T2u6/o26F3yDwdW1fhnfprwevB1JxiskRYNVtJyUmyz6DpbfTbWd9AXgX05AkEAx5S8hsOOQphTLGdXPw43CngXPIG0d93ZW6UYB0sjEYQ2aMFCWbx5ZrIVpaezc1bBHjHDms4mrQ6cAJ1ezt428wJBALDWBURvxA/oX5M9saKnCnvKU1haHWFjzOvhr3vOPR5/r/1jfD0fcPcckQw18WgYSZbp2U7+sNZnd7NHraVmImECQBlCD2WMilfey4yluwz93gpNsDCpKoUlb1WggrhF4m4KbPgAWeHHoSOlRPvXEZVAwEEVAUs+ZPoaVXBLPgLtc74=";
    
    
    NSString *money=[NSString stringWithFormat:@"%.2f",[self.chargeOrder.pay_money floatValue]];
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO =self.chargeOrder.order_sn; //订单ID（由商家自行制定）
    order.productName = self.chargeOrder.order_name;
    order.productDescription =self.chargeOrder.order_detail;
    order.amount = money; //商品价格
//    order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
    order.notifyURL = @"http://m.opencom.cn/app_pay/api/alipay_notify.php"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"dagangcheng";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    
    NSString *signedString = [signer signString:orderSpec];
    
    
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//            NSLog(@"reslut = %@",resultDic);

  
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
            
        }];
        
    }
    
}







- (void)back:(id)sender {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
        
//        [self.navigationController po]
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
@end
